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
- (IBAction)back:(id)sender;

@end

@implementation MatchScreenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //[[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"isNotification"];
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

- (IBAction)back:(id)sender
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"isNotification"] isEqualToString:@"yes"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"isNotification"];
        //UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SWRevealViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}
@end
