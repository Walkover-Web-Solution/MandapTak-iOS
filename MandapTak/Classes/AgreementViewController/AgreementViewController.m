//
//  AgreementViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 17/11/15.
//  Copyright © 2015 Walkover. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()
- (IBAction)agreeButtonAction:(id)sender;

@end

@implementation AgreementViewController

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

- (IBAction)agreeButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
