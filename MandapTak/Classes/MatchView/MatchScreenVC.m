//
//  MatchScreenVC.m
//  MandapTak
//
//  Created by Anuj Jain on 9/15/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "MatchScreenVC.h"
#import "SWRevealViewController.h"

@interface MatchScreenVC ()
{
    
    IBOutlet UIImageView *userImageView;
    IBOutlet UILabel *lblName;
    IBOutlet UILabel *lblAgeHeight;
    IBOutlet UILabel *lblReligion;
    IBOutlet UILabel *lblDesignation;
    IBOutlet UILabel *lblTraits;
}
- (IBAction)back:(id)sender;

@end

@implementation MatchScreenVC
@synthesize profileObj,txtTraits;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set image view frame = circular
    userImageView.layer.cornerRadius = 80.0f;
    userImageView.clipsToBounds = YES;
    
    //[[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"isNotification"];
    // Do any additional setup after loading the view.
    
    lblName.text = profileObj.name;
    lblAgeHeight.text = [NSString stringWithFormat:@"%@,%@",profileObj.age,profileObj.height];
    lblDesignation.text = profileObj.designation;
    lblReligion.text = [NSString stringWithFormat:@"%@,%@",profileObj.religion,profileObj.caste];
    lblTraits.text = txtTraits;
    //[self getUserProfilePicForUser:objID];
    //show user profile pic
    userImageView.image = profileObj.profilePic;
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
    /*
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isNotification"] isEqualToString:@"yes"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"isNotification"];
        //UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SWRevealViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
        //[self dismissViewControllerAnimated:NO completion:nil];
        //[self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
     */
    [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"isNotification"];
    
    //if user likes a profile and receives a popup,then we need to reload the homescreen
    //[[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"reloadCandidateList"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
