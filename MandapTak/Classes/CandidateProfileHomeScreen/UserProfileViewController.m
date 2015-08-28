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
    profileNumber = 0;
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
   // [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    //[self.view addGestureRecognizer:swipeRight];
        // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    //_sidebarButton.tintColor = [UIColor colorWithRed:235/255 green:84/255 blue:80/255 alpha:1];
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeUp];

    [self.revealViewController.panGestureRecognizer requireGestureRecognizerToFail:swipeLeft];
    [self.revealViewController.panGestureRecognizer requireGestureRecognizerToFail:swipeUp];
    PFUser *user = [PFUser user];
    user.username = @"Hussain";
    user.password = @"hussainPass";
    
    
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
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init];
    if (![[userDefaults valueForKey:@"reloadCandidateList"]isEqualToString:@"no"])
    {
        MBProgressHUD *HUD;
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        [PFCloud callFunctionInBackground:@"filterProfileLive"
                           withParameters:@{@"oid":@"nASUvS6R7Z"}
                                    block:^(NSArray *results, NSError *error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             if (!error)
             {
                 // this is where you handle the results and change the UI.
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
                     NSLog(@"religion = %@ and caste = %@",[religion valueForKey:@"name"],[caste valueForKey:@"name"]);
                     profileModel.religion = [religion valueForKey:@"name"];
                     profileModel.caste = [caste valueForKey:@"name"];
                     profileModel.designation = profileObj[@"designation"];
                     
                     //Height
                     profileModel.height = [self getFormattedHeightFromValue:[NSString stringWithFormat:@"%@cm",[profileObj valueForKey:@"height"]]];
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
         }];
    }
    else
    {
        [userDefaults setValue:@"yes" forKey:@"reloadCandidateList"];
    }
}


- (NSString *)getFormattedHeightFromValue:(NSString *)value
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", value];
    NSString *strFiltered = [[arrHeight filteredArrayUsingPredicate:predicate] firstObject];
    return strFiltered;
}

-(void) showProfileOfCandidateNumber:(int)number
{
    Profile *firstProfile = arrCandidateProfiles[profileNumber];
    PFObject *obj = firstProfile.profilePointer;
    lblName.text = firstProfile.name;
    lblHeight.text = [NSString stringWithFormat:@"%@,%@",firstProfile.age,firstProfile.height];
    lblProfession.text = firstProfile.designation;
    lblReligion.text = [NSString stringWithFormat:@"%@,%@",firstProfile.religion,firstProfile.caste];
    [self showBlurredImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) showBlurredImage
{
    
    //adding blur effect to image
    UIImage *theImage = [UIImage imageNamed:@"sampleImage03.jpg"];
    
    //create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    //setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    //CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    //add our blurred image to the scrollview
    self.imgProfileView.image = [UIImage imageWithCGImage:cgImage];
   
    //[self.view bringSubviewToFront:imgViewProfilePic];
    /*
    // show image
    self.imgProfileView.image = [UIImage imageNamed:@"Profile_1.png"];
    
    // create effect
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    // add effect to an effect view
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = self.view.frame;
    
    // add the effect view to the image view
    [self.imgProfileView addSubview:effectView];
     */
}


- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe
{
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
        //if(self.currentIndex!=self.arrImages.count-1){
            //self.currentIndex++;
            transition.duration = .3f;
            [transition setType:kCATransitionPush];
            [transition setSubtype:kCATransitionFromRight];
        [self dislikeAction:nil];
        /*}
        else{
            [transition setType:kCATransition];
            transition.duration = 0.0f;
        }
         */
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
      //  if(self.currentIndex!=0){
        //    self.currentIndex--;
            transition.duration = .3f;
            [transition setType:kCATransitionPush];
            [transition setSubtype:kCATransitionFromLeft];
        /*}
        else{
            [transition setType:kCATransition];
            transition.duration = 0.0f;
        }
         */
    }
    
    
    [self.imgProfileView.layer addAnimation:transition forKey:nil];
    
    //Photos *photo = self.arrImages[self.currentIndex];
    //[imageView setImage:photo.image];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    /*
    if ([segue.identifier isEqualToString:@"swipeUpIdentifier"])
    {
        CandidateProfileDetailScreenVC *profileVC = [segue destinationViewController];
        [self.navigationController pushViewController:profileVC animated:YES];
    }
    */
}

- (IBAction)menuButtonAction:(id)sender {
}
- (IBAction)shareButtonAction:(id)sender {
}

- (IBAction)matchesButtonAction:(id)sender {
}
- (IBAction)showCandidateProfile:(id)sender
{
    [self performSegueWithIdentifier:@"swipeUpIdentifier" sender:nil];
}

- (IBAction)pinAction:(id)sender {
}

- (IBAction)likeAction:(id)sender {
}

- (IBAction)dislikeAction:(id)sender
{
    profileNumber++;
    [self showProfileOfCandidateNumber:profileNumber];
}
@end
