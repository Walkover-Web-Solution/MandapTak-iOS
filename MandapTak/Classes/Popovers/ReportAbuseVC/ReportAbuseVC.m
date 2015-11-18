//
//  ReportAbuseVC.m
//  MandapTak
//
//  Created by Anuj Jain on 11/17/15.
//  Copyright © 2015 Walkover. All rights reserved.
//

#import "ReportAbuseVC.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

@interface ReportAbuseVC ()
{
    
    IBOutlet UITextView *txtReason;
    IBOutlet UIActivityIndicatorView *activityIndicator;
}
- (IBAction)submit:(id)sender;
@end

@implementation ReportAbuseVC
@synthesize reportedProfile;

- (void)viewDidLoad {
    [super viewDidLoad];
    activityIndicator.hidden = YES;
    
    //enlarge activity indicator view
    activityIndicator.transform = CGAffineTransformMakeScale(0.75, 0.75);
    
    //textview border
    //UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(50, 220, 200, 100)];
    
    //To make the border look very close to a UITextField
    [txtReason.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [txtReason.layer setBorderWidth:2.0];
    
    //The rounded corner part, where you specify your view's corner radius:
    txtReason.layer.cornerRadius = 5;
    txtReason.clipsToBounds = YES;
    
    // Do any additional setup after loading the view.
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

- (IBAction)submit:(id)sender {
    if (txtReason.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please provide a reason." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        return;
    }
    [self showLoader];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"]);
    NSString *reason = txtReason.text;
    [PFCloud callFunctionInBackground:@"reportUser"
                       withParameters:@{@"reason":reason,
                                        @"profileId" : [[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"],
                                        @"reportedProfile" : reportedProfile}
                                block:^(NSArray *results, NSError *error)
     {
         [self hideLoader];
         if (!error)
         {
             [[[UIAlertView alloc] initWithTitle:nil message:@"Submitted Successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
             [self.delegate closePopover];
         }
         else
         {
             UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [av show];
             return;
         }
     }];
}

#pragma mark ShowActivityIndicator

-(void)showLoader{
    activityIndicator.hidden = NO;
    [activityIndicator startAnimating];
}

-(void)hideLoader
{
    activityIndicator.hidden = YES;
    [activityIndicator stopAnimating];
}

@end
