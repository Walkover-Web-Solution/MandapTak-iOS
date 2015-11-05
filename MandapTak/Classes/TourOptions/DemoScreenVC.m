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
    profileView.hidden = YES;
    blankView.hidden = NO;
    
}
@end
