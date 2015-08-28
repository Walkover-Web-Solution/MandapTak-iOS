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
        [PFCloud callFunctionInBackground:@"filterProfileLive"
                           withParameters:@{@"oid":@"nASUvS6R7Z"}
                                    block:^(NSArray *results, NSError *error)
         {
             if (!error)
             {
                 // this is where you handle the results and change the UI.
                 for (PFObject *profileObj in results)
                 {
                     Profile *profileModel = [[Profile alloc]init];
                     profileModel.profilePointer = profileObj;
                     profileModel.name = profileObj[@"name"];
                     profileModel.age = [NSString stringWithFormat:@"%@",profileObj[@"age"]];
                     profileModel.height = [NSString stringWithFormat:@"%@",profileObj[@"height"]];
                     profileModel.weight = [NSString stringWithFormat:@"%@",profileObj[@"weight"]];
                     //caste label
                     PFObject *caste = [profileObj valueForKey:@"casteId"];
                     PFObject *religion = [profileObj valueForKey:@"religionId"];
                     NSLog(@"religion = %@ and caste = %@",[religion valueForKey:@"name"],[caste valueForKey:@"name"]);
                     profileModel.religion = [religion valueForKey:@"name"];
                     profileModel.caste = [caste valueForKey:@"name"];
                     profileModel.designation = profileObj[@"designation"];
                     
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
                     
                     [arrCandidateProfiles addObject:profileModel];
                 }
                 [self showFirstProfile];
             }
         }];
    }
    else
    {
        [userDefaults setValue:@"yes" forKey:@"reloadCandidateList"];
    }
}


-(void) showFirstProfile
{
    Profile *firstProfile = arrCandidateProfiles[0];
    PFObject *obj = firstProfile.profilePointer;
    lblName.text = firstProfile.name;
    lblHeight.text = firstProfile.height;
    lblProfession.text = firstProfile.designation;
    lblReligion.text = [NSString stringWithFormat:@"%@,%@",firstProfile.religion,firstProfile.caste];
    NSLog(@"candidate name and age = %@",obj[@"name"]);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe
{
    NSArray *detailLbl = @[@"Profile_1.png",@"Profile_2.png",@"Profile_3.png"];

    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        currentIndex++;
    }

    if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
        NSLog(@"Right Swipe");
        if(currentIndex!=0)
            currentIndex--;
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp)
    {
        /*
        NSLog(@"Swipe Up");
        UIStoryboard *sbProfile = [UIStoryboard storyboardWithName:@"CandidateProfile" bundle:nil];
        CandidateProfileDetailScreenVC *detailVC = [sbProfile instantiateViewControllerWithIdentifier:@"CandidateProfileDetailScreenVC"];
        
        //vc.globalCompanyId = [self.companies.companyId intValue];
        
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:detailVC];
        self.navigationController.navigationBarHidden = NO;
        //navController.navigationBarHidden =YES;
        [self presentViewController:navController animated:YES completion:nil];
         */
        
        //[self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        //[self prepareForSegue:@"swipeUpIdentifier" sender:nil];
        [self performSegueWithIdentifier:@"swipeUpIdentifier" sender:nil];
    }

    //[self.imgProfileView setImage:[UIImage imageNamed:detailLbl[currentIndex]]];
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
@end
