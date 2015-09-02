//
//  UserProfileViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 27/07/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "UserProfileViewController.h"
#import "SWRevealViewController.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentIndex = 0;
    
    arrCandidateProfiles = [[NSMutableArray alloc] init];
    arrCache = [[NSMutableArray alloc] init];
    arrHistory = [[NSMutableArray alloc] init];
    
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
    PFUser *user = [PFUser user];
    user.username = @"Hussain";
    user.password = @"hussainPass";
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
    [arrHistory removeAllObjects];
    [arrCache removeAllObjects];
    lblMessage.text = @"Finding profiles...";
    
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init];
    if (![[userDefaults valueForKey:@"reloadCandidateList"]isEqualToString:@"no"])
    {
        MBProgressHUD *HUD;
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

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
                     blankView.hidden = YES;
                     profileView.hidden = NO;
                     
                     for (PFObject *profileObj in results)
                     {
                         Profile *profileModel = [[Profile alloc]init];
                         profileModel.profilePointer = profileObj;
                         profileModel.name = profileObj[@"name"];
                         profileModel.age = [NSString stringWithFormat:@"%@",profileObj[@"age"]];
                         //profileModel.height = [NSString stringWithFormat:@"%@",profileObj[@"height"]];
                         profileModel.weight = [NSString stringWithFormat:@"%@",profileObj[@"weight"]];
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
                         
                         /*
                          //education
                          NSMutableArray *arrDegrees = [[NSMutableArray alloc]init];
                          NSMutableArray *arrSpecialization = [[NSMutableArray alloc]init];
                          
                          for (int i=1; i<4; i++)
                          {
                          Education *educationObject = [[Education alloc]init];
                          NSString *eduLevel = [NSString stringWithFormat:@"education%d",i];
                          PFObject *specialization = [profileObj valueForKey:eduLevel];
                          PFObject *degreeName = [specialization valueForKey:@"degreeId"];
                          //NSString *specializationName = [specialization valueForKey:@"name"];
                          NSString *strDegrees = [degreeName valueForKey:@"name"];
                          if (strDegrees.length > 0)
                          {
                          [arrDegrees addObject:strDegrees];
                          //save data for full profile screen
                          educationObject.degree = degreeName;
                          educationObject.specialisation = specialization;
                          [arrEducation addObject:educationObject];
                          }
                          }
                          //NSString *strAllDegree = [arrDegrees componentsJoinedByString:@","];
                          //lblEducation.text = [NSString stringWithFormat:@"%@",strAllDegree];
                          */
                         [arrCandidateProfiles addObject:profileModel];
                     }
                     [self showProfileOfCandidateNumber:profileNumber];
                 }
                 else
                 {
                     //open blank View
                     [self.view bringSubviewToFront:blankView];
                     lblMessage.text = [NSString stringWithFormat:@"No matching profiles found...!!"];
                 }
             }
         }];
    }
    else
    {
        [userDefaults setValue:@"yes" forKey:@"reloadCandidateList"];
    }
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

-(void) showProfileOfCandidateNumber:(int)number
{
    if (arrCandidateProfiles.count >0)
    {
        blankView.hidden = YES;
        profileView.hidden = NO;
        
        Profile *firstProfile = arrCandidateProfiles[profileNumber];
        PFObject *obj = firstProfile.profilePointer;
        NSString *objID = obj.objectId;
        lblName.text = firstProfile.name;
        lblHeight.text = [NSString stringWithFormat:@"%@,%@",firstProfile.age,firstProfile.height];
        lblProfession.text = firstProfile.designation;
        lblReligion.text = [NSString stringWithFormat:@"%@,%@",firstProfile.religion,firstProfile.caste];
        [self getUserProfilePicForUser:objID];
        [self showBlurredImageForUser:objID];
    }
    else
    {
        [self viewWillAppear:NO];
        //blankView.hidden = NO;
        //profileView.hidden = YES;
    }
    
}

-(void) getUserProfilePicForUser:(NSString *)objectId
{
    PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
    [query whereKey:@"objectId" equalTo:objectId]; //7ZFYFmiMV9 //EYKXEM27cu   //IRQBKPDl0E

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
    //get primary image of user
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query whereKey:@"profileId" equalTo:[PFObject objectWithoutDataWithClassName:@"Profile" objectId:objectId]];   //@"EYKXEM27cu"
    [query whereKey:@"isPrimary" equalTo:[NSNumber numberWithBool:YES]];
    
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
                 CGSize originalSize = image.size;
                 CGSize expectedSize = self.imgProfileView.frame.size;

                 float ratio=expectedSize.width/originalSize.width;
                 
                 float scaledHeight=originalSize.height*1.0;
                 if(scaledHeight < expectedSize.height)
                 {
                     //update height of your imageView frame with scaledHeight
                     self.imgProfileView.frame = CGRectMake(self.imgProfileView.frame.origin.x, self.imgProfileView.frame.origin.y, self.imgProfileView.frame.size.width, scaledHeight);
                    }
                 
                 //CGSize newSize = [self makeSize:originalSize fitInSize:expectedSize];
                 //image.size = newSize;
                 //self.imgProfileView.frame.size = newSize;
                 self.imgProfileView.image = image;
                 
                 profileView.hidden = NO;
                 blankView.hidden = NO;
                 
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
                  */
                 //CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
                 
                 //add our blurred image to the scrollview
                 //self.imgProfileView.image = [UIImage imageWithCGImage:cgImage];
                  //CGImageRelease(cgImage);
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
    CATransition *transition = [CATransition animation];
    
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
    [self performSegueWithIdentifier:@"swipeUpIdentifier" sender:nil];
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
        pinObj[@"profileId"] = [PFObject objectWithoutDataWithClassName:@"Profile" objectId:@"nASUvS6R7Z"];
        pinObj[@"pinnedProfileId"] = [PFObject objectWithoutDataWithClassName:@"Profile" objectId:strObjId];
        
        [pinObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             if (succeeded)
             {
                 // The object has been saved.
                 NSLog(@"new object Id = %@",pinObj.objectId);
                 //NSString *strObj = likeObj.objectId;
                 
                 //add curent action data in History model
                 History *historyObj = [[History alloc]init];
                 historyObj.historyObjectId = pinObj.objectId;
                 historyObj.profileId = @"nASUvS6R7Z";
                 historyObj.actionProfileId = strObjId;
                 historyObj.actionType = 2;     //pin action:2
                 
                 //save History model object in arrCache
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
                 [self.view.layer addAnimation:transition forKey:nil];
                 profileNumber = 0;
                 [self showProfileOfCandidateNumber:profileNumber];
                 
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

- (IBAction)likeAction:(id)sender
{
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
        PFObject *likeObj = [PFObject objectWithClassName:@"LikedProfile"];
        likeObj[@"profileId"] = [PFObject objectWithoutDataWithClassName:@"Profile" objectId:@"nASUvS6R7Z"];
        likeObj[@"likeProfileId"] = [PFObject objectWithoutDataWithClassName:@"Profile" objectId:strObjId];
        
        [likeObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             if (succeeded)
             {
                 // The object has been saved.
                 NSLog(@"new object Id = %@",likeObj.objectId);
                 //NSString *strObj = likeObj.objectId;
                 
                 //add curent action data in History model
                 History *historyObj = [[History alloc]init];
                 historyObj.historyObjectId = likeObj.objectId;
                 historyObj.profileId = @"nASUvS6R7Z";
                 historyObj.actionProfileId = strObjId;
                 historyObj.actionType = 1;     //like action:1
                 
                 //save History model object in arrCache
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
                 [self.view.layer addAnimation:transition forKey:nil];
                 profileNumber = 0;
                 [self showProfileOfCandidateNumber:profileNumber];
                 
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
        dislikeObj[@"profileId"] = [PFObject objectWithoutDataWithClassName:@"Profile" objectId:@"nASUvS6R7Z"];
        dislikeObj[@"dislikeProfileId"] = [PFObject objectWithoutDataWithClassName:@"Profile" objectId:strObjId];
        
        [dislikeObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             if (succeeded)
             {
                 //add curent action data in History model
                 History *historyObj = [[History alloc]init];
                 historyObj.historyObjectId = dislikeObj.objectId;
                 historyObj.profileId = @"nASUvS6R7Z";
                 historyObj.actionProfileId = strObjId;
                 historyObj.actionType = 0;     //dislike action:2
                 
                 //save History model object in arrCache
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
                 [self showProfileOfCandidateNumber:profileNumber];
                 [self.view.layer addAnimation:transition forKey:nil];
                 
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

-(void) deleteObject:(NSString *)ObjectID FromClassName:(NSString *)class
{
    CATransition *transition = [CATransition animation];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:class];
    [query whereKey:@"objectId" equalTo:ObjectID];
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
            [self showProfileOfCandidateNumber:profileNumber];
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
            
            [self.view.layer addAnimation:transition forKey:nil];
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
    }
    
}
@end
