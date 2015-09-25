//
//  UserProfileViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 27/07/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "UserProfileViewController.h"
#import "SWRevealViewController.h"
#import <Atlas/Atlas.h>

@interface UserProfileViewController (){
    
    __weak IBOutlet UILabel *lblTraits;
    __weak IBOutlet UILabel *lblHeight;
    __weak IBOutlet UILabel *lblProfession;
    __weak IBOutlet UILabel *lblName;
    __weak IBOutlet UILabel *lblReligion;
    NSUInteger currentIndex;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgProfileView;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnMatches;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
- (IBAction)menuButtonAction:(id)sender;
- (IBAction)shareButtonAction:(id)sender;
- (IBAction)matchesButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

@implementation UserProfileViewController
static NSString *const LayerAppIDString = @"layer:///apps/staging/3ffe495e-45e8-11e5-9685-919001005125";

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(![[[NSUserDefaults standardUserDefaults]valueForKey:@"isNotification"] isEqual:@"yes"]){
        if( !self.layerClient.authenticatedUserID){
            if([PFUser currentUser]){
                NSURL *appID = [NSURL URLWithString:LayerAppIDString];
                if(self.layerClient.appID == nil){
                    self.layerClient = [LYRClient clientWithAppID:appID];
                    self.layerClient.autodownloadMIMETypes = [NSSet setWithObjects:ATLMIMETypeImagePNG, ATLMIMETypeImageJPEG, ATLMIMETypeImageJPEGPreview, ATLMIMETypeImageGIF, ATLMIMETypeImageGIFPreview, ATLMIMETypeLocation, nil];
                }
                [self loginLayer];
            }
        }
    }
        //set circular border of progress bar
    progressBar.layer.cornerRadius = 34.0f;
    
    //call method to get current user profile pic
    [self getUserProfilePic];
    
    //set initial load conditions
    currentIndex = 0;
    arrCandidateProfiles = [[NSMutableArray alloc] init];
    arrCache = [[NSMutableArray alloc] init];
    arrHistory = [[NSMutableArray alloc] init];
    
    //update constraints
    imageViewConstraint.constant = [UIScreen mainScreen].bounds.size.height > 480.0f ? 137 : 70;
    
    profileNumber = 0;
    btnUndo.enabled = NO;
    //store height data in array
    arrHeight = [NSArray arrayWithObjects:@"4ft 5in - 134cm",@"4ft 6in - 137cm",@"4ft 7in - 139cm",@"4ft 8in - 142cm",@"4ft 9in - 144cm",@"4ft 10in - 147cm",@"4ft 11in - 149cm",@"5ft - 152cm",@"5ft 1in - 154cm",@"5ft 2in - 157cm",@"5ft 3in - 160cm",@"5ft 4in - 162cm",@"5ft 5in - 165cm",@"5ft 6in - 167cm",@"5ft 7in - 170cm",@"5ft 8in - 172cm",@"5ft 9in - 175cm",@"5ft 10in - 177cm",@"5ft 11in - 180cm",@"6ft - 182cm",@"6ft 1in - 185cm",@"6ft 2in - 187cm",@"6ft 3in - 190cm",@"6ft 4in - 193cm",@"6ft 5in - 195cm",@"6ft 6in - 198cm",@"6ft 7in - 200cm",@"6ft 8in - 203cm",@"6ft 9in - 205cm",@"6ft 10in - 208cm",@"6ft 11in - 210cm",@"7ft - 213cm", nil];
    
    //hide trait label initially
    lblTraits.hidden = YES;
    
    imgViewProfilePic.layer.cornerRadius = 80.0f;
    imgViewProfilePic.layer.borderWidth = 2.0f;
    imgViewProfilePic.layer.borderColor = [[UIColor whiteColor] CGColor];
    imgViewProfilePic.clipsToBounds = YES;
    
    //apply circular border on user image view
    userImageView.layer.cornerRadius = 60.0f;
    userImageView.clipsToBounds = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3f];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    // Setting the swipe direction.

    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    //[self.view addGestureRecognizer:swipeRight];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    //_sidebarButton.tintColor = [UIColor colorWithRed:235/255 green:84/255 blue:80/255 alpha:1];
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
    [self.view addGestureRecognizer:swipeUp];

    [self.revealViewController.panGestureRecognizer requireGestureRecognizerToFail:swipeLeft];
    [self.revealViewController.panGestureRecognizer requireGestureRecognizerToFail:swipeRight];
    [self.revealViewController.panGestureRecognizer requireGestureRecognizerToFail:swipeUp];
    
    /*
    XHAmazingLoadingView *amazingLoadingView = [[XHAmazingLoadingView alloc] initWithType:XHAmazingLoadingAnimationTypeSkype];
    amazingLoadingView.loadingTintColor = [UIColor redColor];
    amazingLoadingView.backgroundTintColor = [UIColor whiteColor];
    amazingLoadingView.frame = self.view.bounds;
    [blankView addSubview:amazingLoadingView];
    
    [amazingLoadingView startAnimating];
    */
    blankView.hidden = NO;
    profileView.hidden = YES;
    
    //add animation
    [self animateArrayOfImagesForImageCount:30];
    
    //
    /*
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(200, 200, 100, 100)];
    view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:view];
    //[self showAnimation:view];
    [self performSelector:@selector(showAnimation:) withObject:view afterDelay:2.0];
     */
    
//    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//            //The registration was succesful, go to the wall
//            [self performSegueWithIdentifier:@"SignupSuccesful" sender:self];
//            
//        } else {
//            //Something bad has ocurred
//            NSString *errorString = [[error userInfo] objectForKey:@"error"];
//            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [errorAlertView show];
//        }
//    }];

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    //check notification
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isNotification"] isEqualToString:@"yes"])
    {
        //[[[UIAlertView alloc] initWithTitle:@"Test 2" message:@"isnotification = TRUE" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        //show popover view
        [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"reloadCandidateList"];
        [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"isNotification"];
        MatchScreenVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MatchScreenVC"];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
    
    //check first load
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isFirstLoad"] isEqualToString:@"yes"])
    {
        //[[[UIAlertView alloc] initWithTitle:@"Test 2" message:@"first load" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"isFirstLoad"];
        [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"isNotification"];
    }

 /*
    else
    {
        //check notification
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isNotification"] isEqualToString:@"yes"])
        {
            //[[[UIAlertView alloc] initWithTitle:@"Test 2" message:@"isnotification = TRUE" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            //show popover view
            [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"reloadCandidateList"];
            [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"isNotification"];
            MatchScreenVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MatchScreenVC"];
            [self.navigationController presentViewController:vc animated:YES completion:nil];
        }
        else
        {
            //[[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"isNotification"];
            //[[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"reloadCandidateList"];
            //[[[UIAlertView alloc] initWithTitle:@"Test 2" message:@"isnotification = FALSE" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
    }
   */ 
    lblMessage.text = @"Finding matches...";
    [self animateArrayOfImagesForImageCount:30];
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init];
    //reload only if reload condition is true or no objects found in candidate profile list
    if ((![[userDefaults valueForKey:@"reloadCandidateList"] isEqualToString:@"no"]) || (arrCandidateProfiles.count == 0) )
    {
        imgViewProfilePic.image = nil;
        self.imgProfileView.image = nil;
        [arrCandidateProfiles removeAllObjects];
        
        //show loading screen
        blankView.hidden = NO;
        profileView.hidden = YES;
        [self animateArrayOfImagesForImageCount:30];
      
        [PFCloud callFunctionInBackground:@"filterProfileLive"
                           withParameters:@{@"oid":[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"]}  //@"nASUvS6R7Z"
                                    block:^(NSArray *results, NSError *error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             
             if (!error)
             {
                 // this is where you handle the results and change the UI.
                 if (results.count > 0)
                 {
                     //show profile view
                     [self animateArrayOfImagesForImageCount:30];
                     
                     NSLog(@"profile count = %lu", (unsigned long)results.count);
                     for (PFObject *profileObj in results)
                     {
                         Profile *profileModel = [[Profile alloc]init];
                         
                         profileModel.profilePointer = profileObj;
                         
                         profileModel.name = profileObj[@"name"];
                         profileModel.age = [NSString stringWithFormat:@"%@",profileObj[@"age"]];
                         //profileModel.height = [NSString stringWithFormat:@"%@",profileObj[@"height"]];
                         profileModel.weight = [NSString stringWithFormat:@"%@",profileObj[@"weight"]];
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
                                  [arrCandidateProfiles addObject:profileModel];
                                  
                                  if (arrCandidateProfiles.count == results.count)
                                  {
                                      [self showProfileOfCandidateNumber:profileNumber withTransition:nil];
                                  }
                              }
                          }];
                     }
                 }
                 else
                 {
                     //open blank View
                     //[self.view bringSubviewToFront:blankView];
                     blankView.hidden = NO;
                     profileView.hidden = YES;
                     btnUndo.enabled = NO;
                     [arrHistory removeAllObjects];
                     [arrCache removeAllObjects];
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
                 [arrHistory removeAllObjects];
                 [arrCache removeAllObjects];
                 lblMessage.text = @"Please try again..";
                 animationImageView.hidden = YES;
             }
         }];
    }
    else
    {
        [userDefaults setValue:@"yes" forKey:@"reloadCandidateList"];
    }
}


#pragma mark User Profile Pic
-(void) getUserProfilePic
{
    //get user profile pic
    PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
    [query whereKey:@"objectId" equalTo:[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"]];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    //MBProgressHUD * hud;
    //hud=[MBProgressHUD showHUDAddedTo:self.imgView animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         //[MBProgressHUD hideHUDForView:self.imgView animated:YES];
         if (!error)
         {
             // The find succeeded.
             PFObject *obj = objects[0];
             [[NSUserDefaults standardUserDefaults] setValue:obj[@"name"] forKey:@"currentProfileName"];
             PFFile *userImageFile = obj[@"profilePic"];
             if (userImageFile)
             {
                 [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
                  {
                      //[MBProgressHUD hideAllHUDsForView:self.imgView animated:YES];
                      if (!error)
                      {
                          
                          UIImage *image = [UIImage imageWithData:imageData];
                          //[arrImages addObject:image];
                          userImageView.image = image;
                          userImageView.layer.borderWidth = 2.0f;
                          userImageView.layer.borderColor = [[UIColor colorWithRed:244.0/255.0 green:111.0/255.0 blue:111.0/255.0 alpha:1] CGColor];
                      }
                      else
                      {
                          NSLog(@"Error = > %@",error);
                      }
                      //add our blurred image to the scrollview
                      //profileImageView.image = arrImages[0];
                  }];
             }
             else
             {
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 userImageView.layer.backgroundColor = [[UIColor lightGrayColor] CGColor];
                 userImageView.image = [UIImage imageNamed:@"userProfile"];
             }
             //currentProfile =obj;
             //[self switchToMatches];
             
         }
         
         else if (error.code ==100){
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             
             UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection Failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [errorAlertView show];
         }
         else if (error.code ==120)
         {
             //handle cache miss condition
             //[MBProgressHUD showHUDAddedTo:self.imgView animated:YES];
         }
         else if (error.code ==209){
             [PFUser logOut];
             [self.layerClient deauthenticateWithCompletion:^(BOOL success, NSError *error) {
                 if (!success) {
                     NSLog(@"Failed to deauthenticate: %@", error);
                 } else {
                     NSLog(@"Previous user deauthenticated");
                 }
             }];
             
             PFUser *user = nil;
             PFInstallation *currentInstallation = [PFInstallation currentInstallation];
             [currentInstallation setObject:user forKey:@"user"];
             [currentInstallation saveInBackground];
             
             UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Logged in from another device, Please login again!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [errorAlertView show];
             UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
             StartMainViewController *vc = [sb instantiateViewControllerWithIdentifier:@"StartMainViewController"];
             [self presentViewController:vc animated:YES completion:nil];
         }
     }];
}

#pragma mark Animation Methods
/*
-(void) animateArrayOfImagesForImageCount:(int) aCount
{
    animationImageView.hidden = NO;
    NSMutableArray *imgListArray = [NSMutableArray array];
    for (int i=1; i <= aCount; i++) {
        NSString *strImgeName = [NSString stringWithFormat:@"Anim (%d).png", i];
        UIImage *image = [UIImage imageNamed:strImgeName];
        if (!image) {
            // NSLog(@"Could not load image named: %@", strImgeName);
        }
        else {
            [imgListArray addObject:image];
        }
    }
    animationImageView.animationImages=imgListArray;
    animationImageView.animationDuration=1;
    animationImageView.animationRepeatCount=3;
    [animationImageView startAnimating];
}
*/

-(void) animateArrayOfImagesForImageCount:(int) aCount
{
    animationImageView.hidden = NO;
        NSMutableArray *imgListArray = [NSMutableArray array];
        for (int i=1; i <= aCount; i++) {
            NSString *strImgeName = [NSString stringWithFormat:@"Anim-(%d).png", i];
            UIImage *image = [UIImage imageNamed:strImgeName];
            if (!image) {
                // NSLog(@"Could not load image named: %@", strImgeName);
            }
            else {
                [imgListArray addObject:image];
            }
        }
        animationImageView.animationImages=imgListArray;
        animationImageView.animationDuration=1.5;
        animationImageView.animationRepeatCount=-1;
        [animationImageView startAnimating];
}
    


-(void) showAnimation:(UIView *)view
{
    /*
    CATransition *animation=[CATransition animation];
    [animation setDelegate:self];
    [animation setDuration:1.75];
    [animation setTimingFunction:UIViewAnimationCurveEaseInOut];
    [animation setType:@"rippleEffect"];
    
    [animation setFillMode:kCAFillModeRemoved];
    animation.endProgress=1;
    [animation setRemovedOnCompletion:NO];
    [view.layer addAnimation:animation forKey:nil];
    */
    /*
    CATransition *animation2 = [CATransition animation];
    [animation2 setDelegate:self];
    [animation2 setDuration:2.0f];
    [animation2 setTimingFunction:UIViewAnimationCurveEaseInOut];
    [animation2 setType:@"rippleEffect" ];
    [view.layer addAnimation:animation2 forKey:NULL];
     */
}

- (NSString *)getFormattedHeightFromValue:(NSString *)value
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", value];
    NSString *strFiltered = [[arrHeight filteredArrayUsingPredicate:predicate] firstObject];
    return strFiltered;
}

-(void) showProfileOfCandidateNumber:(int)number withTransition:(CATransition *)trans
{
    if (arrCandidateProfiles.count >0)
    {
        blankView.hidden = YES;
        profileView.hidden = NO;
        
        Profile *firstProfile = arrCandidateProfiles[profileNumber];
        PFObject *obj = firstProfile.profilePointer;
        NSString *objID = obj.objectId;
        
        //reset progress bar value if already set
        progressBar.hidden = YES;
        [progressBar setValue:0 animateWithDuration:0];
        
        //get traits count
        //condition for gender
        NSString *boyProfileId,*girlProfileId;
        if ([firstProfile.gender isEqualToString:@"Male"])
        {
            boyProfileId = objID;
            girlProfileId = [[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"];
        }
        else
        {
            boyProfileId = [[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"];
            girlProfileId = objID;
        }
        
        [PFCloud callFunctionInBackground:@"matchKundli"
                           withParameters:@{@"boyProfileId":boyProfileId,
                                            @"girlProfileId":girlProfileId}
                                    block:^(NSString *traitResult, NSError *error)
         {
             if (!error)
             {
                 progressBar.hidden = NO;
                 [progressBar setValue:[traitResult floatValue] animateWithDuration:0.5];
                 lblTraitMatch.text = [NSString stringWithFormat:@"%@ Traits Match",traitResult];
                 NSLog(@"Traits matching  = %@",traitResult);
             }
             else
             {
                 NSLog(@"Error info -> %@",error.description);
             }
             
         }];
        
        lblName.text = firstProfile.name;
        lblHeight.text = [NSString stringWithFormat:@"%@,%@",firstProfile.age,firstProfile.height];
        lblProfession.text = firstProfile.designation;
        lblReligion.text = [NSString stringWithFormat:@"%@,%@",firstProfile.religion,firstProfile.caste];
        
        //[self getUserProfilePicForUser:objID];
        //show user profile pic
        imgViewProfilePic.image = firstProfile.profilePic;
        
        //show blurred image
        profileView.hidden = NO;
        blankView.hidden = YES;
        UIImage *effectImage = [UIImageEffects imageByApplyingLightEffectToImage:firstProfile.profilePic];
        self.imgProfileView.image = effectImage;
        
        [self.view.layer addAnimation:trans forKey:nil];
        
        //[self showBlurredImageForUser:objID];
        
    }
    else
    {
        [self.view.layer addAnimation:trans forKey:nil];
        [self viewWillAppear:NO];
        //blankView.hidden = NO;
        //profileView.hidden = YES;
    }
    
}

-(void) getUserProfilePicForUser:(NSString *)objectId
{
    PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
    [query whereKey:@"objectId" equalTo:objectId]; //7ZFYFmiMV9 //EYKXEM27cu  //IRQBKPDl0E
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             // The find succeeded.
             [self retrieveImagesFromObject:objects[0]];
         }
         else
         {
             // Log details of the failure
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
         //
         //[self performSelector:@selector(retrieveImagesFromArray) withObject:nil afterDelay:0.5];
     }];

}


-(void) retrieveImagesFromObject:(PFObject *)object
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFFile *userImageFile = object[@"profilePic"];
    if (userImageFile)
    {
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             if (!error)
             {
                 
                 UIImage *image = [UIImage imageWithData:imageData];
                 //[arrImages addObject:image];
                 imgViewProfilePic.image = image;
             }
             else
             {
                 NSLog(@"Error = > %@",error);
             }
             //add our blurred image to the scrollview
             //profileImageView.image = arrImages[0];
         }];
    }
    else
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        imgViewProfilePic.layer.backgroundColor = [[UIColor lightGrayColor] CGColor];
        imgViewProfilePic.image = [UIImage imageNamed:@"userProfile"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) showBlurredImageForUser:(NSString *)objectId
{
    //remove previously set image
    self.imgProfileView.image= nil;
    //imgViewProfilePic.image = nil;
    
    //get primary image of user
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query whereKey:@"profileId" equalTo:[PFObject objectWithoutDataWithClassName:@"Profile" objectId:objectId]];   //@"EYKXEM27cu"
    [query whereKey:@"isPrimary" equalTo:[NSNumber numberWithBool:YES]];
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
         if (!error)
         {
             if (objects.count > 0)
             {
                 [self getPrimaryImageFromObject:objects[0]];
             }

         }
         else
         {
             // Log details of the failure
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
         //
         //[self performSelector:@selector(retrieveImagesFromArray) withObject:nil afterDelay:0.5];
     }];
}


-(void) getPrimaryImageFromObject:(PFObject *)object
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFFile *primaryImage = object[@"file"];
    if (primaryImage)
    {
        [primaryImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             if (!error)
             {
                 
                 UIImage *image = [UIImage imageWithData:imageData];
                 
                 profileView.hidden = NO;
                 blankView.hidden = YES;
                 UIImage *effectImage = [UIImageEffects imageByApplyingLightEffectToImage:image];
                 self.imgProfileView.image = effectImage;
                 
                 /*
                 CGSize originalSize = image.size;
                 CGSize expectedSize = self.imgProfileView.frame.size;

                 float ratio=expectedSize.width/originalSize.width;
                 
                 float scaledHeight=originalSize.height*1.0;
                 if(scaledHeight < expectedSize.height)
                 {
                     //update height of your imageView frame with scaledHeight
                     self.imgProfileView.frame = CGRectMake(self.imgProfileView.frame.origin.x, self.imgProfileView.frame.origin.y, self.imgProfileView.frame.size.width, scaledHeight);
                 }
                 */
                 //CGSize newSize = [self makeSize:originalSize fitInSize:expectedSize];
                 //image.size = newSize;
                 //self.imgProfileView.frame.size = newSize;
                 //self.imgProfileView.image = image;
                 
                 //apply memory condition
                 //imageData = nil;
                 
                 
                 //blur image
                 /*
                 blurImageProcessor = [[ALDBlurImageProcessor alloc] initWithImage: image];
                 
                 [blurImageProcessor asyncBlurWithRadius: 9
                                              iterations: 7
                                            successBlock: ^( UIImage *blurredImage) {
                                                self.imgProfileView.image = blurredImage;
                                                blurredImage = nil;
                                            }
                                              errorBlock: ^( NSNumber *errorCode ) {
                                                  NSLog( @"Error code: %d", [errorCode intValue] );
                                              }
                  ];
                 */
                 /*
                     self.view.backgroundColor = [UIColor clearColor];
                     
                     UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
                     UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
                     blurEffectView.frame = self.view.bounds;
                     blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                     
                     [self.imgProfileView addSubview:blurEffectView];
                 */
                 
                 //code 02
                 /*
                 UIVisualEffect *blurEffect;
                 blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
                 
                 UIVisualEffectView *visualEffectView;
                 visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
                 
                 visualEffectView.frame = self.imgProfileView.bounds;
                 [self.imgProfileView addSubview:visualEffectView];
                  */

                  
                 
                 //adding blur effect to image
                 /*
                 CIContext *context = [CIContext contextWithOptions:nil];
                 CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
                 
                 CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
                 [filter setValue:inputImage forKey:kCIInputImageKey];
                 [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
                 CIImage *result = [filter valueForKey:kCIOutputImageKey];
                 
                 CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
                 
                 //add our blurred image to the scrollview
                 self.imgProfileView.image = [UIImage imageWithCGImage:cgImage];
                 CGImageRelease(cgImage);
                 */
                 
                 //code 05
                 //create our blurred image
                 /*
                 CIContext *context = [CIContext contextWithOptions:nil];
                 CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
                 
                 //setting up Gaussian Blur (we could use one of many filters offered by Core Image)
                 CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
                 [filter setValue:inputImage forKey:kCIInputImageKey];
                 [filter setValue:[NSNumber numberWithFloat:10.0f] forKey:@"inputRadius"];
                 CIImage *result = [filter valueForKey:kCIOutputImageKey];
                 //CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches up exactly to the bounds of our original image
                 CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
                 
                 //add our blurred image to the scrollview
                 self.imgProfileView.image = [UIImage imageWithCGImage:cgImage];
                  */
                 
                 //code 06
                 //UIImage *blurImg = [self blur:image];
             }
             else
             {
                 NSLog(@"Error = > %@",error);
             }
             //add our blurred image to the scrollview
             //profileImageView.image = arrImages[0];
         }];
    }
    else
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        imgViewProfilePic.layer.backgroundColor = [[UIColor lightGrayColor] CGColor];
        imgViewProfilePic.image = [UIImage imageNamed:@"userProfile"];
    }
}

- (CGSize)makeSize:(CGSize)originalSize fitInSize:(CGSize)boxSize
{
    float widthScale = 0;
    float heightScale = 0;
    
    widthScale = boxSize.width/originalSize.width;
    heightScale = boxSize.height/originalSize.height;
    
    float scale = MIN(widthScale, heightScale);
    
    CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);
    
    return newSize;
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe
{
    //self.imgProfileView.image = [UIImage imageNamed:@"BackG.png"];
    /*
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        currentIndex++;
        [self dislikeAction:nil];
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
        NSLog(@"Right Swipe");
        if(currentIndex!=0)
            currentIndex--;
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp)
    {
        [self performSegueWithIdentifier:@"swipeUpIdentifier" sender:nil];
    }
     */
    //CATransition *transition = [CATransition animation];
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft)
    {
       // [self dislikeAction:nil];
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
       // [self likeAction:nil];
      //  if(self.currentIndex!=0){
        //    self.currentIndex--;
        
        /*}
        else{
            [transition setType:kCATransition];
            transition.duration = 0.0f;
        }
         */
        /*
        //remove current object for arrCandidateProfiles array , and add in cache array in case of Undo action
        [arrCache addObject:arrCandidateProfiles[profileNumber]];
        Profile *userProfileObj = [arrCache lastObject];
        [arrCandidateProfiles removeObjectAtIndex:profileNumber];
        
        
        if (arrCandidateProfiles.count > 0)
        {
            transition.duration = .3f;
            [transition setType:kCATransitionPush];
            [transition setSubtype:kCATransitionFromLeft];
            [self likeAction:userProfileObj];
        }
        else
        {
            [self viewWillAppear:NO];
        }*/
    }
    //[self.view.layer addAnimation:transition forKey:nil];
    
    //Photos *photo = self.arrImages[self.currentIndex];
    //[imageView setImage:photo.image];
}

- (IBAction)menuButtonAction:(id)sender
{
    
}
- (IBAction)shareButtonAction:(id)sender
{
    
}

- (IBAction)matchesButtonAction:(id)sender
{
    
}

- (IBAction)showCandidateProfile:(id)sender
{
    //[self performSegueWithIdentifier:@"swipeUpIdentifier" sender:nil];
    CandidateProfileDetailScreenVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CandidateProfileDetailScreenVC"];
    Profile *candidateProfile = arrCandidateProfiles[profileNumber];
    vc.profileObject = candidateProfile;
    //UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vc];
    //navController.navigationBarHidden =YES;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (IBAction)pinAction:(id)sender
{
    //insert data in pinned profile table
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    CATransition *transition = [CATransition animation];
    
    if (arrCandidateProfiles.count > 0)
    {
        transition.duration = .3f;
        [transition setType:kCATransitionPush];
        [transition setSubtype:kCATransitionFromRight];
        //[self likeAction:userProfileObj];
        Profile *userProfileObj = arrCandidateProfiles[profileNumber];
        NSString *strObjId = userProfileObj.profilePointer.objectId;
        //make entry in like table
        PFObject *pinObj = [PFObject objectWithClassName:@"PinnedProfile"];
        pinObj[@"profileId"] = [PFObject objectWithoutDataWithClassName:@"Profile" objectId:[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"]];
        pinObj[@"pinnedProfileId"] = [PFObject objectWithoutDataWithClassName:@"Profile" objectId:strObjId];
        
        [pinObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             if (succeeded)
             {
                 //add curent action data in History model
                 History *historyObj = [[History alloc]init];
                 historyObj.historyObjectId = pinObj.objectId;
                 historyObj.profileId = [[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"];
                 historyObj.actionProfileId = strObjId;
                 historyObj.actionType = 2;     //pin action:2
                 
                 //save History model object in arrHistory
                 [arrHistory addObject:historyObj];
                 
                 //remove current object for arrCandidateProfiles array , and add in cache array in case of Undo action
                 [arrCache addObject:arrCandidateProfiles[profileNumber]];
                 [arrCandidateProfiles removeObjectAtIndex:profileNumber];
                 
                 //enable/disable undo Button
                 if (arrCache.count > 0)
                 {
                     btnUndo.enabled = YES;
                 }
                 else
                 {
                     btnUndo.enabled = NO;
                 }
                 
                 //perform animation
                 
                 profileNumber = 0;
                 [self showProfileOfCandidateNumber:profileNumber withTransition:transition];
                 //[self performSelector:@selector(animateScreenWithTransition:) withObject:transition afterDelay:2.0];
             }
             else
             {
                 // There was a problem, check error.description
             }
         }];
    }
    else
    {
        [self viewWillAppear:NO];
    }
}

-(void) animateScreenWithTransition :(CATransition *)transition
{
    [self.view.layer addAnimation:transition forKey:nil];
}

- (IBAction)likeAction:(id)sender
{
    PFUser *user = [PFUser currentUser];
    NSLog(@"user name -> %@",user.username);
    NSLog(@"profile user name -> %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileName"]);
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    CATransition *transition = [CATransition animation];
    
    if (arrCandidateProfiles.count > 0)
    {
        transition.duration = .3f;
        [transition setType:kCATransitionPush];
        [transition setSubtype:kCATransitionFromRight];
        //[self likeAction:userProfileObj];
        Profile *userProfileObj = arrCandidateProfiles[profileNumber];
        NSString *strObjId = userProfileObj.profilePointer.objectId;
        /*
        //make entry in like table
        PFObject *likeObj = [PFObject objectWithClassName:@"LikedProfile"];
        likeObj[@"profileId"] = [PFObject objectWithoutDataWithClassName:@"Profile" objectId:[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"]];
        likeObj[@"likeProfileId"] = [PFObject objectWithoutDataWithClassName:@"Profile" objectId:userProfileObj.name];
        
        [likeObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             if (succeeded)
             {
                 // The object has been saved.
                 NSLog(@"new object Id = %@",likeObj.objectId);
                 //NSString *strObj = likeObj.objectId;
                 
         
                 
         
                 
             }
             else
             {
                 // There was a problem, check error.description
             }
         }];
        */
        [PFCloud callFunctionInBackground:@"likeAndFind"
                           withParameters:@{@"userProfileId":[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"],
                                            @"likeProfileId":strObjId,
                                            @"userName":[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileName"]}
                                    block:^(id results, NSError *error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             
             if (!error)
             {
                 //insert data in History Model
                 
                 // this is where you handle the results and change the UI.
                 if ([results isKindOfClass:[NSString class]])
                 {
                     //proceed to show next profile - like function
                     
                     //add curent action data in History model
                     History *historyObj = [[History alloc]init];
                     historyObj.historyObjectId = results;
                     historyObj.profileId = [[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"];
                     historyObj.actionProfileId = strObjId;
                     historyObj.actionType = 1;     //like action:1
                     
                     //save History model object in arrHistory
                     [arrHistory addObject:historyObj];
                     
                     //remove current object for arrCandidateProfiles array , and add in cache array in case of Undo action
                     [arrCache addObject:arrCandidateProfiles[profileNumber]];
                     [arrCandidateProfiles removeObjectAtIndex:profileNumber];
                     
                     //enable/disable undo Button
                     if (arrCache.count > 0)
                     {
                         btnUndo.enabled = YES;
                     }
                     else
                     {
                         btnUndo.enabled = NO;
                     }
                     
                     //perform animation
                     //[self.view.layer addAnimation:transition forKey:nil];
                     profileNumber = 0;
                     [self showProfileOfCandidateNumber:profileNumber withTransition:transition];
                 }
                 else
                 {
                     //store profile object to show profile details on popover screen - like back
                     Profile *likedProfileObj = [[Profile alloc] init];
                     likedProfileObj = arrCandidateProfiles[profileNumber];
                     
                     //show "You just got matched" view
                     //retrieve last inserted object id from likedprofile class
                     PFObject *likeObj = results;
                     
                     //add curent action data in History model
                     History *historyObj = [[History alloc]init];
                     historyObj.historyObjectId = likeObj.objectId;
                     historyObj.profileId = [[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"];
                     historyObj.actionProfileId = strObjId;
                     historyObj.actionType = 1;     //like action:1
                     
                     //save History model object in arrHistory
                     [arrHistory addObject:historyObj];
                     
                     //remove current object for arrCandidateProfiles array , and add in cache array in case of Undo action
                     [arrCache addObject:arrCandidateProfiles[profileNumber]];
                     [arrCandidateProfiles removeObjectAtIndex:profileNumber];
                     
                     //enable/disable undo Button
                     if (arrCache.count > 0)
                     {
                         btnUndo.enabled = YES;
                     }
                     else
                     {
                         btnUndo.enabled = NO;
                     }
                     
                     //perform animation
                     //[self.view.layer addAnimation:transition forKey:nil];
                     profileNumber = 0;
                     [self showProfileOfCandidateNumber:profileNumber withTransition:transition];
                     
                     //show popover view
                     [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"reloadCandidateList"];
                     MatchScreenVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MatchScreenVC"];
                     vc.profileObj = likedProfileObj;
                     vc.txtTraits = lblTraitMatch.text;
                     
                     [self.navigationController presentViewController:vc animated:YES completion:nil];
                     
                     //new code
                     /*
                     //[settingsPopoverController dismissPopoverAnimated:YES];
                     MatchScreenVC *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MatchScreenVC"];
                     viewController.preferredContentSize = CGSizeMake(310, 200);
                     viewController.delegate = self;
                     viewController.modalInPopover = NO;
                     
                     
                     //UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
                     //settingsPopoverController = [[WYPopoverController alloc]initWithContentViewController:contentViewController];
                     //settingsPopoverController.delegate = self;
                     //settingsPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
                     //settingsPopoverController.wantsDefaultContentAppearance = NO;
                     [viewController presentPopoverFromRect:CGRectMake(0, 0, 300, 480)
                                                                inView:self.view
                                              permittedArrowDirections:WYPopoverArrowDirectionAny
                                                              animated:YES
                                                               options:WYPopoverAnimationOptionFadeWithScale];
                     */
                      /*
                     [settingsPopoverController dismissPopoverAnimated:YES];
                     WorkAfterMarriagePopoverViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WorkAfterMarriagePopoverViewController"];
                     viewController.preferredContentSize = CGSizeMake(310, 200);
                     viewController.delegate = self;
                     viewController.title = @"Want to work after Marriage?";
                     viewController.modalInPopover = NO;
                     UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
                     settingsPopoverController = [[WYPopoverController alloc]initWithContentViewController:contentViewController];
                     settingsPopoverController.delegate = self;
                     //settingsPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
                     settingsPopoverController.wantsDefaultContentAppearance = NO;
                     [settingsPopoverController presentPopoverFromRect:marraigeCellRect
                                                                inView:self.tableView
                                              permittedArrowDirections:WYPopoverArrowDirectionAny
                                                              animated:YES
                                                               options:WYPopoverAnimationOptionFadeWithScale];
                      */
                 }
             }
             
         }];
        
    }
    else
    {
        [self viewWillAppear:NO];
    }
}

- (IBAction)dislikeAction:(id)sender
{
    //make entry in dislike table
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    CATransition *transition = [CATransition animation];
    
    if (arrCandidateProfiles.count > 0)
    {
        transition.duration = .3f;
        [transition setType:kCATransitionPush];
        [transition setSubtype:kCATransitionFromRight];
        Profile *userProfileObj = arrCandidateProfiles[profileNumber];
        NSString *strObjId = userProfileObj.profilePointer.objectId;
     
        //make entry in like table
        PFObject *dislikeObj = [PFObject objectWithClassName:@"DislikeProfile"];
        dislikeObj[@"profileId"] = [PFObject objectWithoutDataWithClassName:@"Profile" objectId:[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"]];
        dislikeObj[@"dislikeProfileId"] = [PFObject objectWithoutDataWithClassName:@"Profile" objectId:strObjId];
        
        [dislikeObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             if (succeeded)
             {
                 //add curent action data in History model
                 History *historyObj = [[History alloc]init];
                 historyObj.historyObjectId = dislikeObj.objectId;
                 historyObj.profileId = [[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"];
                 historyObj.actionProfileId = strObjId;
                 historyObj.actionType = 0;     //dislike action:2
                 
                 //save History model object in arrHistory
                 [arrHistory addObject:historyObj];
                 
                 //remove current object for arrCandidateProfiles array , and add in cache array in case of Undo action
                 [arrCache addObject:arrCandidateProfiles[profileNumber]];
                 [arrCandidateProfiles removeObjectAtIndex:profileNumber];
                 
                 //enable/disable undo Button
                 if (arrCache.count > 0)
                 {
                     btnUndo.enabled = YES;
                 }
                 else
                 {
                     btnUndo.enabled = NO;
                 }
                 
                 //perform animation
                 
                 profileNumber = 0;
                 [self showProfileOfCandidateNumber:profileNumber withTransition:transition];
                 //[self.view.layer addAnimation:transition forKey:nil];
                 
             }
             else
             {
                 // There was a problem, check error.description
             }
         }];
    }
    else
    {
        [self viewWillAppear:NO];
    }
}

- (IBAction)undoAction:(id)sender
{
    //get data from History Object
    History *histObject = [arrHistory lastObject];
    NSString *parseClassName;
    switch (histObject.actionType)
    {
        case 0:
            //dislike
            parseClassName = @"DislikeProfile";
            break;
        case 1:
            //like
            parseClassName = @"LikedProfile";
            break;
        case 2:
            //pin
            parseClassName = @"PinnedProfile";
            break;
    }
    [self deleteObject:histObject.historyObjectId FromClassName:parseClassName];
}

- (IBAction)refreshAction:(id)sender
{
    [self viewWillAppear:NO];
}

-(void) deleteObject:(NSString *)ObjectID FromClassName:(NSString *)class
{
    CATransition *transition = [CATransition animation];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:class];
    [query whereKey:@"objectId" equalTo:ObjectID];
    //query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error)
        {
            transition.duration = .3f;
            [transition setType:kCATransitionPush];
            [transition setSubtype:kCATransitionFromLeft];
            
            [PFObject deleteAllInBackground:objects];
            //[self showObjectFromHistory];
            
            //add history object in arrCandidateProfile
            [arrCandidateProfiles addObject:[arrCache lastObject]];
            profileNumber = arrCandidateProfiles.count - 1;
            [self showProfileOfCandidateNumber:profileNumber withTransition:transition];
            [arrCache removeLastObject];
            [arrHistory removeLastObject];
            if (arrCache.count > 0)
            {
                btnUndo.enabled = YES;
            }
            else
            {
                btnUndo.enabled = NO;
            }
            
            //[self.view.layer addAnimation:transition forKey:nil];
        }
        else
        {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (IBAction)openChatPinMatchScreen:(id)sender
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ChatPinMatch" bundle:nil];
    ChatPinMatchViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ChatPinMatchViewController"];
    vc.layerClient =self.layerClient;
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vc];
    navController.navigationBarHidden =YES;
    [self presentViewController:navController animated:YES completion:nil];
    //[self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"swipeUpIdentifier"])
    {
        CandidateProfileDetailScreenVC *profileVC = [segue destinationViewController];
        Profile *candidateProfile = arrCandidateProfiles[profileNumber];
        profileVC.profileObject = candidateProfile;
        //[self.navigationController pushViewController:profileVC animated:YES];
        
//        CandidateProfileDetailScreenVC *vc = [sb2 instantiateViewControllerWithIdentifier:@"CandidateProfileDetailScreenVC"];
//        vc.profileObject = profileModel;
//        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vc];
//        navController.navigationBarHidden =YES;
//        [self presentViewController:navController animated:YES completion:nil];
    }
    
}
#pragma mark - Layer Authentication Methods

- (void)loginLayer
{
    // Connect to Layer
    // See "Quick Start - Connect" for more details
    // https://developer.layer.com/docs/quick-start/ios#connect
    [self.layerClient connectWithCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"Failed to connect to Layer: %@", error);
        } else {
            PFUser *user = [PFUser currentUser];
            NSString *userID = user.objectId;
            [self authenticateLayerWithUserID:userID completion:^(BOOL success, NSError *error) {
                if (!error){
                    NSLog(@" Authenticated Layer Client ");
                } else {
                    NSLog(@"Failed Authenticating Layer Client with error:%@", error);
                }
            }];
        }
    }];
}

- (void)authenticateLayerWithUserID:(NSString *)userID completion:(void (^)(BOOL success, NSError * error))completion
{
    // Check to see if the layerClient is already authenticated.
    if (self.layerClient.authenticatedUserID) {
        // If the layerClient is authenticated with the requested userID, complete the authentication process.
        if ([self.layerClient.authenticatedUserID isEqualToString:userID]){
            NSLog(@"Layer Authenticated as User %@", self.layerClient.authenticatedUserID);
            if (completion) completion(YES, nil);
            return;
        } else {
            //If the authenticated userID is different, then deauthenticate the current client and re-authenticate with the new userID.
            [self.layerClient deauthenticateWithCompletion:^(BOOL success, NSError *error) {
                if (!error){
                    [self authenticationTokenWithUserId:userID completion:^(BOOL success, NSError *error) {
                        if (completion){
                            completion(success, error);
                        }
                    }];
                } else {
                    if (completion){
                        completion(NO, error);
                    }
                }
            }];
        }
    } else {
        // If the layerClient isn't already authenticated, then authenticate.
        [self authenticationTokenWithUserId:userID completion:^(BOOL success, NSError *error) {
            if (completion){
                completion(success, error);
            }
        }];
    }
}

- (void)authenticationTokenWithUserId:(NSString *)userID completion:(void (^)(BOOL success, NSError* error))completion
{
    /*
     * 1. Request an authentication Nonce from Layer
     */
    [self.layerClient requestAuthenticationNonceWithCompletion:^(NSString *nonce, NSError *error) {
        if (!nonce) {
            if (completion) {
                completion(NO, error);
            }
            return;
        }
        
        /*
         * 2. Acquire identity Token from Layer Identity Service
         */
        if(userID){
            NSDictionary *parameters = @{@"nonce" : nonce, @"userID" : userID};
            [PFCloud callFunctionInBackground:@"generateToken" withParameters:parameters block:^(id object, NSError *error) {
                if (!error){
                    
                    NSString *identityToken = (NSString*)object;
                    [self.layerClient authenticateWithIdentityToken:identityToken completion:^(NSString *authenticatedUserID, NSError *error) {
                        if (authenticatedUserID) {
                            if (completion) {
                                completion(YES, nil);
                            }
                            NSLog(@"Layer Authenticated as User: %@", authenticatedUserID);
                        } else {
                            completion(NO, error);
                        }
                    }];
                } else {
                    NSLog(@"Parse Cloud function failed to be called to generate token with error: %@", error);
                }
            }];

        }
        
        
    }];
}

@end
