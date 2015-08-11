//
//  GenderViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 04/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "GenderViewController.h"

@interface GenderViewController ()
- (IBAction)genderButtonAction:(id)sender;

@end

@implementation GenderViewController

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

- (IBAction)genderButtonAction:(id)sender {
    switch ([sender tag]) {
        case 0:
            [self.delegate selectedGender:@"Male"];
            break;
        case 1:
            [self.delegate selectedGender:@"Female"];
            break;
        default:
            break;
    }
}
@end
