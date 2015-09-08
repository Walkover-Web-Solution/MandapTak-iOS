//
//  CreateNewUserPopoverViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 07/09/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "CreateNewUserPopoverViewController.h"
#import "MBProgressHUD.h"
#import "AppData.h"
#import <Parse/Parse.h>
@interface CreateNewUserPopoverViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtMobNo;
- (IBAction)createNewUserButtonAction:(id)sender;

@end

@implementation CreateNewUserPopoverViewController

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

- (IBAction)createNewUserButtonAction:(id)sender {
    [self.txtMobNo resignFirstResponder];
    if([[AppData sharedData]isInternetAvailable]){
        [self.view endEditing:YES];
        MBProgressHUD *HUD;
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [PFCloud callFunctionInBackground:@"addNewUserForAgent"
                           withParameters:@{@"mobile":self.txtMobNo.text,@"agentId":[[PFUser currentUser] objectId]}
                                    block:^(NSString *results, NSError *error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             if (!error)
             {
                 [self.delegate userMobileNumber:self.txtMobNo.text];;
             }
             else{
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Opps" message:[[error userInfo] objectForKey:@"error"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alert show];
             }
         }];
        
        
    }
    else{
        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"Opps!!" message:@"Please Check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }

}
@end
