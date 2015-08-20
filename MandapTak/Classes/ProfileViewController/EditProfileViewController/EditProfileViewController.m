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
#import "UploadPhotosProfileViewController.h"
@interface EditProfileViewController ()<WYPopoverControllerDelegate,HeightPopoverViewControllerDelegate,BasicProfileViewControllerDelegate,DetailProfileViewControllerrDelegate,ProfileWorkAndExperienceViewControllerDelegate,UploadPhotosProfileViewControllerDelegate>
{
    __weak IBOutlet UIButton *btnHeight;
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
    UIStoryboard *sb2;
    BasicProfileViewController *vc1;
    DetailProfileViewController *vc2;
    ProfileWorkAndExperienceViewController *vc3;
    UploadPhotosProfileViewController *vc4;
    BOOL isSelectingCurrentLocation;
}
@property (weak, nonatomic) IBOutlet UIButton *btnTab1;
@property (weak, nonatomic) IBOutlet UIButton *btnTab2;
@property (weak, nonatomic) IBOutlet UIButton *btnTab3;
@property (weak, nonatomic) IBOutlet UIButton *btnTab4;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
- (IBAction)nextBtnAction:(id)sender;
- (IBAction)tabButtonAction:(id)sender;
- (IBAction)homeScreenButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *tab1View;
@property (weak, nonatomic) IBOutlet UIView *tab2View;
@property (weak, nonatomic) IBOutlet UIView *tab3View;
@property (weak, nonatomic) IBOutlet UIView *tab4View;
@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sb2 = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    vc1 = [sb2 instantiateViewControllerWithIdentifier:@"BasicProfileViewController"];
    vc2 = [sb2 instantiateViewControllerWithIdentifier:@"DetailProfileViewController"];
    vc3 = [sb2 instantiateViewControllerWithIdentifier:@"ProfileWorkAndExperienceViewController"];
    vc4 = [sb2 instantiateViewControllerWithIdentifier:@"UploadPhotosProfileViewController"];

    // [self hideAllView];
    UIColor* whyerColor = [UIColor colorWithRed:240/255.0f green:113/255.0f blue:116/255.0f alpha:1];
//fetch profile for User id
    NSString *userId = @"m2vi20vsi4";
    PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
    
    [query whereKey:@"userId" equalTo:userId];
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

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            PFObject *obj= objects[0];
            currentProfile = obj;

        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.view endEditing:YES];
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
    if (currentTab>=1 &&currentTab<4 )
        currentTab++;
    else
        currentTab =1;

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
-(void)selectedHeight:(NSString *)height{
    selectedHeight = height;
    [btnHeight setTitle:height forState:UIControlStateNormal];
    [btnHeight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [popoverController dismissPopoverAnimated:YES];
}
-(void)selectedHeightWithFeet:(NSString *)feet andInches:(NSString *)inches{
//    selectedInches= inches;
//    selectedFeets = feet;
    [btnHeight setTitle:[NSString stringWithFormat:@"%@\'%@\"",feet,inches] forState:UIControlStateNormal];
    [btnHeight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [popoverController dismissPopoverAnimated:YES];

}
-(void)removeSubview{
    if([self.tab3View.subviews containsObject:vc3.view]) {
        [vc3 removeFromParentViewController];
        [vc3.view removeFromSuperview];
    }
    if([self.tab2View.subviews containsObject:vc2.view]) {
        [vc2 removeFromParentViewController];
        [vc2.view removeFromSuperview];
        
    }
    if([self.tab1View.subviews containsObject:vc1.view]) {
        [vc1 removeFromParentViewController];
        [vc1.view removeFromSuperview];
        
    }
    if([self.tab4View.subviews containsObject:vc4.view]) {
        [vc4 removeFromParentViewController];
        [vc4.view removeFromSuperview];
        
    }
}

#pragma mark SwitchTCurrentTab
-(void)switchToCurrentTab{
   [self hideAllView];

    switch (currentTab) {
        case 1:
            self.tab1View.hidden = NO;
            vc1.delegate = self;
            vc1.currentProfile = currentProfile;
            [self addChildViewController:vc1];
            [self.tab1View addSubview:vc1.view];
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
            vc4.delegate = self;
            vc4.currentProfile = currentProfile;
            [self.tab4View addSubview:vc4.view];
            [self addChildViewController:vc4];
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


@end
