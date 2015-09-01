//
//  VerficationViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 31/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//
#define LOGIN_TEXTFIELD_OFFSET        (IS_IPHONE_5 ? 160 :100)
#import "Constants.h"
#import "VerficationViewController.h"
#import "MBProgressHUD.h"
#import <Parse/Parse.h>
#import "EditProfileViewController.h"
@interface VerficationViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtVerfication;

- (IBAction)verifyButtonAction:(id)sender;

@end
@implementation VerficationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.txtVerfication.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
    [self.txtVerfication setValue:[UIFont fontWithName: @"MYRIADPRO-BOLD" size: 15] forKeyPath:@"_placeholderLabel.font"];
    [self.txtVerfication setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.txtVerfication.keyboardType = UIKeyboardTypeNumberPad;

    // Do any additional setup after loading the view.
}


#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.txtVerfication resignFirstResponder];
    return YES;
}
-(void) textFieldDidBeginEditing:(UITextField *)textField{
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField.text.length>5){
        const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
        int isBackSpace = strcmp(_char, "\b");
        
        if (isBackSpace == -8) {
            return YES;
        }
        
        return NO;
    }
    if(textField.text.length<=6){
        return YES;
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
   }
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    // Save the height of keyboard and animation duration
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    [UIView beginAnimations:@"moveKeyboard" context:nil];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - keyboardRect.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
  //  [self setNeedsUpdateConstraints];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    // Reset the desired height (keep the duration)
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    [UIView beginAnimations:@"moveKeyboard" context:nil];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + keyboardRect.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];

  //  [self setNeedsUpdateConstraints];
}
- (IBAction)verifyButtonAction:(id)sender {
    if(self.txtVerfication.text.length==6){
        [self.view endEditing:YES];
        MBProgressHUD *HUD;
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [PFCloud callFunctionInBackground:@"verifyNumber"
                           withParameters:@{@"mobile":[[NSUserDefaults standardUserDefaults]valueForKey:@"mobNo"],@"otp":self.txtVerfication.text}
                                    block:^(NSString *results, NSError *error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             if (!error)
             {
                 [self performLoginOnVerifactionWithPassword:results];
             }
             else{
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Opps" message:[[error userInfo] objectForKey:@"error"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alert show];
             }
         }];

    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Enter a number with 6 digits." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];

    }
}

-(void)performLoginOnVerifactionWithPassword:(NSString*)password{
    MBProgressHUD *HUD;
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        [PFUser logInWithUsernameInBackground:[[NSUserDefaults standardUserDefaults]valueForKey:@"mobNo"] password:password
                                        block:^(PFUser *user, NSError *error) {
                                            [MBProgressHUD hideHUDForView:self.view animated:YES];

                                            if(!error){
                                                NSLog(@"Success");
                                                [self checkForUseridInUserProfile];
                                            }
                                                                                       }];
    

}

-(void)checkForUseridInUserProfile{
    PFQuery *query = [PFQuery queryWithClassName:@"userProfile"];
    
    [query whereKey:@"userId" equalTo:[[PFUser currentUser] valueForKey:@"objectId"]];
    [query includeKey:@"Profile"];

    MBProgressHUD * hud;
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (!error) {
          //  [self getUserProfileForUser:objects[0]];
            PFObject *userProfile =objects[0];
            PFObject *currentProfile = [userProfile valueForKey:@"profileId"];
            if([[currentProfile valueForKey:@"isComplete"] boolValue]){
                [self performSegueWithIdentifier:@"Login" sender:self];
            }
            else{
                UIStoryboard *sb2 = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
                EditProfileViewController *vc = [sb2 instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
                
                //vc.globalCompanyId = [self.companies.companyId intValue];
                
                UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vc];
                navController.navigationBarHidden =YES;
                [self presentViewController:navController animated:YES completion:nil];
                
            }

//            for(PFObject *user in objects){
//            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}
-(void)getUserProfileForUser:(PFObject*)user{
    PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
    [query whereKey:@"userId" equalTo:[user valueForKey:@"profileId"]];
    MBProgressHUD * hud;
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (!error) {
            
            PFObject *currentProfile =objects[0];
            if([[currentProfile valueForKey:@"isComplete"] boolValue]){
                [self performSegueWithIdentifier:@"Login" sender:self];
            }
            else{
                UIStoryboard *sb2 = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
                EditProfileViewController *vc = [sb2 instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
                
                //vc.globalCompanyId = [self.companies.companyId intValue];
                
                UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vc];
                navController.navigationBarHidden =YES;
                [self presentViewController:navController animated:YES completion:nil];

            }

            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

@end
