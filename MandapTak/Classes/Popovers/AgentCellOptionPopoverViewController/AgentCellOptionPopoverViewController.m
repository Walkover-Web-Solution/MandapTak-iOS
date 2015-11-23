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


- (IBAction)deactivateButtonAction:(id)sender {
    [self.delegate selectedOption:@"Deactivated" withTag:self.btnTag];
}

- (IBAction)givePermissionButtonAction:(id)sender {
    [self.delegate selectedOption:@"GivePermission" withTag:self.btnTag];
}
@end
