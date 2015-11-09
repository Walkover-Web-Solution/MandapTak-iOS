//
//  DemoScreenVC.m
//  MandapTak
//
//  Created by Anuj Jain on 11/4/15.
//  Copyright © 2015 Walkover. All rights reserved.
//

#import "DemoScreenVC.h"
#import "WSCoachMarksView.h"
#import "Profile.h"
#import "MBCircularProgressBarView.h"
#import <Parse/Parse.h>
#import "StartMainViewController.h"
#import "UIImageEffects.h"

@interface DemoScreenVC ()<WSCoachMarksViewDelegate>
{
    IBOutlet UIImageView *imgViewProfilePic;
    IBOutlet UIImageView *imgViewBackground;
    IBOutlet UIView *profileView;
    IBOutlet UILabel *lblMessage;
    IBOutlet UIButton *btnUndo;
    IBOutlet UIButton *btnRefresh;
    IBOutlet UIButton *btnLike;
    IBOutlet UIButton *btnDislike;
    IBOutlet UIButton *btnPin;
    IBOutlet UIButton *btnDetail;
    IBOutlet NSLayoutConstraint *imageViewConstraint;
    IBOutlet UIView *loaderView;
    
    IBOutlet UIView *blankView;
    IBOutlet UIImageView *animationImageView;
    IBOutlet UIImageView *userImageView;
    IBOutlet UILabel *lblTraitMatch;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UILabel *lblTraits;
    IBOutlet UILabel *lblHeight;
    IBOutlet UILabel *lblProfession;
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblReligion;
    NSUInteger currentIndex;
    IBOutlet MBCircularProgressBarView *progressBar;
    NSArray *coachMarks;
    NSArray *arrHeight;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgProfileView;
- (IBAction)back:(id)sender;
@end

@implementation DemoScreenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //        WSCoachMarksView *coachMarksView = [[WSCoachMarksView alloc] initWithFrame:self.navigationController.view.bounds coachMarks:coachMarks];
    //        [self.navigationController.view addSubview:coachMarksView];
    //        [coachMarksView start];
    
    arrHeight = [NSArray arrayWithObjects:@"4ft 5in - 134cm",@"4ft 6in - 137cm",@"4ft 7in - 139cm",@"4ft 8in - 142cm",@"4ft 9in - 144cm",@"4ft 10in - 147cm",@"4ft 11in - 149cm",@"5ft - 152cm",@"5ft 1in - 154cm",@"5ft 2in - 157cm",@"5ft 3in - 160cm",@"5ft 4in - 162cm",@"5ft 5in - 165cm",@"5ft 6in - 167cm",@"5ft 7in - 170cm",@"5ft 8in - 172cm",@"5ft 9in - 175cm",@"5ft 10in - 177cm",@"5ft 11in - 180cm",@"6ft - 182cm",@"6ft 1in - 185cm",@"6ft 2in - 187cm",@"6ft 3in - 190cm",@"6ft 4in - 193cm",@"6ft 5in - 195cm",@"6ft 6in - 198cm",@"6ft 7in - 200cm",@"6ft 8in - 203cm",@"6ft 9in - 205cm",@"6ft 10in - 208cm",@"6ft 11in - 210cm",@"7ft - 213cm", nil];
    
    
    imgViewProfilePic.layer.cornerRadius = imgViewProfilePic.frame.size.width/2; //80.0f;
    imgViewProfilePic.layer.borderWidth = 2.0f;
    imgViewProfilePic.layer.borderColor = [[UIColor whiteColor] CGColor];
    imgViewProfilePic.clipsToBounds = YES;
    
    //set circular border of progress bar
    progressBar.layer.cornerRadius = 34.0f;
    
    /*
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"DemoProfileObject"];
    Profile *profileObj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    imgViewProfilePic.image = profileObj.profilePic;
     */
    
    //check if data is nil
    NSString *strName = [[NSUserDefaults standardUserDefaults] valueForKey:@"demoProfileName"];
    if (strName.length == 0)
    {
        //fetch demo profile data from pffunction
        [self getDemoProfile];
    }
    else
    {
        //show saved profile
        lblName.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"demoProfileName"];
        lblHeight.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"demoProfileHeight"];
        lblProfession.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"demoProfileDesignation"];
        lblReligion.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"demoProfileReligion"];
        
        NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"demoProfileImage"];
        imgViewProfilePic.image = [UIImage imageWithData:imageData];
        
        NSData* imageBG = [[NSUserDefaults standardUserDefaults] objectForKey:@"demoProfileBG"];
        imgViewBackground.image = [UIImage imageWithData:imageBG];
        
        NSString *strTraits = [[NSUserDefaults standardUserDefaults] valueForKey:@"demoTraits"];
        [progressBar setValue:[strTraits floatValue] animateWithDuration:0.5];
        lblTraitMatch.text = [NSString stringWithFormat:@"%@ Traits Match",strTraits];
    }
        
    
}

-(void)viewDidAppear:(BOOL)animated
{
    //apply coach marks conditions
    //Setup coach marks
    coachMarks = @[
                   @{
                       @"rect": [NSValue valueWithCGRect:btnPin.frame],
                       @"caption": @"Pin Profile to view it later",
                       @"shape": @"square"
                       },
                   @{
                       @"rect": [NSValue valueWithCGRect:btnLike.frame],
                       @"caption": @"Like a profile??click the heart icon..!!",
                       @"shape" : @"circle"
                       },
                   @{
                       @"rect": [NSValue valueWithCGRect:btnDislike.frame],
                       @"caption": @"Don't like a profile??dislike it...!!",
                       @"shape" : @"circle"
                       },
                   @{
                       @"rect": [NSValue valueWithCGRect:btnUndo.frame],
                       @"caption": @"Want to change your decision??click Undo..!!",
                       @"shape" : @"circle"
                       },
                   @{
                       @"rect": [NSValue valueWithCGRect:progressBar.frame],//[NSValue valueWithCGRect:(CGRect){{11,51},{68,68}}],
                       @"caption": @"get traits count here",
                       @"shape": @"circle"
                       },
                   @{
                       @"rect": [NSValue valueWithCGRect:imgViewProfilePic.frame],
                       @"caption": @"Want to know more??Click on the image..!!",
                       @"shape": @"circle"
                       }
                   ];
    WSCoachMarksView *coachMarksView = [[WSCoachMarksView alloc] initWithFrame:self.view.bounds coachMarks:coachMarks];
    [self.view addSubview:coachMarksView];
    coachMarksView.delegate = self;
    [coachMarksView start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(id)sender
{
    profileView.hidden = NO;
    blankView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)coachMarksViewDidCleanup:(WSCoachMarksView *)coachMarksView
{
    [self back:nil];
    //profileView.hidden = YES;
    //blankView.hidden = NO;
}

#pragma mark call Parse Function
-(void) getDemoProfile
{
    [PFCloud callFunctionInBackground:@"filterProfileLive"
                       withParameters:@{@"oid":[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"]}
                                block:^(NSArray *results, NSError *error)
     {
         //[MBProgressHUD hideHUDForView:self.view animated:YES];
         //[self hideLoader];
         if (!error)
         {
             // this is where you handle the results and change the UI.
             if (results.count > 0)
             {
                 //show profile view
                 //[self animateArrayOfImagesForImageCount:30];
                 
                 NSLog(@"profile count = %lu", (unsigned long)results.count);
                
                 PFObject *profileObj = results[0];
                     Profile *profileModel = [[Profile alloc]init];
                     
                     profileModel.profilePointer = profileObj;
                     
                     profileModel.name = profileObj[@"name"];
                     profileModel.age = [NSString stringWithFormat:@"%@",profileObj[@"age"]];
                     profileModel.weight = [NSString stringWithFormat:@"%@",profileObj[@"weight"]];
                     if(profileModel.weight.length == 0){
                         profileModel.weight = [profileModel.weight stringByReplacingOccurrencesOfString:@", <null>" withString:@""];
                     }
                     
                     profileModel.gender = profileObj[@"gender"];
                     //caste label
                     PFObject *caste = [profileObj valueForKey:@"casteId"];
                     PFObject *religion = [profileObj valueForKey:@"religionId"];
                     //NSLog(@"religion = %@ and caste = %@",[religion valueForKey:@"name"],[caste valueForKey:@"name"]);
                     profileModel.religion = [religion valueForKey:@"name"];
                     profileModel.caste = [caste valueForKey:@"name"];
                     profileModel.designation = profileObj[@"designation"];
                     
                     //Height
                     profileModel.height = [self getFormattedHeightFromValue:[NSString stringWithFormat:@"%@cm",[profileObj valueForKey:@"height"]]];
                     if(profileModel.height.length == 0)
                     {
                         profileModel.height = [profileModel.height stringByReplacingOccurrencesOfString:@", <null>" withString:@""];
                     }
                     
                     //ADD data in model for complete profile view screen
                     PFObject *currentLoc = [profileObj valueForKey:@"currentLocation"];
                     PFObject *currentState = [currentLoc valueForKey:@"Parent"];
                     profileModel.currentLocation = [NSString stringWithFormat:@"%@,%@",[currentLoc valueForKey:@"name"],[currentState valueForKey:@"name"]];
                     profileModel.income = [profileObj valueForKey:@"package"];
                     
                     //birth location label
                     PFObject *birthLoc = [profileObj valueForKey:@"placeOfBirth"];
                     PFObject *birthState = [birthLoc valueForKey:@"Parent"];
                     
                     profileModel.placeOfBirth = [NSString stringWithFormat:@"%@,%@",[birthLoc valueForKey:@"name"],[birthState valueForKey:@"name"]];
                     profileModel.minBudget = [NSString stringWithFormat:@"%@",[profileObj valueForKey:@"minMarriageBudget"]];
                     profileModel.maxBudget = [NSString stringWithFormat:@"%@",[profileObj valueForKey:@"maxMarriageBudget"]];
                     profileModel.company = [NSString stringWithFormat:@"%@",[profileObj valueForKey:@"placeOfWork"]];
                     
                     //DOB
                     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                     [formatter setDateFormat:@"yyyy-MM-dd"];
                     NSString *strDate = [formatter stringFromDate:[profileObj valueForKey:@"dob"]];
                     profileModel.dob = strDate;
                     
                     //TOB
                     NSDate *dateTOB = [profileObj valueForKey:@"tob"];
                     NSDateFormatter *formatterTime = [[NSDateFormatter alloc] init];
                     [formatterTime setDateFormat:@"hh:mm:ss"];
                     [formatterTime setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
                     NSString *strTOB = [formatterTime stringFromDate:dateTOB];
                     profileModel.tob = strTOB;
                     
                     
                     //load images in background
                     PFFile *userImageFile = profileObj[@"profilePic"];
                     [userImageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
                      {
                          if (!error)
                          {
                              //got profile pic data for circular image view
                              
                              profileModel.profilePic = [UIImage imageWithData:data];
                              /*
                              [arrCandidateProfiles addObject:profileModel];
                              profileNumber = 0 ;
                              if (arrCandidateProfiles.count == results.count)
                              {
                                  //NSLog(@"profile number = %d ",profileNumber);
                                  [self showProfileOfCandidateNumber:profileNumber withTransition:nil];
                              }
                               */
                              imgViewProfilePic.image = profileModel.profilePic;
                              
                              //show blurred image
                              profileView.hidden = NO;
                              blankView.hidden = YES;
                              UIImage *effectImage = [UIImageEffects imageByApplyingLightEffectToImage:profileModel.profilePic];
                              imgViewBackground.image = effectImage;
                          }
                      }];
                 
                 lblName.text = profileModel.name;
                 lblHeight.text = [NSString stringWithFormat:@"%@,%@",profileModel.age,profileModel.height];
                 lblProfession.text = profileModel.designation;
                 lblReligion.text = [NSString stringWithFormat:@"%@,%@",profileModel.religion,profileModel.caste];
                 [progressBar setValue:22.5 animateWithDuration:0.5];
                 lblTraitMatch.text = [NSString stringWithFormat:@"22.5 Traits Match"];
                 //[self getUserProfilePicForUser:objID];
                 //show user profile pic
                 
                 
             }
             else
             {
                 //open blank View
                 //[self.view bringSubviewToFront:blankView];
                 blankView.hidden = NO;
                 profileView.hidden = YES;
                 btnUndo.enabled = NO;
                 lblMessage.text = [NSString stringWithFormat:@"No matching profiles found...!!"];
                 animationImageView.hidden = YES;
             }
         }
         else if (error.code ==209)
         {
             UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Logged in from another device, Please login again!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [errorAlertView show];
             UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
             [PFQuery clearAllCachedResults];
             StartMainViewController *vc = [sb instantiateViewControllerWithIdentifier:@"StartMainViewController"];
             [self presentViewController:vc animated:YES completion:nil];
         }
         else
         {
             blankView.hidden = NO;
             profileView.hidden = YES;
             btnUndo.enabled = NO;
             lblMessage.text = @"Please try again..";
             animationImageView.hidden = YES;
         }
     }];
}

- (NSString *)getFormattedHeightFromValue:(NSString *)value
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", value];
    NSString *strFiltered = [[arrHeight filteredArrayUsingPredicate:predicate] firstObject];
    return strFiltered;
}

@end
