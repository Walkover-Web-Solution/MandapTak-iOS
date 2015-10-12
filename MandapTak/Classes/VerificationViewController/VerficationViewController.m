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
#import "AppData.h"
#import "AppDelegate.h"
#import "AgentViewController.h"
#import <Atlas.h>

@interface VerficationViewController ()<UITextFieldDelegate>{
    
    __weak IBOutlet UIActivityIndicatorView *activityIndicator;
}
@property (weak, nonatomic) IBOutlet UIButton *btnVerify;

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
-(void)viewWillAppear:(BOOL)animated{
    [self performSelector:@selector(txtFieldFirstResponder) withObject:nil afterDelay:.1];
}
-(void)txtFieldFirstResponder{
    [self.txtVerfication becomeFirstResponder];
    
}
#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.txtVerfication resignFirstResponder];
    return YES;
}
-(void) textFieldDidBeginEditing:(UITextField *)textField{
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField.text.length>3){
        const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
        int isBackSpace = strcmp(_char, "\b");
        
        if (isBackSpace == -8) {
            return YES;
        }
        
        return NO;
    }
    if(textField.text.length<=4){
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
    float height = keyboardRect.size.height-60;
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    //  [self setNeedsUpdateConstraints];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    // Reset the desired height (keep the duration)
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    [UIView beginAnimations:@"moveKeyboard" context:nil];
    float height = keyboardRect.size.height-60;
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    //  [self setNeedsUpdateConstraints];
}
- (IBAction)verifyButtonAction:(id)sender {
    if([[AppData sharedData]isInternetAvailable]){
        if(self.txtVerfication.text.length==4){
            [self.view endEditing:YES];
//            MBProgressHUD *HUD;
//            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self showLoader];
            NSString *strFunctionName;
            //hard code a user for demo account
            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"mobNo"] isEqualToString:@"9425061919"])
            {
                if(![self.txtVerfication.text isEqualToString:@"1234"])
                {
                    [self hideLoader];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry!!" message:@"Please enter valid verification code." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                    return;
                }
                
                //set test function name
                strFunctionName = @"verifyNumberTest";
                //call login method with default password
                //[self performLoginOnVerifactionWithPassword:@"12345678"];
            }
            else
            {
                strFunctionName = @"verifyNumber";
            }
            [PFCloud callFunctionInBackground:strFunctionName
                               withParameters:@{@"mobile":[[NSUserDefaults standardUserDefaults]valueForKey:@"mobNo"],@"otp":self.txtVerfication.text}
                                        block:^(NSString *results, NSError *error)
             {
                 //[MBProgressHUD hideHUDForView:self.view animated:YES];
                 [self hideLoader];
                 
                 if (!error)
                 {
                     [self performLoginOnVerifactionWithPassword:results];
                 }
                 else{
                     if(error.code==400){
                         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry!!" message:@"Please enter valid verification code." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         [alert show];
                         
                     }
                     else{
                         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Opps" message:[[error userInfo] objectForKey:@"error"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         [alert show];
                     }
                 }
             }];
            
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Enter four digit verification code recieved on mobile." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    }
    else{
        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"Opps!!" message:@"Please Check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
}

-(void)performLoginOnVerifactionWithPassword:(NSString*)password{
//    MBProgressHUD *HUD;
//    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"mobNo"] );
//    NSLog(@"%@",password);
    [self showLoader];
    NSLog(@"username -> %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"mobNo"]);
    [PFUser logInWithUsernameInBackground:[[NSUserDefaults standardUserDefaults]valueForKey:@"mobNo"] password:password
                                    block:^(PFUser *user, NSError *error) {
                                        //[MBProgressHUD hideHUDForView:self.view animated:YES];
                                        [self hideLoader];
                                        if(!error){
                                            NSLog(@"Success");
                                            
                                            PFACL *acl = [PFACL ACL];
                                            [acl setPublicReadAccess:true];
                                            [acl setWriteAccess:true forUser:[PFUser currentUser]];
                                            PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                                            [currentInstallation setObject:[PFUser currentUser] forKey:@"user"];
                                            [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                                                if(succeeded){
                                                    [PFCloud callFunction:@"deleteDuplicateInstallations" withParameters:@{ @"userid" : [[PFUser currentUser] objectId]}];
                                                }
                                            }];
                                            [PFUser currentUser].ACL = acl;
                                            [self checkIfAgentOrUser];
                                            [[AppData sharedData] installLayerClient];
                                        }
                                    }];
}

-(void)checkIfAgentOrUser{
   // [self loginLayer];
//    MBProgressHUD *HUD;
//    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self showLoader];

    PFObject *role = [[PFUser currentUser]valueForKey:@"roleId"];
    [role fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error){
       // [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self hideLoader];
        NSString *roleValue = [object objectForKey:@"name"];
        if([roleValue isEqual:@"Agent"]){
            // switch to admin
            [[NSUserDefaults standardUserDefaults]setObject:@"Agent" forKey:@"roleType"];
            [self checkForAgentInUserProfile];
        }
        else if([roleValue isEqual:@"User"]){
            [[NSUserDefaults standardUserDefaults]setObject:@"User" forKey:@"roleType"];
            [self checkForUseridInUserProfile];
        }
    }];
    
}
-(void)checkForAgentInUserProfile{
    PFQuery *query = [PFQuery queryWithClassName:@"UserProfile"];
    NSLog(@"%@",[[PFUser currentUser] valueForKey:@"objectId"]);
    [query whereKey:@"userId" equalTo:[PFUser currentUser]];
    [query includeKey:@"profileId"];
    [query whereKey:@"relation" equalTo:@"Agent"];
    [query whereKey:@"isPrimary" equalTo:[NSNumber numberWithBool:YES]];
    [self showLoader];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self hideLoader];
        
        if (!error) {
            // Agent Login
            PFObject *currentProfile ;
            PFObject *userProfile ;
            currentProfile = [objects[0] valueForKey:@"profileId"];
            userProfile = objects[0];
            [[NSUserDefaults standardUserDefaults]setObject:[userProfile valueForKey:@"objectId"] forKey:@"userProfileObjectId"];
            [[NSUserDefaults standardUserDefaults]setObject:[currentProfile valueForKey:@"objectId"] forKey:@"currentProfileId"];
            
            UIStoryboard *sb2 = [UIStoryboard storyboardWithName:@"Agent" bundle:nil];
            AgentViewController *vc = [sb2 instantiateViewControllerWithIdentifier:@"AgentViewController"];
            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vc];
            navController.navigationBarHidden =YES;
            [self presentViewController:navController animated:YES completion:nil];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
-(void)writeArrayWithCustomObjToUserDefaults:(NSString *)keyName withArray:(NSMutableArray *)myArray
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:myArray];
    [defaults setObject:data forKey:keyName];
    [defaults synchronize];
}

-(NSArray *)readArrayWithCustomObjFromUserDefaults:(NSString*)keyName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:keyName];
    NSArray *myArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [defaults synchronize];
    return myArray;
}
-(void)checkForUseridInUserProfile{
    PFQuery *query = [PFQuery queryWithClassName:@"UserProfile"];
    NSLog(@"%@",[[PFUser currentUser] valueForKey:@"objectId"]);
    [query whereKey:@"userId" equalTo:[PFUser currentUser]];
    [query includeKey:@"profileId"];
    [self showLoader];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self hideLoader];
        if (!error) {
            PFObject *currentProfile ;
            PFObject *userProfile ;
            
            for(PFObject * object in objects){
                if([[object valueForKey:@"isPrimary"] boolValue]){
                    currentProfile = [object valueForKey:@"profileId"];
                    userProfile = object;
                    break;
                }
            }
            if(currentProfile==nil){
                for(PFObject * object in objects){
                    PFObject *profile =[object valueForKey:@"profileId"];
                    if([[profile valueForKey:@"isActive"] boolValue]){
                        currentProfile = [object valueForKey:@"profileId"];
                        userProfile = object;
                        break;
                    }
                }
            }
            if(currentProfile != nil){
                [[NSUserDefaults standardUserDefaults]setObject:[userProfile valueForKey:@"objectId"] forKey:@"userProfileObjectId"];
                //  NSArray * arrProfile = [NSArray arrayWithObjects:currentProfile, nil];
                [[NSUserDefaults standardUserDefaults]setObject:[currentProfile valueForKey:@"objectId"] forKey:@"currentProfileId"];
                if([[currentProfile valueForKey:@"isComplete"] boolValue]){
                    [[NSUserDefaults standardUserDefaults]setObject:@"completed" forKey:@"isProfileComplete"];
                    [self performSegueWithIdentifier:@"Login" sender:self];
                }
                else{
                    [[NSUserDefaults standardUserDefaults]setObject:@"notCompleted" forKey:@"isProfileComplete"];
                    
                    UIStoryboard *sb2 = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
                    EditProfileViewController *vc = [sb2 instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
                    vc.isMakingNewProfile =YES;
                    //vc.globalCompanyId = [self.companies.companyId intValue];
                    
                    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vc];
                    navController.navigationBarHidden =YES;
                    [self presentViewController:navController animated:YES completion:nil];
                }
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"No activated profile available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}
#pragma mark ShowActiviatyIndicator

-(void)showLoader{
    //activityIndicator.hidden = NO;
    [activityIndicator startAnimating];
    self.btnVerify.enabled = NO;
    self.txtVerfication.enabled = NO;
}

-(void)hideLoader{
    //activityIndicator.hidden = YES;
    [activityIndicator stopAnimating];
    self.btnVerify.enabled = YES;
    self.txtVerfication.enabled = YES;
}

@end
