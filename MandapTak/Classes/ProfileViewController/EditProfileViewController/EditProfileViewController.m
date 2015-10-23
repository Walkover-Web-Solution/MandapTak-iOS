
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
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "AppDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AppData.h"
#import "StartMainViewController.h"
#import "SWRevealViewController.h"
#import "Reachability.h"
#import "SCNetworkReachability.h"
#import "FacebooKProfilePictureViewController.h"
#import "PrimaryImagePickerViewController.h"
@interface EditProfileViewController ()<WYPopoverControllerDelegate,BasicProfileViewControllerDelegate,DetailProfileViewControllerrDelegate,ProfileWorkAndExperienceViewControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,ZCImagePickerControllerDelegate,WYPopoverControllerDelegate,PhotosOptionPopoverViewControllerDelegate,ImageViewControllerDelegate,FacebooKProfilePictureViewControllerDelegate,PrimaryImagePickerViewControllerDelegate>
{    SCNetworkReachability *_reachability;
    __weak IBOutlet UIView *navBarView;
    WYPopoverController* popoverController;
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
    NSUInteger currentTab;
    NSString *selectedGender;
    NSDate *selectedDate;
    NSDate *selectedBirthTime;
    Location *currentLocation;
    PFObject *currentProfile;
    Location *placeOfBirthLocation;
  NSString *selectedHeight;
    __weak IBOutlet UIButton *btnMenu;
    UIStoryboard *sb2;
    BasicProfileViewController *vc1;
    DetailProfileViewController *vc2;
    ProfileWorkAndExperienceViewController *vc3;
    __weak IBOutlet UIButton *btnDone;
    BOOL isSavingFourthTabData;
    __weak IBOutlet UIButton *choosePhotoBtn;
    BOOL isPrimaryPhoto;
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
    BOOL isUploadingBiodata;
    BOOL isUploadingPhotos;

    __weak IBOutlet UILabel *rsSymbol1;
    __weak IBOutlet UIImageView *imgLine1;
    __weak IBOutlet UILabel *rsSymbol2;

    __weak IBOutlet UILabel *lblEstimatedBudgettxt;
    __weak IBOutlet UIImageView *imgLine2;
    __weak IBOutlet UIButton *btnDoneUp;
    __weak IBOutlet UITextField *txtMinBudget;
    __weak IBOutlet UITextField *txtMaxBudget;
    __weak IBOutlet UIButton *btnDelete;
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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *uploadPhotoOrignConstraint;
@property (weak, nonatomic) IBOutlet UIButton *choosePrimaryPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *biodataImgView;
- (IBAction)deleteButtonAction:(id)sender;

- (IBAction)choosePrimaryPhotoButtonAction:(id)sender;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    btnDoneUp.hidden = YES;
    btnDelete.hidden = YES;

    sb2 = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    vc1 = [sb2 instantiateViewControllerWithIdentifier:@"BasicProfileViewController"];
    vc2 = [sb2 instantiateViewControllerWithIdentifier:@"DetailProfileViewController"];
    vc3 = [sb2 instantiateViewControllerWithIdentifier:@"ProfileWorkAndExperienceViewController"];
    arrNewImages = [NSMutableArray array];
    arrOldImages = [NSMutableArray array];
    activityIndicator.hidden = YES;
    arrImageList = [NSMutableArray array];
    selectedBiodata = [[Photos alloc]init];
    UIColor* whyerColor = [UIColor colorWithRed:240/255.0f green:113/255.0f blue:116/255.0f alpha:1];
    //fetch profile for User id
    if([[AppData sharedData]isInternetAvailable]){
        PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        [query whereKey:@"objectId" equalTo:[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"]];
        [query includeKey:@"Parent.Parent"];
        [query includeKey:@"currentLocation.Parent.Parent"];
        [query includeKey:@"placeOfBirth.Parent.Parent"];
        [query includeKey:@"casteId.Parent.Parent"];
        [query includeKey:@"religionId.Parent.Parent"];
        [query includeKey:@"gotraId.Parent.Parent"];
        [query includeKey:@"education1.degreeId"];
        [query includeKey:@"education2.degreeId"];
        [query includeKey:@"education3.degreeId"];
        [query includeKey:@"industryId"];
        // [query orderByAscending:@"name"];
         //MBProgressHUD * hud;
         //hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self showLoader];
        btnMenu.enabled = YES;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (!error) {
                [self hideLoader];
                //[MBProgressHUD hideHUDForView:self.view animated:YES];
                // The find succeeded.
                PFObject *obj= objects[0];
                currentProfile = obj;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateFirstTabWithCurrentInfo" object:self userInfo:@{@"currentProfile": currentProfile}];
                [self switchToCurrentTab];
                [self getAllPhotos];
                [self updateuserInfo];
            }
            else if (error.code ==100){
                //[MBProgressHUD hideHUDForView:self.view animated:YES];
                [self hideLoader];

                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection Failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];
            }
            else if (error.code ==209){
                [self hideLoader];
                //[MBProgressHUD hideHUDForView:self.view animated:YES];
                [PFUser logOut];
                PFUser *user = nil;
                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                [currentInstallation setObject:user forKey:@"user"];
                [currentInstallation saveInBackground];
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Loged from another device, Please login again!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                StartMainViewController *vc = [sb instantiateViewControllerWithIdentifier:@"StartMainViewController"];
                [self presentViewController:vc animated:YES completion:nil];
            }
            else {
                [self hideLoader];
                //[MBProgressHUD hideHUDForView:self.view animated:YES];
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];

    }
    else{
        PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
        query.cachePolicy = kPFCachePolicyCacheOnly;
        
        //[query whereKey:@"userId" equalTo:userId];
        [query whereKey:@"objectId" equalTo:[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"]];
        
        [query includeKey:@"Parent.Parent"];
        [query includeKey:@"currentLocation.Parent.Parent"];
        [query includeKey:@"placeOfBirth.Parent.Parent"];
        [query includeKey:@"casteId.Parent.Parent"];
        [query includeKey:@"religionId.Parent.Parent"];
        [query includeKey:@"gotraId.Parent.Parent"];
        [query includeKey:@"education1.degreeId"];
        [query includeKey:@"education2.degreeId"];
        [query includeKey:@"education3.degreeId"];
        [query includeKey:@"industryId"];
        [self showLoader];
        btnMenu.enabled = YES;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (!error) {
                [self hideLoader];
                [self checkIfPrimaryPic];
                // The find succeeded.
                PFObject *obj= objects[0];
                currentProfile = obj;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateFirstTabWithCurrentInfo" object:self userInfo:@{@"currentProfile": currentProfile}];
                
                [self switchToCurrentTab];
                [self getAllPhotos];
                [self updateuserInfo];
                
            }
        }];
       UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"Opps!!" message:@"Please Check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    WYPopoverBackgroundView* popoverAppearance = [WYPopoverBackgroundView appearance];
    
    [popoverAppearance setTintColor:[UIColor colorWithRed:63./255. green:92./255. blue:128./255. alpha:1]];
    
    [popoverAppearance setOuterCornerRadius:6];
    [popoverAppearance setMinOuterCornerRadius:2];
    [popoverAppearance setInnerCornerRadius:4];
    
    [popoverAppearance setBorderWidth:6];
    [popoverAppearance setArrowBase:32];
    [popoverAppearance setArrowHeight:14];
//    
    [popoverAppearance setGlossShadowColor:[UIColor colorWithWhite:1 alpha:0.5]];
    [popoverAppearance setGlossShadowBlurRadius:1];
    [popoverAppearance setGlossShadowOffset:CGSizeMake(0, 1.5)];
//
//    [popoverAppearance setOuterShadowColor:[UIColor colorWithRed:16./255. green:50./255. blue:82./255. alpha:1]];
//    [popoverAppearance setOuterShadowBlurRadius:8];
//    [popoverAppearance setOuterShadowOffset:CGSizeMake(0, 2)];
//    
//    [popoverAppearance setInnerShadowColor:[UIColor colorWithWhite:0 alpha:1]];
//    [popoverAppearance setInnerShadowBlurRadius:3];
//    [popoverAppearance setInnerShadowOffset:CGSizeMake(0, 0.5)];
    
    [popoverAppearance setFillTopColor:whyerColor];
    [popoverAppearance setFillBottomColor:whyerColor];

    currentTab =1;
    [self switchToCurrentTab];
    self.btnNext.layer.cornerRadius = 24.0f;
    isImagePicker = YES;
    
    [self updateuserInfo];
    [self setToolBarOnTextField];
    navBarView.layer.shadowColor = [UIColor colorWithRed:240/255.0f green:113/255.0f blue:116/255.0f alpha:.9].CGColor;
    navBarView.layer.shadowOffset = CGSizeMake(0, 5);
    navBarView.layer.shadowOpacity = 1;
    navBarView.layer.shadowRadius = 1.0;
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];

    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
    choosePhotoBtn.hidden = YES;
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    CATransition *transition = [CATransition animation];
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        if(currentTab<4){
            currentTab++;
            transition.duration = .3f;
            [transition setType:kCATransitionPush];
            [transition setSubtype:kCATransitionFromRight];
        }
        else{
            [transition setType:kCATransition];
            transition.duration = 0.0f;
        }
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        if(currentTab>1){
            currentTab--;
            transition.duration = .3f;
            [transition setType:kCATransitionPush];
            [transition setSubtype:kCATransitionFromLeft];
        }
        else{
            [transition setType:kCATransition];
            transition.duration = 0.0f;
        }
    }
    [self.tab1View.layer addAnimation:transition forKey:nil];
    [self.tab2View.layer addAnimation:transition forKey:nil];
    [self.tab3View.layer addAnimation:transition forKey:nil];
    [self.tab4View.layer addAnimation:transition forKey:nil];

    [self switchToCurrentTab];
    
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
-(void)checkIfPrimaryPic{
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query whereKey:@"profileId" equalTo:currentProfile];
    [query whereKey:@"isPrimary" equalTo:[NSNumber numberWithBool:YES]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if(objects.count>0){
                isPrimaryPhoto = YES;
                choosePhotoBtn.hidden = NO;
            }
        } else {
            [self makePhotoToPrimary:primaryPhoto.imgObject];
            
            NSLog(@"Error: %@", error);
        }
    }];

}
-(void)getAllPhotos{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query clearCachedResult];
    [query whereKey:@"profileId" equalTo:currentProfile];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        if (!error) {
            arrOldImages = [NSMutableArray array];
            for(PFObject *object in objects){
                NSString *strIsPrimary =[NSString stringWithFormat:@"%@",[object valueForKey:@"isPrimary"] ] ;
                if([strIsPrimary integerValue]){
                    isPrimaryPhoto = YES;
                }
                [[object objectForKey:@"file"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    Photos *photo = [[Photos alloc]init];
                    photo.imgObject = object;
                    photo.image = [UIImage imageWithData:data];;
                    [arrOldImages addObject:photo];
                    arrImageList = [NSMutableArray arrayWithArray:[arrOldImages arrayByAddingObjectsFromArray:arrNewImages]];
                    [self.collectionView reloadData];
                    choosePhotoBtn.hidden = NO;
                    [self.choosePhotoBtn setTitle:@"+Upload Photos" forState:UIControlStateNormal];

                }];
            }
        }
           }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.view endEditing:YES];
    
    if ([segue.identifier isEqualToString:@"PhotosIdentifier"])
    {
        PhotosOptionPopoverViewController *controller = segue.destinationViewController;
        controller.preferredContentSize = CGSizeMake(300, 152);
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
        controller.preferredContentSize = CGSizeMake(300, 102);
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
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    if([identifier isEqualToString:@"BiodataIdentifier"]){
        if(isUploadingBiodata)
            return NO;
        else
            return YES;
    }
    
    if([identifier isEqualToString:@"PhotosIdentifier"]){
        if(isUploadingPhotos)
            return NO;
        else
            return YES;
    }

        return YES;
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
    [self removeSubview];
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
     }];
}

-(void)updatedPfObjectForSecondTab:(PFObject *)updatedUserProfile{
    if([updatedUserProfile valueForKey:@"weight"] !=nil)
        [currentProfile setObject:[updatedUserProfile valueForKey:@"weight"]forKey:@"weight"];
    if([updatedUserProfile valueForKey:@"manglik"] !=nil)
        [currentProfile setObject:[updatedUserProfile valueForKey:@"manglik"]forKey:@"manglik"];

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
        }];

}
-(void)removeSubview{
    if([self.tab3View.subviews containsObject:vc3.view] && currentTab == 3) {
        [vc3 removeFromParentViewController];
        [vc3.view removeFromSuperview];
        
    }
    if([self.tab2View.subviews containsObject:vc2.view]&& currentTab == 2) {
        [vc2 removeFromParentViewController];
        [vc2.view removeFromSuperview];
        
    }
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
       // [self FbLogin];
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
            //vc1 = [sb2 instantiateViewControllerWithIdentifier:@"BasicProfileViewController"];
            self.tab1View.hidden = NO;
            vc1.delegate = self;
            vc1.currentProfile = currentProfile;
            [self.tab1View addSubview:vc1.view];
            [self addChildViewController:vc1];
            self.btnTab1.backgroundColor = [UIColor colorWithRed:247/255.0f green:157/255.0f blue:160/255.0f alpha:1];
            break;
        case 2:
            vc2 = [sb2 instantiateViewControllerWithIdentifier:@"DetailProfileViewController"];
            self.tab2View.hidden = NO;
            vc2.delegate = self;
            vc2.currentProfile = currentProfile;
            [self.tab2View addSubview:vc2.view];
            [self addChildViewController:vc2];
            self.btnTab2.backgroundColor = [UIColor colorWithRed:247/255.0f green:157/255.0f blue:160/255.0f alpha:1];
            break;
        case 3:
            vc3 = [sb2 instantiateViewControllerWithIdentifier:@"ProfileWorkAndExperienceViewController"];
            self.tab3View.hidden = NO;
            vc3.delegate = self;
            vc3.currentProfile = currentProfile;
            [self.tab3View addSubview:vc3.view];
            [self addChildViewController:vc3];
            self.btnTab3.backgroundColor = [UIColor colorWithRed:247/255.0f green:157/255.0f blue:160/255.0f alpha:1];
            break;
        case 4:
            self.tab4View.hidden = NO;
            [self askCammeraRollPermission];
            self.btnTab4.backgroundColor = [UIColor colorWithRed:247/255.0f green:157/255.0f blue:160/255.0f alpha:1];
            break;

        default:
            break;
    }

}
-(void)askCammeraRollPermission{
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    
    [lib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
    } failureBlock:^(NSError *error) {
        if (error.code == ALAssetsLibraryAccessUserDeniedError) {
            NSLog(@"user denied access, code: %li",(long)error.code);
        }else{
            NSLog(@"Other error code: %li",(long)error.code);
        }
    }];
}
#pragma mark Actions
- (IBAction)homeScreenButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)updateBioData{
    NSData *pictureData = UIImagePNGRepresentation(selectedBiodata.image);
    PFFile *file = [PFFile fileWithName:selectedBiodata.name data:pictureData];
    [currentProfile setObject:file forKey:@"bioData"];
    [self.btnUploadBiodata setTitle:@"Uploading...." forState:UIControlStateNormal];
    self.btnUploadBiodata.enabled =NO;
    isUploadingBiodata  = YES;
    [currentProfile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        isUploadingBiodata  = NO;
        if (!error) {
            [self.btnUploadBiodata setTitle:@"Updated Biodata" forState:UIControlStateNormal];
            self.btnUploadBiodata.enabled =YES;
            btnDelete.hidden =NO;

            // succesful
            
        } else {
            [self.btnUploadBiodata setTitle:@"+Upload BioData" forState:UIControlStateNormal];

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
//    [[AppData sharedData] checkReachablitywithCompletionBlock:^(bool isReachable) {
//        if(isReachable){
//        }
//        else{
//          
//        }
//    }];
    if([[AppData sharedData]isInternetAvailable]){
        
        if([txtMinBudget.text integerValue]>0)
            currentProfile[@"minMarriageBudget"] = @([txtMinBudget.text integerValue]);
        if([txtMaxBudget.text integerValue]>0)
            currentProfile[@"maxMarriageBudget"] = @([txtMaxBudget.text integerValue]);
        NSString *name =[currentProfile valueForKey:@"name"];
        NSString *gender =[currentProfile valueForKey:@"gender"];
        NSString *height =[NSString stringWithFormat:@"%@",[currentProfile valueForKey:@"height"]];
        NSString *weight =[NSString stringWithFormat:@"%@",[currentProfile valueForKey:@"weight"]];
        NSString *designation =[currentProfile valueForKey:@"designation"];
        NSString *company =[currentProfile valueForKey:@"placeOfWork"];
        NSString *strPackage =[NSString stringWithFormat:@"%@",[currentProfile valueForKey:@"package"]];
        int package = [strPackage intValue];
        int minBugget =[txtMinBudget.text intValue];
        int maxBudget =[txtMaxBudget.text intValue];
        if(name.length==0 || [name rangeOfString:@" "].location == NSNotFound ||gender.length==0|| [[currentProfile valueForKey:@"currentLocation"] isKindOfClass: [NSNull class]] || [[currentProfile valueForKey:@"tob"] isKindOfClass: [NSNull class]] || [[currentProfile valueForKey:@"dob"] isKindOfClass: [NSNull class]] || [[currentProfile valueForKey:@"placeOfBirth"] isKindOfClass: [NSNull class]] || [[currentProfile valueForKey:@"religionId"] isKindOfClass: [NSNull class]]|| [[currentProfile valueForKey:@"casteId"] isKindOfClass: [NSNull class]]|| height.length==0 ||[weight integerValue]<=0|| [[currentProfile valueForKey:@"industryId"] isKindOfClass: [NSNull class]]|| [designation isKindOfClass:[NSNull class]]||designation == nil ||company.length==0||[[currentProfile valueForKey:@"workAfterMarriage"] isKindOfClass: [NSNull class]]||isPrimaryPhoto == NO || [[currentProfile valueForKey:@"education1"] isKindOfClass: [NSNull class]]||maxBudget<minBugget||package<1){
            NSMutableArray *arrMsg = [NSMutableArray array];
            if(name.length==0 ||  [name rangeOfString:@" "].location == NSNotFound)
                [arrMsg addObject:@"valid Full Name"];
             
            if([[currentProfile valueForKey:@"currentLocation"] isKindOfClass:[NSNull class]])
                [arrMsg addObject:@"Current Location"];
            
            if(gender.length==0)
                [arrMsg addObject:@"gender"];
            
            if([currentProfile valueForKey:@"tob"] ==nil)
                [arrMsg addObject:@"Time of Birth"];
            
            if([currentProfile valueForKey:@"dob"] ==nil )
                [arrMsg addObject:@"Date of Birth"];
            
            if(height.length==0)
                [arrMsg addObject:@"height"];
            
            if([weight integerValue]<=0)
                [arrMsg addObject:@"weight"];
            
            if(package<1)
                [arrMsg addObject:@"package"];
            
            if(company.length==0)
                [arrMsg addObject:@"company"];
            
            if( [designation isKindOfClass:[NSNull class]]|| designation==nil)
                [arrMsg addObject:@"designation"];
            
            if( [[currentProfile valueForKey:@"placeOfBirth"] isKindOfClass:[NSNull class]])
                [arrMsg addObject:@"Place of Birth"];
            
            if( [[currentProfile valueForKey:@"religionId"] isKindOfClass:[NSNull class]])
                [arrMsg addObject:@"Religion"];
            
            if([[currentProfile valueForKey:@"casteId"] isKindOfClass:[NSNull class]])
                [arrMsg addObject:@"Caste"];
            
            if([[currentProfile valueForKey:@"industryId"] isKindOfClass:[NSNull class]])
                [arrMsg addObject:@"Industry"];
            
            if([[currentProfile valueForKey:@"education1"]isKindOfClass:[NSNull class]])
                [arrMsg addObject:@"Degree and its specialization"];
            
            if(isPrimaryPhoto ==NO)
                [arrMsg addObject:@"select a Primary Photo"];
            
            if(selectedBiodata ==nil)
                [arrMsg addObject:@"select a Bio Data"];
            
            if(maxBudget<minBugget)
                [arrMsg addObject:@"max marriage budget less then min marriage budget"];
                
            NSString *msg =@"Please enter";
        
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
            [currentProfile setObject: @YES  forKey: @"isComplete"];
            [currentProfile setObject: @NO  forKey: @"paid"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserProfileUpdatedNotification" object:self];
            if(self.isMakingNewProfile){
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                SWRevealViewController *vc = [sb instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                [self presentViewController:vc animated:YES completion:nil];
            }
            else
                [self dismissViewControllerAnimated:YES completion:nil];
            [[NSUserDefaults standardUserDefaults]setObject:@"completed" forKey:@"isProfileComplete"];
            [currentProfile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
               

                if (!error) {
                    // succesful
//                    if(self.isMakingNewProfile){
//                        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                        SWRevealViewController *vc = [sb instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
//                        [self presentViewController:vc animated:YES completion:nil];
//                    }
//                    else
//                        [self dismissViewControllerAnimated:YES completion:nil];
                }
                else if (error.code ==100){
                    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Edit Profile Error" message:@"Connection Failed." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [errorAlertView show];
                }
                else if (error.code ==120){
                }
                
                else if (error.code ==209){
                    
                    [[AppData sharedData]logOut];
                    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Edit Profile Error" message:@"Loged from another device, Please login again!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [errorAlertView show];
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    StartMainViewController *vc = [sb instantiateViewControllerWithIdentifier:@"StartMainViewController"];
                    [self presentViewController:vc animated:YES completion:nil];
                }
                
                else {
                    //Something bad has ocurred
                    NSString *errorString = [[error userInfo] objectForKey:@"error"];
                    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Edit Profile Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
    }];
}
-(void)updateThePhotoFromPrimary{
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query whereKey:@"profileId" equalTo:currentProfile];
    [query whereKey:@"isPrimary" equalTo:[NSNumber numberWithBool:YES]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * userStats, NSError *error) {
        if (!error) {
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
            [self makePhotoToPrimary:primaryPhoto.imgObject];

            NSLog(@"Error: %@", error);
        }
    }];
}

#pragma  mark FourthTabCode
-(void)FbLogin
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile",@"user_photos"]
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             [self fetchUserInfo];
             NSLog(@"Logged in");
         }
     }];
}

-(void)fetchUserInfo
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        MBProgressHUD * hud;
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio ,location ,friends ,hometown , friendlists"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             if (!error)
             {
                 //NSLog(@"resultis:%@",result);
                 NSString *userId = [result valueForKey:@"id"];
                 [[NSUserDefaults standardUserDefaults]setObject:userId forKey:@"FacebookUserId"];
                 [self loginViaFacebook];
             }
        }];
    }
}

-(void)updateuserInfo{
    if(![[currentProfile valueForKey:@"isBudgetVisible"] boolValue]){
     
        txtMaxBudget.hidden = YES;
        txtMinBudget.hidden = YES;
        imgLine1.hidden = YES;
        imgLine2.hidden = YES;
        rsSymbol1.hidden = YES;
        rsSymbol2.hidden = YES;
        lblEstimatedBudgettxt.hidden = YES;
        self.uploadPhotoOrignConstraint.constant = self.uploadPhotoOrignConstraint.constant-30;
    }
    else {
        txtMaxBudget.hidden = NO;
        txtMinBudget.hidden = NO;
        imgLine1.hidden = NO;
        imgLine2.hidden = NO;
        rsSymbol1.hidden = NO;
        rsSymbol2.hidden = NO;
        lblEstimatedBudgettxt.hidden = NO;
        self.uploadPhotoOrignConstraint.constant = 126;

    }
    

    if([[currentProfile valueForKey:@"isComplete"] boolValue]){
        [[NSUserDefaults standardUserDefaults]setObject:@"completed" forKey:@"isProfileComplete"];
        btnDoneUp.hidden = NO;
    }
    else{
        [[NSUserDefaults standardUserDefaults]setObject:@"notCompleted" forKey:@"isProfileComplete"];
        btnDoneUp.hidden = YES;
    }

    if([currentProfile valueForKey:@"minMarriageBudget"] != nil ){
        txtMinBudget.text = [NSString stringWithFormat:@"%@",[currentProfile valueForKey:@"minMarriageBudget"] ] ;
    }
    if(![[currentProfile valueForKey:@"profilePic"] isKindOfClass: [NSNull class]]){
        [[currentProfile objectForKey:@"profilePic"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
           primaryCropedPhoto = [UIImage imageWithData:data];
        }];
    }
    
    if([currentProfile valueForKey:@"maxMarriageBudget"] != nil ){
        txtMaxBudget.text = [NSString stringWithFormat:@"%@",[currentProfile valueForKey:@"maxMarriageBudget"] ] ;
    }
    if(![[currentProfile valueForKey:@"bioData"] isKindOfClass: [NSNull class]]){
        btnDelete.hidden = NO;

        selectedBiodata = [[Photos alloc]init];
        PFFile *image = (PFFile *)[currentProfile valueForKey:@"bioData"];
                [[currentProfile objectForKey:@"bioData"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    selectedBiodata.image = [UIImage imageWithData:data];
                    selectedBiodata.name = image.name;
                    self.biodataImgView.image =selectedBiodata.image;
                }];
        [self.btnUploadBiodata setTitle:@"Updated Biodata" forState:UIControlStateNormal];
    }
    else{
        btnDelete.hidden = YES;
        [self.btnUploadBiodata setTitle:@"+Upload Biodata" forState:UIControlStateNormal];

    }
}

-(void)openFacebookProfileViewController{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    FacebooKProfilePictureViewController *vc = [sb instantiateViewControllerWithIdentifier:@"FacebooKProfilePictureViewController"];
    vc.delegate = self;
    vc.currentPhotosCount = arrImageList.count;
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)loginViaFacebook{
    
    if ([FBSDKAccessToken currentAccessToken])
    {
        [self openFacebookProfileViewController];
    }
    else{
        [self FbLogin];
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
    for(Photos *ph in arrImageList){
        [ ph.imgObject setObject:[NSNumber numberWithBool:NO] forKey:@"isPrimary"];
        
    }
    [primaryPhoto.imgObject setObject:[NSNumber numberWithBool:YES] forKey:@"isPrimary"];

    if(arrImageList.count==0)
        primaryPhoto = nil;
    [self.collectionView reloadData];
    NSData *pictureData = UIImagePNGRepresentation(primaryCropedPhoto);
    PFFile *file = [PFFile fileWithName:@"profilePic" data:pictureData];
    [currentProfile setObject:file forKey:@"profilePic"];
    [currentProfile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(primaryPhoto)
            isPrimaryPhoto = YES;
        else
            isPrimaryPhoto = NO;
}];
    [self updateThePhotoFromPrimary];

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
    if([photo.image isEqual:primaryPhoto.image]){
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
    if(isUploadingPhotos){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please Wait!!" message:@"Photos are uploading" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        selectedImage = arrImageList[indexPath.row];
        [self.collectionView reloadData];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
        ImageViewController *imageViewController = [sb instantiateViewControllerWithIdentifier:@"ImageViewController"];
        imageViewController.selectedImage = arrImageList[indexPath.row];
        imageViewController.arrImages = arrImageList;
        imageViewController.delegate = self;
        imageViewController.primaryCropPhoto = primaryCropedPhoto;
        imageViewController.primaryPhoto = primaryPhoto;
        imageViewController.currentIndex = indexPath.row;
        //vc.globalCompanyId = [self.companies.companyId intValue];
        
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:imageViewController];
        navController.navigationBarHidden =YES;
        [self presentViewController:navController animated:YES completion:nil];
    }
   }


#pragma mark - ZCImagePickerControllerDelegate

- (void)zcImagePickerController:(ZCImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(NSArray *)info {
    [self dismissPickerView];
    
    for (NSDictionary *imageDic in info) {
        Photos *photo = [[Photos alloc]init];
        photo.image =[self compressImage:[imageDic objectForKey:UIImagePickerControllerOriginalImage]];
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

-(UIImage *)compressImage:(UIImage *)image{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 600.0;
    float maxWidth = 800.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(image, compressionQuality);
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithData:imageData];
}
-(void)addPhotosToParse{
    NSMutableArray *arrAllPhotoToBeSaved = [NSMutableArray array];
    for(Photos *photo in arrNewImages){
        NSData *pictureData = UIImagePNGRepresentation(photo.image);
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
    [self.choosePhotoBtn setTitle:@"Uploading...." forState:UIControlStateNormal];
    isUploadingPhotos = YES;

    [PFObject saveAllInBackground:arrAllPhotoToBeSaved block:^(BOOL succeeded, NSError *error) {
        isUploadingPhotos = NO;
        [self.choosePhotoBtn setTitle:@"+Upload Photos" forState:UIControlStateNormal];
        if (succeeded) {
            [self.choosePhotoBtn setTitle:@"+Upload Photos" forState:UIControlStateNormal];
            arrNewImages = [NSMutableArray array];

            [self getAllPhotos];
        }
        else if (error.code ==100){
            [self.choosePhotoBtn setTitle:@"+Upload Photos" forState:UIControlStateNormal];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection Failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
        else if (error.code ==209){
            [self.choosePhotoBtn setTitle:@"+Upload Photos" forState:UIControlStateNormal];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection Failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [PFQuery clearAllCachedResults];
            StartMainViewController *vc = [sb instantiateViewControllerWithIdentifier:@"StartMainViewController"];
            [self presentViewController:vc animated:YES completion:nil];
        }

        else {
            [self.choosePhotoBtn setTitle:@"+Upload Photos" forState:UIControlStateNormal];
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
        selectedBiodata.image =[self compressImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
     
    }
    else{
        Photos *photo = [[Photos alloc]init];
        photo.image =[self compressImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
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
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)selectedProfilePhotoArray:(NSArray *)arrSelectedProfilePics{
    [arrNewImages addObjectsFromArray:arrSelectedProfilePics];
    arrImageList = [NSMutableArray arrayWithArray:[arrOldImages arrayByAddingObjectsFromArray:arrNewImages]];
    [self.collectionView reloadData];
    [self addPhotosToParse];
}
#pragma mark ShowActiviatyIndicator

-(void)showLoader{
    [activityIndicator startAnimating];
    self.btnTab1.enabled = NO;
    self.btnTab2.enabled = NO;
    self.btnTab3.enabled = NO;
    self.btnTab4.enabled = NO;
}
-(void)hideLoader{
    [activityIndicator stopAnimating];
    self.btnTab1.enabled = YES;
    self.btnTab2.enabled = YES;
    self.btnTab3.enabled = YES;
    self.btnTab4.enabled = YES;
}

- (IBAction)deleteButtonAction:(id)sender {
    [currentProfile setObject:[NSNull null] forKey:@"bioData"];
    [self.btnUploadBiodata setTitle:@"+Upload biodata" forState:UIControlStateNormal];
    self.btnUploadBiodata.enabled = YES;
    btnDelete.hidden = YES;
    self.biodataImgView.image = nil;
    [currentProfile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
           }];

}

- (IBAction)choosePrimaryPhotoButtonAction:(id)sender {
    if(isUploadingPhotos){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please Wait!!" message:@"Photos are uploading" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        if(arrImageList.count>0){
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
            PrimaryImagePickerViewController *vc = [sb instantiateViewControllerWithIdentifier:@"PrimaryImagePickerViewController"];
            vc.delegate = self;
            vc.arrImageList = arrImageList;
            [self presentViewController:vc animated:YES completion:nil];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Upload photos first to make primary." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }

    }

}

#pragma mark PrimaryImagePickerViewControllerDelegate
-(void)selectedPrimaryPhoto:(Photos *)primaryImg andCropedPhoto:(UIImage *)cropedPhoto{
    primaryPhoto = primaryImg;
    primaryCropedPhoto = cropedPhoto;
    for(Photos *ph in arrImageList){
        [ ph.imgObject setObject:[NSNumber numberWithBool:NO] forKey:@"isPrimary"];
    }
    [primaryPhoto.imgObject setObject:[NSNumber numberWithBool:YES] forKey:@"isPrimary"];
    if(arrImageList.count==0)
        primaryPhoto = nil;
    [self.collectionView reloadData];
    NSData *pictureData = UIImagePNGRepresentation(primaryCropedPhoto);
    PFFile *file = [PFFile fileWithName:@"profilePic" data:pictureData];
    [currentProfile setObject:file forKey:@"profilePic"];
    [currentProfile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(primaryPhoto)
            isPrimaryPhoto = YES;
        else
            isPrimaryPhoto = NO;
    }];
    [self updateThePhotoFromPrimary];
}
@end
