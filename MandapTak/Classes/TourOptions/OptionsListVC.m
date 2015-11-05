//
//  OptionsListVC.m
//  MandapTak
//
//  Created by Anuj Jain on 11/3/15.
//  Copyright © 2015 Walkover. All rights reserved.
//

#import "OptionsListVC.h"
#import <MediaPlayer/MediaPlayer.h>

@interface OptionsListVC ()
- (IBAction)playAction:(id)sender;
- (IBAction)back:(id)sender;

@end

@implementation OptionsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (IBAction)playAction:(id)sender
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MTLowRes" ofType:@"mp4"];
    MPMoviePlayerViewController *moviePlayer = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:path]];
    [self presentModalViewController:moviePlayer animated:NO];
}

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
