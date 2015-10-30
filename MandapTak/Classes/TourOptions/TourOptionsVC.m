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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    //[[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"WSCoachMarksShown"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WSCoachMarksShown"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFromTour"];
    self.navigationController.navigationBarHidden = NO;
    UserProfileViewController *vc = [segue destinationViewController];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)videoAction:(id)sender
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MTLowRes" ofType:@"mp4"];//MTLowRes
    moviePlayer = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:path]];
    [self presentModalViewController:moviePlayer animated:NO];
}

- (IBAction)coachMarkAction:(id)sender
{
    
}

- (IBAction)back:(id)sender
{
   [self dismissViewControllerAnimated:YES completion:nil];
}
@end
