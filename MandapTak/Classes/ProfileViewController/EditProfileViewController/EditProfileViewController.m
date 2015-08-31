//
//  EditProfileViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 04/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "EditProfileViewController.h"
#import "PopOverListViewController.h"
#import "WYPopoverController.h"
#import "WYStoryboardPopoverSegue.h"
#import "FPPopoverController.h"
#import "GenderViewController.h"
#import "DateOfBirthPopoverViewController.h"
#import "HeightPopoverViewController.h"
#import "BirthTimePopoverViewController.h"
#import "BasicProfileViewController.h"
#import "DetailProfileViewController.h"
#import "ProfileWorkAndExperienceViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "PhotosOptionPopoverViewController.h"
#import "ImageViewController.h"
#import "ZCImagePickerController.h"
#import "ImageViewCell.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "AppDelegate.h"
#import "FacebooKProfilePictureViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AppData.h"
@interface EditProfileViewController ()<WYPopoverControllerDelegate,HeightPopoverViewControllerDelegate,BasicProfileViewControllerDelegate,DetailProfileViewControllerrDelegate,ProfileWorkAndExperienceViewControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,ZCImagePickerControllerDelegate,WYPopoverControllerDelegate,PhotosOptionPopoverViewControllerDelegate,ImageViewControllerDelegate,FacebooKProfilePictureViewControllerDelegate>
{
    WYPopoverController* popoverController;
    NSUInteger currentTab;
    NSString *selectedGender;
    NSDate *selectedDate;
    NSDate *selectedBirthTime;
    Location *currentLocation;
    PFObject *currentProfile;
    Location *placeOfBirthLocation;
   // NSString *selectedFeets;
    //NSString *selectedInches;
NSString *selectedHeight;
    __weak IBOutlet UIButton *btnMenu;
    UIStoryboard *sb2;
    BasicProfileViewController *vc1;
    DetailProfileViewController *vc2;
    ProfileWorkAndExperienceViewController *vc3;
   // UploadPhotosProfileViewController *vc4;
    __weak IBOutlet UIButton *btnDone;
//    __weak IBOutlet UIButton *btnNext;
    BOOL isSavingFourthTabData;
    __weak IBOutlet UIButton *choosePhotoBtn;
    
    //fourth tab
    NSMutableArray *arrNewImages;
    NSMutableArray *arrOldImages;
    NSMutableArray *arrImageList;
    NSString * selectedImage;
    BOOL isSelectingBiodata;
    BOOL isTakingPhoto;
    NSString *selectedFrom;
    NSString *selectedTo;
    Photos *selectedBiodata;
    UIImage *primaryCropedPhoto;
    Photos *primaryPhoto;
    BOOL isImagePicker;

    __weak IBOutlet UIButton *btnDoneUp;
    __weak IBOutlet UITextField *txtMinBudget;
    __weak IBOutlet UITextField *txtMaxBudget;
}
@property (weak, nonatomic) IBOutlet UIButton *btnTab1;
@property (weak, nonatomic) IBOutlet UIButton *btnTab2;
@property (weak, nonatomic) IBOutlet UIButton *btnTab3;
@property (weak, nonatomic) IBOutlet UIButton *btnTab4;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
- (IBAction)nextBtnAction:(id)sender;
- (IBAction)tabButtonAction:(id)sender;
- (IBAction)homeScreenButtonAction:(id)sender;
- (IBAction)doneButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *tab1View;
@property (weak, nonatomic) IBOutlet UIView *tab2View;
@property (weak, nonatomic) IBOutlet UIView *tab3View;
@property (weak, nonatomic) IBOutlet UIView *tab4View;

@property (nonatomic, retain) IBOutlet UIButton * choosePhotoBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *btnUploadBiodata;
@property (weak, nonatomic) IBOutlet UIImageView *biodataImgView;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    btnDoneUp.hidden = YES;

    sb2 = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    vc1 = [sb2 instantiateViewControllerWithIdentifier:@"BasicProfileViewController"];
    vc2 = [sb2 instantiateViewControllerWithIdentifier:@"DetailProfileViewController"];
    vc3 = [sb2 instantiateViewControllerWithIdentifier:@"ProfileWorkAndExperienceViewController"];
    //vc4 = [sb2 instantiateViewControllerWithIdentifier:@"UploadPhotosProfileViewController"];
    arrNewImages = [NSMutableArray array];
    arrOldImages = [NSMutableArray array];
    
    arrImageList = [NSMutableArray array];
    selectedBiodata = [[Photos alloc]init];
    // [self hideAllView];
    UIColor* whyerColor = [UIColor colorWithRed:240/255.0f green:113/255.0f blue:116/255.0f alpha:1];
//fetch profile for User id
    if([[AppData sharedData]isInternetAvailable]){
        NSString *userId = @"m2vi20vsi4";
        PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
        
        //[query whereKey:@"userId" equalTo:userId];
        [query whereKey:@"objectId" equalTo:@""];

        [query includeKey:@"Parent.Parent"];
        [query includeKey:@"currentLocation.Parent.Parent"];
        [query includeKey:@"placeOfBirth.Parent.Parent"];
        [query includeKey:@"casteId.Parent.Parent"];
        [query includeKey:@"religionId.Pare nt.Parent"];
        [query includeKey:@"gotraId.Parent.Parent"];
        [query includeKey:@"education1.degreeId"];
        [query includeKey:@"education2.degreeId"];
        [query includeKey:@"education3.degreeId"];
        [query includeKey:@"industryId"];
         MBProgressHUD * hud;
         hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        btnMenu.enabled = YES;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (!error) {

                // The find succeeded.
                PFObject *obj= objects[0];
                currentProfile = obj;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateFirstTabWithCurrentInfo" object:self userInfo:@{@"currentProfile": currentProfile}];

                [self switchToCurrentTab];
                [self getAllPhotos];
                [self updateuserInfo];
                
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];

    }
    else{
//       UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"Opps!!" message:@"Please Check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
    }
       WYPopoverBackgroundView* popoverAppearance = [WYPopoverBackgroundView appearance];
    
    [popoverAppearance setTintColor:[UIColor colorWithRed:63./255. green:92./255. blue:128./255. alpha:1]];
    
    [popoverAppearance setOuterCornerRadius:6];
    [popoverAppearance setMinOuterCornerRadius:2];
    [popoverAppearance setInnerCornerRadius:4];
    
    [popoverAppearance setBorderWidth:6];
    [popoverAppearance setArrowBase:32];
    [popoverAppearance setArrowHeight:14];
    
    [popoverAppearance setGlossShadowColor:[UIColor colorWithWhite:1 alpha:0.5]];
    [popoverAppearance setGlossShadowBlurRadius:1];
    [popoverAppearance setGlossShadowOffset:CGSizeMake(0, 1.5)];
    
    [popoverAppearance setOuterShadowColor:[UIColor colorWithRed:16./255. green:50./255. blue:82./255. alpha:1]];
    [popoverAppearance setOuterShadowBlurRadius:8];
    [popoverAppearance setOuterShadowOffset:CGSizeMake(0, 2)];
    
    [popoverAppearance setInnerShadowColor:[UIColor colorWithWhite:0 alpha:1]];
    [popoverAppearance setInnerShadowBlurRadius:3];
    [popoverAppearance setInnerShadowOffset:CGSizeMake(0, 0.5)];
    
    [popoverAppearance setFillTopColor:whyerColor];
    [popoverAppearance setFillBottomColor:whyerColor];

    currentTab =1;
    [self switchToCurrentTab];
    self.btnNext.layer.cornerRadius = 24.0f;
    isImagePicker = YES;
    
    [self updateuserInfo];
    [self setToolBarOnTextField];
    //[self loadData];
    //[self getAlbum];
  //[self allFacebookPhotos];
    // Do any additional setup after loading the view.
}
-(void)setToolBarOnTextField{
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           nil];
    
    [numberToolbar sizeToFit];
    txtMaxBudget.inputAccessoryView = numberToolbar;
    txtMinBudget.inputAccessoryView = numberToolbar;
   // [UIFont fontNamesForFamilyName:@"AmericanTypewriter"]
    [txtMaxBudget setValue:[UIFont fontWithName: @"MYRIADPRO-REGULAR" size: 15] forKeyPath:@"_placeholderLabel.font"];
    [txtMinBudget setValue:[UIFont fontWithName: @"MYRIADPRO-REGULAR" size: 15] forKeyPath:@"_placeholderLabel.font"];



}
-(void)cancelNumberPad{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getAllPhotos{
    //MBProgressHUD * hud;
    //hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];

    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    
    [query whereKey:@"profileId" equalTo:currentProfile];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
///[MBProgressHUD hideHUDForView:self.view animated:YES];

        if (!error) {
            // The find succeeded.
            //[self getPhotoWithObject:objects];
            for(PFObject *object in objects){
               // PFFile *image = (PFFile *)[object objectForKey:@"file"];
                //photo.image = [UIImage imageWithData:image.getData];
                [[object objectForKey:@"file"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    Photos *photo = [[Photos alloc]init];
                    photo.imgObject = object;
                    photo.image = [UIImage imageWithData:data];;
                    [arrOldImages addObject:photo];
                    arrImageList = [NSMutableArray arrayWithArray:[arrOldImages arrayByAddingObjectsFromArray:arrNewImages]];

                    [self.collectionView reloadData];
                    
                }];

                            }

                    } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
- (void)getPhotoWithObject:(NSArray *)objects
{
    
//    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    // Add code here to do background processing
//    //
//    for(PFObject *object in objects){
//        Photos *photo = [[Photos alloc]init];
//        PFFile *image = (PFFile *)[object objectForKey:@"file"];
//        photo.image = [UIImage imageWithData:image.getData];
//        photo.imgObject = object;
//        [arrOldImages addObject:photo];
//    }
//    arrImageList = [NSMutableArray arrayWithArray:[arrOldImages arrayByAddingObjectsFromArray:arrNewImages]];
//    
//    [self.collectionView reloadData];
//    //
//    dispatch_async( dispatch_get_main_queue(), ^{
//        arrImageList = [NSMutableArray arrayWithArray:[arrOldImages arrayByAddingObjectsFromArray:arrNewImages]];
//        
//        [self.collectionView reloadData];
//        // Add code here to update the UI/send notifications based on the
//        // results of the background processing
//    });
//});
    //you can use any string instead "com.mycompany.myqueue"
    dispatch_queue_t backgroundQueue = dispatch_queue_create("com.walkover.photoQueue", 0);
    dispatch_async(backgroundQueue, ^{
        arrImageList= [NSMutableArray array];
        arrOldImages= [NSMutableArray array];
        for(PFObject *object in objects){
            Photos *photo = [[Photos alloc]init];
            PFFile *image = (PFFile *)[object objectForKey:@"file"];
            //photo.image = [UIImage imageWithData:image.getData];
            photo.imgObject = object;
            [arrOldImages addObject:photo];
        }
        arrImageList = [NSMutableArray arrayWithArray:[arrOldImages arrayByAddingObjectsFromArray:arrNewImages]];
        
        [self.collectionView reloadData];


        dispatch_async(dispatch_get_main_queue(), ^{
            arrImageList = [NSMutableArray arrayWithArray:[arrOldImages arrayByAddingObjectsFromArray:arrNewImages]];
            
            [self.collectionView reloadData];

        });
    });
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.view endEditing:YES];
    
    if ([segue.identifier isEqualToString:@"PhotosIdentifier"])
    {
        PhotosOptionPopoverViewController *controller = segue.destinationViewController;
        controller.preferredContentSize = CGSizeMake(300, 140);
        WYStoryboardPopoverSegue* popoverSegue = (WYStoryboardPopoverSegue*)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender
                                             permittedArrowDirections:WYPopoverArrowDirectionAny
                                                             animated:YES];
        isSelectingBiodata = NO;
        popoverController.popoverLayoutMargins = UIEdgeInsetsMake(4, 4, 4, 4);
        popoverController.delegate = self;
        controller.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"BiodataIdentifier"])
    {
        PhotosOptionPopoverViewController *controller = segue.destinationViewController;
        controller.preferredContentSize = CGSizeMake(300, 140);
        WYStoryboardPopoverSegue* popoverSegue = (WYStoryboardPopoverSegue*)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
        isSelectingBiodata =YES;
        popoverController.popoverLayoutMargins = UIEdgeInsetsMake(4, 4, 4, 4);
        popoverController.delegate = self;
        controller.delegate = self;
    }

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
      
}

-(void)hideAllView{
    self.tab1View.hidden = YES;
    self.tab2View.hidden = YES;
    self.tab3View.hidden = YES;
    self.tab4View.hidden = YES;
    [self.btnTab1 setBackgroundColor:[UIColor colorWithRed:240/255.0f green:113/255.0f blue:116/255.0f alpha:1]];
     [self.btnTab2 setBackgroundColor:[UIColor colorWithRed:240/255.0f green:113/255.0f blue:116/255.0f alpha:1]];
     [self.btnTab3 setBackgroundColor:[UIColor colorWithRed:240/255.0f green:113/255.0f blue:116/255.0f alpha:1]];
     [self.btnTab4 setBackgroundColor:[UIColor colorWithRed:240/255.0f green:113/255.0f blue:116/255.0f alpha:1]];
  
}
- (IBAction)nextBtnAction:(id)sender {
    [self removeSubview];
    if (currentTab>=1 &&currentTab<4 ){
        currentTab++;
        btnDone.hidden = YES;
        self.btnNext.hidden = NO;

    }
    else
        currentTab =1;
    
    if(currentTab ==4){
        btnDone.hidden = NO;
        self.btnNext.hidden = YES;
    }

       [self switchToCurrentTab];
  }

- (IBAction)tabButtonAction:(id)sender {
    currentTab = [sender tag];
    [self switchToCurrentTab];
    
    }
#pragma mark PopoverDelegates
-(void)updatedPfObject:(PFObject *)updatedUserProfile{
    if([updatedUserProfile valueForKey:@"name"] !=nil)
        [currentProfile setObject:[updatedUserProfile valueForKey:@"name"]forKey:@"name"];
    if([updatedUserProfile valueForKey:@"dob"] !=nil)
        [currentProfile setObject:[updatedUserProfile valueForKey:@"dob"] forKey:@"dob"];
    if([updatedUserProfile valueForKey:@"gender"] !=nil)
        [currentProfile setObject:[updatedUserProfile valueForKey:@"gender"] forKey:@"gender"];
    if([updatedUserProfile valueForKey:@"tob"] !=nil)
        [currentProfile setObject:[updatedUserProfile valueForKey:@"tob"] forKey:@"tob"];
    if([updatedUserProfile valueForKey:@"currentLocation"] !=nil)
        [currentProfile setObject:[updatedUserProfile valueForKey:@"currentLocation"] forKey:@"currentLocation"];
    if([updatedUserProfile valueForKey:@"placeOfBirth"] !=nil)
        [currentProfile setObject:[updatedUserProfile valueForKey:@"placeOfBirth"] forKey:@"placeOfBirth"];
    // Save
    [currentProfile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    // succesful
        
                } else {
                    //Something bad has ocurred
                    NSString *errorString = [[error userInfo] objectForKey:@"error"];
                    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [errorAlertView show];
                }
            }];

}
-(void)updatedPfObjectForFourthTab:(PFObject *)updatedUserProfile{
    if([updatedUserProfile valueForKey:@"minMarriageBudget"] !=nil)
        [currentProfile setObject:[updatedUserProfile valueForKey:@"minMarriageBudget"]forKey:@"minMarriageBudget"];
    if([updatedUserProfile valueForKey:@"maxMarriageBudget"] !=nil)
        [currentProfile setObject:[updatedUserProfile valueForKey:@"maxMarriageBudget"]forKey:@"maxMarriageBudget"];
    if([updatedUserProfile valueForKey:@"bioData"] !=nil)
        [currentProfile setObject:[updatedUserProfile valueForKey:@"bioData"]forKey:@"bioData"];
    [currentProfile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // succesful
            
        } else {
            //Something bad has ocurred
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];
   }

-(void)updatedPfObjectForSecondTab:(PFObject *)updatedUserProfile{
    if([updatedUserProfile valueForKey:@"weight"] !=nil)
        [currentProfile setObject:[updatedUserProfile valueForKey:@"weight"]forKey:@"weight"];
    if([updatedUserProfile valueForKey:@"height"] !=nil)
        [currentProfile setObject:[updatedUserProfile valueForKey:@"height"]forKey:@"height"];

    if([updatedUserProfile valueForKey:@"casteId"] !=nil)
        [currentProfile setObject:[updatedUserProfile valueForKey:@"casteId"]forKey:@"casteId"];
    else{
        [currentProfile setObject:[NSNull null] forKey:@"casteId"];
        
    }

    if([updatedUserProfile valueForKey:@"religionId"] !=nil)
        [currentProfile setObject:[updatedUserProfile valueForKey:@"religionId"]forKey:@"religionId"];
    else{
        [currentProfile setObject:[NSNull null] forKey:@"religionId"];
        
    }
    if([updatedUserProfile valueForKey:@"gotraId"] !=nil)
        [currentProfile setObject:[updatedUserProfile valueForKey:@"gotraId"]forKey:@"gotraId"];
    else{
        [currentProfile setObject:[NSNull null] forKey:@"gotraId"];

    }
    if([updatedUserProfile valueForKey:@"weight"] !=nil)
        [currentProfile setObject:[updatedUserProfile valueForKey:@"weight"]forKey:@"weight"];
    [currentProfile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // succesful
            
        } else {
            //Something bad has ocurred
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];
    
}

-(void)updatedPfObjectForThirdTab:(PFObject *)updatedUserProfile{
    
    if([updatedUserProfile valueForKey:@"industryId"] !=nil)
        [currentProfile setObject:[updatedUserProfile valueForKey:@"industryId"]forKey:@"industryId"];
    if([updatedUserProfile valueForKey:@"package"] !=nil)
        [currentProfile setObject:[updatedUserProfile valueForKey:@"package"]forKey:@"package"];
    
    if([updatedUserProfile valueForKey:@"designation"] !=nil)
        [currentProfile setObject:[updatedUserProfile valueForKey:@"designation"]forKey:@"designation"];
    else{
        [currentProfile setObject:[NSNull null] forKey:@"designation"];
        
    }
    
    if([updatedUserProfile valueForKey:@"placeOfWork"] !=nil)
        [currentProfile setObject:[updatedUserProfile valueForKey:@"placeOfWork"]forKey:@"placeOfWork"];
    else{
        [currentProfile setObject:[NSNull null] forKey:@"company"];
        
    }
    if([updatedUserProfile valueForKey:@"specialization"] !=nil)
        [currentProfile setObject:[updatedUserProfile valueForKey:@"specialization"]forKey:@"specialization"];
    else{
        [currentProfile setObject:[NSNull null] forKey:@"specialization"];
        
    }
    if([updatedUserProfile valueForKey:@"workAfterMarriage"] !=nil)
        [currentProfile setObject:[updatedUserProfile valueForKey:@"workAfterMarriage"]forKey:@"workAfterMarriage"];
    else{
        [currentProfile setObject:[NSNull null] forKey:@"workAfterMarriage"];
        
    }
    if([updatedUserProfile valueForKey:@"education1"] !=nil)
        [currentProfile setObject:[updatedUserProfile valueForKey:@"education1"]forKey:@"education1"];
    else{
        [currentProfile setObject:[NSNull null] forKey:@"education1"];
        
    }
    if([updatedUserProfile valueForKey:@"education2"] !=nil)
        [currentProfile setObject:[updatedUserProfile valueForKey:@"education2"]forKey:@"education2"];
    else{
        [currentProfile setObject:[NSNull null] forKey:@"education2"];
        
    }
    if([updatedUserProfile valueForKey:@"education3"] !=nil)
        [currentProfile setObject:[updatedUserProfile valueForKey:@"education3"]forKey:@"education3"];
    else{
        [currentProfile setObject:[NSNull null] forKey:@"education3"];
        
    }

    [currentProfile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // succesful
            
        } else {
            //Something bad has ocurred
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];

}
//-(void)selectedHeight:(NSString *)height{
//    selectedHeight = height;
//    [btnHeight setTitle:height forState:UIControlStateNormal];
//    [btnHeight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [popoverController dismissPopoverAnimated:YES];
//}
//-(void)selectedHeightWithFeet:(NSString *)feet andInches:(NSString *)inches{
////    selectedInches= inches;
////    selectedFeets = feet;
//    [btnHeight setTitle:[NSString stringWithFormat:@"%@\'%@\"",feet,inches] forState:UIControlStateNormal];
//    [btnHeight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [popoverController dismissPopoverAnimated:YES];
//
//}
-(void)removeSubview{
    if([self.tab3View.subviews containsObject:vc3.view] && currentTab == 3) {
        [vc3 removeFromParentViewController];
        [vc3.view removeFromSuperview];
    }
    if([self.tab2View.subviews containsObject:vc2.view]&& currentTab == 2) {
        [vc2 removeFromParentViewController];
        [vc2.view removeFromSuperview];
        
    }
    //if([self.tab4View.subviews containsObject:vc4.view]&& currentTab == 4) {
      //  [vc4 removeFromParentViewController];
      // [vc4.view removeFromSuperview];
        
  //  }
    if([self.tab1View.subviews containsObject:vc1.view]&& currentTab == 1) {
        [vc1 removeFromParentViewController];
        [vc1.view removeFromSuperview];
        
    }
}

#pragma mark SwitchTCurrentTab
-(void)switchToCurrentTab{
   [self hideAllView];
    [self.view endEditing:YES];
    if(currentTab ==4){
        btnDone.hidden = NO;
        btnDoneUp.hidden = NO;

        self.btnNext.hidden = YES;
    }
    else{

        if([[currentProfile valueForKey:@"isComplete"] boolValue])
            btnDoneUp.hidden = NO;
        else
            btnDoneUp.hidden = YES;
        btnDone.hidden = YES;
        self.btnNext.hidden = NO;

    }

    switch (currentTab) {
        case 1:
            self.tab1View.hidden = NO;
            vc1.delegate = self;
            vc1.currentProfile = currentProfile;
            [self.tab1View addSubview:vc1.view];
            [self addChildViewController:vc1];
            self.btnTab1.backgroundColor = [UIColor colorWithRed:247/255.0f green:157/255.0f blue:160/255.0f alpha:1];
            break;
        case 2:
            self.tab2View.hidden = NO;
            vc2.delegate = self;
            vc2.currentProfile = currentProfile;
            [self.tab2View addSubview:vc2.view];
            [self addChildViewController:vc2];
            self.btnTab2.backgroundColor = [UIColor colorWithRed:247/255.0f green:157/255.0f blue:160/255.0f alpha:1];
            break;
        case 3:
            self.tab3View.hidden = NO;
            vc3.delegate = self;
            vc3.currentProfile = currentProfile;
            [self.tab3View addSubview:vc3.view];
            [self addChildViewController:vc3];
            self.btnTab3.backgroundColor = [UIColor colorWithRed:247/255.0f green:157/255.0f blue:160/255.0f alpha:1];
            break;
        case 4:
            self.tab4View.hidden = NO;

           // vc4.delegate = self;
            //vc4.currentProfile = currentProfile;
            //[self.tab4View addSubview:vc4.view];
           // [self addChildViewController:vc4];
            self.btnTab4.backgroundColor = [UIColor colorWithRed:247/255.0f green:157/255.0f blue:160/255.0f alpha:1];
            break;

        default:
            break;
    }

}

#pragma mark Actions
- (IBAction)homeScreenButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)updateBioData{
    NSData *pictureData = UIImagePNGRepresentation(selectedBiodata.image);
    NSLog(@"%@",selectedBiodata.name);
    PFFile *file = [PFFile fileWithName:selectedBiodata.name data:pictureData];
    [currentProfile setObject:file forKey:@"bioData"];
    MBProgressHUD * hud;
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [currentProfile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (!error) {
            // succesful
            
        } else {
            //Something bad has ocurred
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];

}
- (IBAction)doneButtonAction:(id)sender {
    switch (currentTab) {
        case 1:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateFirstTabObjects" object:self];
            break;
        case 2:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSecondTabObjects" object:self];
            break;

        case 3:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateThirdTabObjects" object:self];
            break;

        default:
            break;
    }
    if([[AppData sharedData]isInternetAvailable]){
        
        [self updateThePhotoFromPrimary];
        if([txtMinBudget.text integerValue]>0)
            currentProfile[@"minMarriageBudget"] = @([txtMinBudget.text integerValue]);
        if([txtMaxBudget.text integerValue]>0)
            currentProfile[@"maxMarriageBudget"] = @([txtMaxBudget.text integerValue]);
        if(primaryCropedPhoto){
            NSData *pictureData = UIImagePNGRepresentation(primaryCropedPhoto);
            PFFile *file = [PFFile fileWithName:@"profilePic" data:pictureData];
            [currentProfile setObject:file forKey:@"profilePic"];
        }
        
        NSString *name =[currentProfile valueForKey:@"name"];
        NSString *gender =[currentProfile valueForKey:@"gender"];
        NSString *height =[NSString stringWithFormat:@"%@",[currentProfile valueForKey:@"height"]];
        NSString *weight =[NSString stringWithFormat:@"%@",[currentProfile valueForKey:@"weight"]];
        NSString *designation =[currentProfile valueForKey:@"designation"];
        NSString *company =[currentProfile valueForKey:@"placeOfWork"];
        NSString *package =[NSString stringWithFormat:@"%@",[currentProfile valueForKey:@"package"]];

        if(name.length==0 || [name rangeOfString:@" "].location == NSNotFound ||gender.length==0|| [[currentProfile valueForKey:@"currentLocation"] isKindOfClass: [NSNull class]] || [[currentProfile valueForKey:@"tob"] isKindOfClass: [NSNull class]] || [[currentProfile valueForKey:@"dob"] isKindOfClass: [NSNull class]] || [[currentProfile valueForKey:@"placeOfBirth"] isKindOfClass: [NSNull class]] || [[currentProfile valueForKey:@"religionId"] isKindOfClass: [NSNull class]]|| [[currentProfile valueForKey:@"casteId"] isKindOfClass: [NSNull class]]|| height.length==0 || weight.length ==0|| [[currentProfile valueForKey:@"industryId"] isKindOfClass: [NSNull class]]|| designation.length==0 ||company.length==0||[[currentProfile valueForKey:@"workAfterMarriage"] isKindOfClass: [NSNull class]]||package.length==0|| [[currentProfile valueForKey:@"bioData"] isKindOfClass: [NSNull class]]||[[currentProfile valueForKey:@"minMarriageBudget"] isKindOfClass: [NSNull class]]||[[currentProfile valueForKey:@"maxMarriageBudget"] isKindOfClass: [NSNull class]]||primaryPhoto ==nil||selectedBiodata==nil|| [[currentProfile valueForKey:@"education1"] isKindOfClass: [NSNull class]]){
            NSMutableArray *arrMsg = [NSMutableArray array];
            if(name.length==0 ||  [name rangeOfString:@" "].location == NSNotFound){
                [arrMsg addObject:@"valid Full Name"];
            }
            if([currentProfile valueForKey:@"currentLocation"] ==nil){
                [arrMsg addObject:@"Current Location"];
                
            }
            if([currentProfile valueForKey:@"tob"] ==nil){
                [arrMsg addObject:@"Time of Birth"];
            }
            if([currentProfile valueForKey:@"dob"] ==nil ){
                [arrMsg addObject:@"Date of Birth"];
            }
            if( [currentProfile valueForKey:@"placeOfBirth"] ==nil){
                [arrMsg addObject:@"Place of Birth"];
            }
            if( [currentProfile valueForKey:@"religionId"] ==nil){
                [arrMsg addObject:@"Religion"];
            }
            if([currentProfile valueForKey:@"casteId"] ==nil){
                [arrMsg addObject:@"Caste"];
            }
            if([currentProfile valueForKey:@"industryId"] ==nil){
                [arrMsg addObject:@"Industry"];
            }
            if([currentProfile valueForKey:@"minMarriageBudget"] ==nil){
                [arrMsg addObject:@"min marriage budget"];
            }
            if([currentProfile valueForKey:@"maxMarriageBudget"] ==nil){
                [arrMsg addObject:@"max marriage budget"];
            }
            if([currentProfile valueForKey:@"education1"] ==nil){
                [arrMsg addObject:@"Degree and its specialization"];
            }
            
            if(primaryPhoto ==nil){
                [arrMsg addObject:@"select a Primary Photo"];
            }
            if(selectedBiodata ==nil){
                [arrMsg addObject:@"select a Bio Data"];
            }
            NSString *msg =@"Please enter";
            //        for(NSString *str in arrMsg){
            //            [msg stringByAppendingString:[NSString stringWithFormat:@"%@",str]];
            //        }
            for(int i=0; i<arrMsg.count;i++){
                if(i==0)
                    msg=  [msg stringByAppendingString:[NSString stringWithFormat:@" %@",arrMsg[i]]];
                else
                    msg=  [msg stringByAppendingString:[NSString stringWithFormat:@", %@",arrMsg[i]]];
                
            }
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Opps!!" message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else{
            MBProgressHUD * hud;
            hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [currentProfile setObject: @YES  forKey: @"isComplete"];
            [currentProfile setObject: @NO  forKey: @"paid"];

            [currentProfile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                if (!error) {
                    // succesful
                    [self dismissViewControllerAnimated:YES completion:nil];

                    
                } else {
                    //Something bad has ocurred
                    NSString *errorString = [[error userInfo] objectForKey:@"error"];
                    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [errorAlertView show];
                }
            }];
            
        }

    }
    else{
        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"Opps!!" message:@"Please Check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}
-(void)makePhotoToPrimary:(PFObject*)primaryPic{
    [primaryPic setObject:[NSNumber numberWithBool:YES] forKey:@"isPrimary"];
    [primaryPic saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // succesful
            
        } else {
            //Something bad has ocurred
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];
}
-(void)updateThePhotoFromPrimary{
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query whereKey:@"profileId" equalTo:currentProfile];
    [query whereKey:@"isPrimary" equalTo:[NSNumber numberWithBool:YES]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
        if (!error) {
            // Found UserStats
            
            [userStats setObject:[NSNumber numberWithBool:NO] forKey:@"isPrimary"];
            
            // Save
            [userStats saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    // succesful
                    [self makePhotoToPrimary:primaryPhoto.imgObject];
                } else {
                    //Something bad has ocurred
                    [self makePhotoToPrimary:primaryPhoto.imgObject];

                    NSString *errorString = [[error userInfo] objectForKey:@"error"];
                    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [errorAlertView show];
                }
            }];

            
        } else {
            // Did not find any UserStats for the current user
            [self makePhotoToPrimary:primaryPhoto.imgObject];

            NSLog(@"Error: %@", error);
        }
    }];
}
#pragma  mark FourthTabCode

-(void)updateuserInfo{
    if([[currentProfile valueForKey:@"isComplete"] boolValue])
        btnDoneUp.hidden = NO;
    else
        btnDoneUp.hidden = YES;

    if(![[currentProfile valueForKey:@"minMarriageBudget"] isKindOfClass: [NSNull class]]){
        txtMinBudget.text = [NSString stringWithFormat:@"%@",[currentProfile valueForKey:@"minMarriageBudget"] ] ;
    }
    if(![[currentProfile valueForKey:@"profilePic"] isKindOfClass: [NSNull class]]){
//        PFFile *image = (PFFile *)[currentProfile valueForKey:@"profileCropedPhoto"];
//        [[currentProfile objectForKey:@"profileCropedPhoto"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//            primaryCropedPhoto = [UIImage imageWithData:data];;
//        }];
      //  PFFile *image = (PFFile *)[currentProfile valueForKey:@"profilePic"];
        //primaryCropedPhoto = [UIImage imageWithData:image.getData];
        [[currentProfile objectForKey:@"profilePic"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
           primaryCropedPhoto = [UIImage imageWithData:data];
           
        }];

    }
    

    if(![[currentProfile valueForKey:@"maxMarriageBudget"] isKindOfClass: [NSNull class]]){
        txtMaxBudget.text = [NSString stringWithFormat:@"%@",[currentProfile valueForKey:@"maxMarriageBudget"] ] ;
    }
    if(![[currentProfile valueForKey:@"bioData"] isKindOfClass: [NSNull class]]){
        selectedBiodata = [[Photos alloc]init];
        PFFile *image = (PFFile *)[currentProfile valueForKey:@"bioData"];
        NSLog(@"%@",image.name);
             //   PFFile *image1 = (PFFile *)[currentProfile valueForKey:@"bioData"];
                [[currentProfile objectForKey:@"bioData"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    selectedBiodata.image = [UIImage imageWithData:data];
                    selectedBiodata.name = image.name;
                    self.biodataImgView.image =selectedBiodata.image;
                }];
        [self.btnUploadBiodata setTitle:@"Updeted Biodata" forState:UIControlStateNormal];

//        selectedBiodata.image = [UIImage imageWithData:image.getData];
//        selectedBiodata.name = image.name;
//        if(selectedBiodata!=nil){
//            self.biodataImgView.image =selectedBiodata.image;
//            [self.btnUploadBiodata setTitle:selectedBiodata.name forState:UIControlStateNormal];
//        }
    }
    
}

-(void)openFacebookProfileViewController{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    FacebooKProfilePictureViewController *vc = [sb instantiateViewControllerWithIdentifier:@"FacebooKProfilePictureViewController"];
    //vc.globalCompanyId = [self.companies.companyId intValue];
    [self presentViewController:vc animated:YES completion:nil];

}
-(void)loginViaFacebook{
    if ([PFUser currentUser]){
        
    if(![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        NSArray *permissionsArray = @[ @"user_photos",@"public_profile"];
        MBProgressHUD * hud;
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [PFFacebookUtils linkUser:[PFUser currentUser] permissions:permissionsArray block:^(BOOL succeeded, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (succeeded) {
                    
                    NSLog(@"Woohoo, user is linked with Facebook!");
                    [self loadData];
                }
                else {
                    NSLog(@"%@",[error localizedDescription]);
                }
            }];
            
            // Do stuff after successful login.
            NSLog(@"success login");
        } else {
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"facebookDataLoad"] isEqual:@"loaded"]){
                [self openFacebookProfileViewController];
            }
            else
               [self loadData];
        }
    }
    
    NSString *userProfilePhotoURLString = [PFUser currentUser][@"profile"][@"pictureURL"];
    // Download the user's facebook profile picture
    if (userProfilePhotoURLString) {
        NSURL *pictureURL = [NSURL URLWithString:userProfilePhotoURLString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
        
        [NSURLConnection sendAsynchronousRequest:urlRequest
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   if (connectionError == nil && data != nil) {
                                       Photos *photo = [[Photos alloc]init];
                                       photo.image =[UIImage imageWithData:data];
                                       UIImage *image =[UIImage imageWithData:data];
                                       photo.imgObject = nil;
                                       [arrNewImages addObject:photo];
                                       arrImageList = [NSMutableArray arrayWithArray:[arrOldImages arrayByAddingObjectsFromArray:arrNewImages]];

                                       [self.collectionView reloadData];
                                   } else {
                                       NSLog(@"Failed to load profile photo.");
                                   }
                               }];
    }
    
    NSLog(@"%@",[PFUser currentUser]);
}
-(void)allFacebookPhotos{
    //https://graph.facebook.com/[uid]/albums?access_token=[AUTH_TOKEN]
    
   // https://graph.facebook.com/[ALBUM_ID]/photos?access_token=[AUTH_TOKEN]
    FBAccessTokenData *token = [[PFFacebookUtils session] accessTokenData];
    NSString *accessToken =token.accessToken;
    NSString *url =[NSString stringWithFormat:@"https://graph.facebook.com/me?access_token=%@",accessToken];
    NSURL *pictureURL = [NSURL URLWithString:url];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError == nil && data != nil) {
                                   NSError *error;
                                   NSDictionary *responce=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

                                   Photos *photo = [[Photos alloc]init];
                                   photo.image =[UIImage imageWithData:data];
                                   UIImage *image =[UIImage imageWithData:data];
                                   photo.imgObject = nil;
                                   [arrNewImages addObject:photo];
                                   arrImageList = [NSMutableArray arrayWithArray:[arrOldImages arrayByAddingObjectsFromArray:arrNewImages]];
                                   
                                   [self.collectionView reloadData];
                               } else {
                                   NSLog(@"Failed to load profile photo.");
                               }
                           }];

}
- (void)loadData {
    
    // If the user is already logged in, display any previously cached values before we get the latest from Facebook.
    if ([PFUser currentUser]) {
       // [self _updateProfileData];
    }
    
    // Send request to Facebook
    MBProgressHUD * hud;
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    

    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        // handle response
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (!error) {
            // Parse the data received
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            [[NSUserDefaults standardUserDefaults]setObject:[userData valueForKey:@"id"] forKey:@"facebookUserId"];
            if([userData valueForKey:@"id"]){
                [[NSUserDefaults standardUserDefaults]setObject:@"loaded" forKey:@"facebookDataLoad"];
            }
            NSMutableDictionary *userProfile = [NSMutableDictionary dictionaryWithCapacity:7];
            
            if (facebookID) {
                userProfile[@"facebookId"] = facebookID;
            }
            [self openFacebookProfileViewController];
            NSString *name = userData[@"name"];
            if (name) {
                userProfile[@"name"] = name;
            }
            
            NSString *location = userData[@"location"][@"name"];
            if (location) {
                userProfile[@"location"] = location;
            }
            
            NSString *gender = userData[@"gender"];
            if (gender) {
                userProfile[@"gender"] = gender;
            }
            
            NSString *birthday = userData[@"birthday"];
            if (birthday) {
                userProfile[@"birthday"] = birthday;
            }
            
            NSString *relationshipStatus = userData[@"relationship_status"];
            if (relationshipStatus) {
                userProfile[@"relationship"] = relationshipStatus;
            }
            
            userProfile[@"pictureURL"] = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
            
            [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
            [[PFUser currentUser] saveInBackground];
            
           // [self _updateProfileData];
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                    isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
}

-(void)getAlbum{
    if( [[NSUserDefaults standardUserDefaults]valueForKey:@"facebookUserId"]){
        [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@/albums", [[NSUserDefaults standardUserDefaults]valueForKey:@"facebookUserId"]]
                              completionHandler:^(  FBRequestConnection *connection, id result,  NSError *error )
         {
             // result will contain an array with your user's albums in the "data" key
             NSArray * albumsObjects = [result objectForKey:@"data"];
             NSMutableArray * albums = [NSMutableArray arrayWithCapacity:albumsObjects.count];
             
             for (NSDictionary * albumObject in albumsObjects)
             {
                 //DO STUFF
             }
             //self.albums = albums;
             // [self.tableView reloadData];
         }];

    }
   
}
#pragma mark ImageViewControllerDelegate
-(void)selectedPrimaryPhoto:(Photos *)primaryImg andCropedPhoto:(UIImage *)cropedImg andIndex:(NSInteger)index withDeletedPhotos:(NSArray *)arrDeletedPhotos{
    for(Photos *photo in arrDeletedPhotos){
        if([arrImageList containsObject:photo]){
            [arrImageList removeObject:photo];
        }
        if([arrOldImages containsObject:photo]){
            [arrOldImages removeObject:photo];
        }
        if([arrNewImages containsObject:photo]){
            [arrNewImages removeObject:photo];
        }
    }
    arrImageList = [NSMutableArray arrayWithArray:[arrOldImages arrayByAddingObjectsFromArray:arrNewImages]];
    primaryPhoto = primaryImg;
    primaryCropedPhoto = cropedImg;
    [self.collectionView reloadData];
}
#pragma mark PopoverDelegate
-(void)selectedTag:(NSInteger)tag{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    
    switch (tag) {
        case 0:
            //take Photos
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //[self presentModalViewController:picker animated:YES];
            [self presentViewController:picker animated:YES completion:nil];
            isTakingPhoto = YES;
            break;
        case 1:
            //Photo gallery
            
            if(isSelectingBiodata)
                [self launchSingleImagePicker];
            else{
                NSInteger currentCount =arrImageList.count;
                if(currentCount<=8){
                    [self launchImagePickerViewController];
                }
                else{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Opps!!" message:@"You can not insert more then 8 Photos." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                }

            }
            break;
        case 2:
            [self loginViaFacebook];
            //From Facebook
            
            break;
        default:
            break;
    }
    [popoverController dismissPopoverAnimated:YES];
}
#pragma mark UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return arrImageList.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageViewCell"
                                                                     forIndexPath:indexPath];
    
    if(cell!=nil){
        cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageViewCell" forIndexPath:indexPath];
        
    }
    Photos *photo = arrImageList[indexPath.row];
    
    cell.imgView.image =photo.image ;
    if([photo isEqual:primaryPhoto]){
        cell.starImgView.image =[UIImage imageNamed:@"star.png"];
    }
    else if ([[photo.imgObject valueForKey:@"isPrimary"] isEqual:[NSNumber numberWithBool:YES]]){
        cell.starImgView.image =[UIImage imageNamed:@"star.png"];
        primaryPhoto = photo;
    }
    else {
        cell.starImgView.image =[UIImage imageNamed:@""];
        
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    selectedImage = arrImageList[indexPath.row];
    [self.collectionView reloadData];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    ImageViewController *imageViewController = [sb instantiateViewControllerWithIdentifier:@"ImageViewController"];
    imageViewController.selectedImage = arrImageList[indexPath.row];
    imageViewController.arrImages = arrImageList;
    imageViewController.delegate = self;
    imageViewController.currentIndex = indexPath.row;
    //vc.globalCompanyId = [self.companies.companyId intValue];
    
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:imageViewController];
    navController.navigationBarHidden =YES;
    [self presentViewController:navController animated:YES completion:nil];
}


#pragma mark - ZCImagePickerControllerDelegate

- (void)zcImagePickerController:(ZCImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(NSArray *)info {
    [self dismissPickerView];
    
    for (NSDictionary *imageDic in info) {
        Photos *photo = [[Photos alloc]init];
        photo.image =[imageDic objectForKey:UIImagePickerControllerOriginalImage];
        photo.imgObject = nil;
        NSURL *assetURL = [imageDic objectForKey:UIImagePickerControllerReferenceURL];
        __block NSString *fileName = nil;

        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init] ;
        [library assetForURL:assetURL resultBlock:^(ALAsset *asset)  {
            fileName = asset.defaultRepresentation.filename;
            photo.name = fileName;
            [arrNewImages addObject:photo];
            if([[info lastObject] isEqual:imageDic]){
                [self addPhotosToParse];
                arrImageList = [NSMutableArray arrayWithArray:[arrOldImages arrayByAddingObjectsFromArray:arrNewImages]];
                [self.collectionView reloadData];

            }
        } failureBlock:nil];
       

    }
  }
-(void)addPhotosToParse{
    NSMutableArray *arrAllPhotoToBeSaved = [NSMutableArray array];
    for(Photos *photo in arrNewImages){
        NSData *pictureData = UIImagePNGRepresentation(photo.image);
        NSLog(@"%@",photo.name);
        PFFile *file = [PFFile fileWithName:photo.name data:pictureData];
        PFObject *photo = [PFObject objectWithClassName:@"Photo"];
        [photo setObject:file forKey:@"file"];
        [photo setObject:currentProfile forKey:@"profileId"];
        [arrAllPhotoToBeSaved addObject:photo];
        
        if([photo isEqual:primaryPhoto]){
            [photo setObject:[NSNumber numberWithBool:YES] forKey:@"isPrimary"];
        }
        else{
            [photo setObject:[NSNumber numberWithBool:NO] forKey:@"isPrimary"];
            
        }
    }
    MBProgressHUD * hud;
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    

    [PFObject saveAllInBackground:arrAllPhotoToBeSaved block:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (succeeded) {
            NSLog(@"Woohoo!");
            arrNewImages = [NSMutableArray array];
            
            [self getAllPhotos];
        }
        else {
            //Something bad has ocurred
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];

}
- (void)zcImagePickerControllerDidCancel:(ZCImagePickerController *)imagePickerController {
    [self dismissPickerView];
}
-(void)launchSingleImagePicker{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    //_imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if(isSelectingBiodata){
        self.biodataImgView.image =[info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
        
        __block NSString *fileName = nil;
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init] ;
        [library assetForURL:assetURL resultBlock:^(ALAsset *asset)  {
            fileName = asset.defaultRepresentation.filename;
            [self.btnUploadBiodata setTitle:fileName forState:UIControlStateNormal];
            selectedBiodata.name =fileName;
            [self updateBioData];
        } failureBlock:nil];
        NSLog(@"%@",fileName);
        selectedBiodata.image =[info objectForKey:@"UIImagePickerControllerOriginalImage"];
     
    }
    else{
        Photos *photo = [[Photos alloc]init];
        photo.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        photo.imgObject = nil;
        [arrNewImages addObject:photo];
        [self.collectionView reloadData];
    }
    
}


#pragma mark - Private Methods

- (void)launchImagePickerViewController {
    ZCImagePickerController *imagePickerController = [[ZCImagePickerController alloc] init];
    imagePickerController.imagePickerDelegate = self;
    NSInteger currentCount =arrImageList.count;
    if(currentCount<=8){
        imagePickerController.maximumAllowsSelectionCount = 8-currentCount;

    }
    imagePickerController.mediaType = ZCMediaAllAssets;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        // You should present the image picker in a popover on iPad.
        
        // _popoverController = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
        //  [_popoverController presentPopoverFromRect:_launchButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else {
        // Full screen on iPhone and iPod Touch.
        
        [self presentViewController:imagePickerController animated:YES completion:NULL];
    }
}

- (void)dismissPickerView {
    //    if (_popoverController) {
    //        [_popoverController dismissPopoverAnimated:YES];
    //    }
    // else {
    [self dismissViewControllerAnimated:YES completion:NULL];
    // }
}
-(void)selectedProfilePhotoArray:(NSArray *)arrSelectedProfilePics{
    [arrNewImages addObjectsFromArray:arrSelectedProfilePics];
    arrImageList = [NSMutableArray arrayWithArray:[arrOldImages arrayByAddingObjectsFromArray:arrNewImages]];
    [self.collectionView reloadData];
}
@end
