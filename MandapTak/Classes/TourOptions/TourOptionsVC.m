//
//  TourOptionsVC.m
//  MandapTak
//
//  Created by Anuj Jain on 10/30/15.
//  Copyright © 2015 Walkover. All rights reserved.
//

#import "TourOptionsVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UserProfileViewController.h"
#import "SWRevealViewController.h"

@interface TourOptionsVC ()
{
    MPMoviePlayerViewController *moviePlayer;
}

- (IBAction)videoAction:(id)sender;
- (IBAction)coachMarkAction:(id)sender;
- (IBAction)back:(id)sender;

@end

@implementation TourOptionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"coachMarkIdentifier"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WSCoachMarksShown"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFromTour"];
        
        UserProfileViewController *vc = [segue destinationViewController];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
    

}

- (IBAction)videoAction:(id)sender
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MTLowRes" ofType:@"mp4"];
    moviePlayer = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:path]];
    [self presentModalViewController:moviePlayer animated:NO];
    //[self.navigationController presentViewController:moviePlayer animated:YES completion:nil];
}

- (IBAction)coachMarkAction:(id)sender
{
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WSCoachMarksShown"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFromTour"];
    /*
    UserProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
     UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
     [navigationController setNavigationBarHidden:NO];
     [self presentViewController:navigationController animated:YES completion:nil]; // This is for modalviewcontroller
     
     //code 1
    SWRevealViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    */
    
    
    //code 2
    //UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SWRevealViewController *vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    [self presentViewController:vc2 animated:YES completion:nil];
    
    //[self.navigationController initWithRootViewController:vc];
    //[self.navigationController setNavigationBarHidden:NO];
    // [self presentViewController:vc animated:YES completion:nil];
    //[self.navigationController pushViewController:vc animated:YES];
    //[self.navigationController presentViewController:vc animated:YES completion:nil];
    
    //[self performSegueWithIdentifier:@"coachMarkIdentifier" sender:nil];
}

- (IBAction)back:(id)sender
{
   [self dismissViewControllerAnimated:YES completion:nil];
}
@end
