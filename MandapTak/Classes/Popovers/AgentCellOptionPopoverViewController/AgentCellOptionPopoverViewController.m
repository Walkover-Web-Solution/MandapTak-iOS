//
//  AgentCellOptionPopoverViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 07/09/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "AgentCellOptionPopoverViewController.h"
#import "MBProgressHUD.h"
@interface AgentCellOptionPopoverViewController (){
    PFObject *profile;
    PFUser *user;
    __weak IBOutlet UIButton *btnActivateOrDeactivate;
}
- (IBAction)deactivateButtonAction:(id)sender;
- (IBAction)givePermissionButtonAction:(id)sender;

@end

@implementation AgentCellOptionPopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    profile = [self.userProfile valueForKey:@"profileId"];
    user = [profile valueForKey:@"userId"];
    if([[profile valueForKey:@"isActive"] boolValue]){
        [ btnActivateOrDeactivate setTitle:@"Deactivate" forState:UIControlStateNormal];
        [btnActivateOrDeactivate setTitleColor:[UIColor redColor] forState:UIControlStateNormal];    }
    else{
        [ btnActivateOrDeactivate setTitle:@"Activate" forState:UIControlStateNormal];
        [btnActivateOrDeactivate setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    }

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

- (IBAction)deactivateButtonAction:(id)sender {
    [self.delegate selectedOption:@"Deactivated" withTag:self.btnTag];
}

- (IBAction)givePermissionButtonAction:(id)sender {
    [self.delegate selectedOption:@"GivePermission" withTag:self.btnTag];
}
@end
