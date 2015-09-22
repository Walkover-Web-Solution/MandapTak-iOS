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
@interface VerficationViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtVerfication;

- (IBAction)verifyButtonAction:(id)sender;

@end
@implementation VerficationViewController
static NSString *const LayerAppIDString = @"layer:///apps/staging/3ffe495e-45e8-11e5-9685-919001005125";

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *appID = [NSURL URLWithString:LayerAppIDString];
    //self.layerClient = [LYRClient clientWithAppID:appID];
    //self.layerClient.autodownloadMIMETypes = [NSSet setWithObjects:ATLMIMETypeImagePNG, ATLMIMETypeImageJPEG, ATLMIMETypeImageJPEGPreview, ATLMIMETypeImageGIF, ATLMIMETypeImageGIFPreview, ATLMIMETypeLocation, nil];
    

    self.txtVerfication.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
    [self.txtVerfication setValue:[UIFont fontWithName: @"MYRIADPRO-BOLD" size: 15] forKeyPath:@"_placeholderLabel.font"];
    [self.txtVerfication setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.txtVerfication.keyboardType = UIKeyboardTypeNumberPad;
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [self performSelector:@selector(txtFieldFirstResponder) withObject:nil afterDelay:.2];
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
    MBProgressHUD *HUD;
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"mobNo"] );
    NSLog(@"%@",password);
        [PFUser logInWithUsernameInBackground:[[NSUserDefaults standardUserDefaults]valueForKey:@"mobNo"] password:password
                                        block:^(PFUser *user, NSError *error) {
                                            [MBProgressHUD hideHUDForView:self.view animated:YES];

                                            if(!error){
                                                NSLog(@"Success");
                                                PFACL *acl = [PFACL ACL];
                                                [acl setPublicReadAccess:true];
                                                [acl setWriteAccess:true forUser:[PFUser currentUser]];
                                                PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                                                [currentInstallation setObject:[PFUser currentUser] forKey:@"user"];
                                                [currentInstallation saveInBackground];
                                                [PFUser currentUser].ACL = acl;
                                                [self checkIfAgentOrUser];
                                            }
                                            }];
    

}

-(void)checkIfAgentOrUser{
    [self loginLayer];
    MBProgressHUD *HUD;
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFObject *role = [[PFUser currentUser]valueForKey:@"roleId"];
    [role fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    [query whereKey:@"isPrimary" equalTo:@YES];
    [query whereKey:@"relation" notEqualTo:@"Agent"];
    
    MBProgressHUD * hud;
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (!error) {
            // Agent Login
            PFObject *currentProfile ;
            PFObject *userProfile ;
            currentProfile = [objects[0] valueForKey:@"profileId"];
            userProfile = objects[0];
            [[NSUserDefaults standardUserDefaults]setObject:[userProfile valueForKey:@"objectId"] forKey:@"userProfileObjectId"];
            //  NSArray * arrProfile = [NSArray arrayWithObjects:currentProfile, nil];
            [[NSUserDefaults standardUserDefaults]setObject:[currentProfile valueForKey:@"objectId"] forKey:@"currentProfileId"];

            UIStoryboard *sb2 = [UIStoryboard storyboardWithName:@"Agent" bundle:nil];
            AgentViewController *vc = [sb2 instantiateViewControllerWithIdentifier:@"AgentViewController"];
            //vc.globalCompanyId = [self.companies.companyId intValue];
            
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

    MBProgressHUD * hud;
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (!error) {
          //  [self getUserProfileForUser:objects[0]];
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
#pragma mark - Layer Authentication Methods

- (void)loginLayer
{
    
    // Connect to Layer
    // See "Quick Start - Connect" for more details
    // https://developer.layer.com/docs/quick-start/ios#connect
    [self.layerClient connectWithCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"Failed to connect to Layer: %@", error);
        } else {
            PFUser *user = [PFUser currentUser];
            NSString *userID = user.objectId;
            [self authenticateLayerWithUserID:userID completion:^(BOOL success, NSError *error) {
                if (!error){
                    [self presentConversationListViewController];
                } else {
                    NSLog(@"Failed Authenticating Layer Client with error:%@", error);
                }
            }];
        }
    }];
}

- (void)authenticateLayerWithUserID:(NSString *)userID completion:(void (^)(BOOL success, NSError * error))completion
{
    // Check to see if the layerClient is already authenticated.
    if (self.layerClient.authenticatedUserID) {
        // If the layerClient is authenticated with the requested userID, complete the authentication process.
        if ([self.layerClient.authenticatedUserID isEqualToString:userID]){
            NSLog(@"Layer Authenticated as User %@", self.layerClient.authenticatedUserID);
            if (completion) completion(YES, nil);
            return;
        } else {
            //If the authenticated userID is different, then deauthenticate the current client and re-authenticate with the new userID.
            [self.layerClient deauthenticateWithCompletion:^(BOOL success, NSError *error) {
                if (!error){
                    [self authenticationTokenWithUserId:userID completion:^(BOOL success, NSError *error) {
                        if (completion){
                            completion(success, error);
                        }
                    }];
                } else {
                    if (completion){
                        completion(NO, error);
                    }
                }
            }];
        }
    } else {
        // If the layerClient isn't already authenticated, then authenticate.
        [self authenticationTokenWithUserId:userID completion:^(BOOL success, NSError *error) {
            if (completion){
                completion(success, error);
            }
        }];
    }
}

- (void)authenticationTokenWithUserId:(NSString *)userID completion:(void (^)(BOOL success, NSError* error))completion
{
    /*
     * 1. Request an authentication Nonce from Layer
     */
    [self.layerClient requestAuthenticationNonceWithCompletion:^(NSString *nonce, NSError *error) {
        if (!nonce) {
            if (completion) {
                completion(NO, error);
            }
            return;
        }
        
        /*
         * 2. Acquire identity Token from Layer Identity Service
         */
        NSDictionary *parameters = @{@"nonce" : nonce, @"userID" : userID};
        
        [PFCloud callFunctionInBackground:@"generateToken" withParameters:parameters block:^(id object, NSError *error) {
            if (!error){
                
                NSString *identityToken = (NSString*)object;
                [self.layerClient authenticateWithIdentityToken:identityToken completion:^(NSString *authenticatedUserID, NSError *error) {
                    if (authenticatedUserID) {
                        if (completion) {
                            completion(YES, nil);
                        }
                        NSLog(@"Layer Authenticated as User: %@", authenticatedUserID);
                    } else {
                        completion(NO, error);
                    }
                }];
            } else {
                NSLog(@"Parse Cloud function failed to be called to generate token with error: %@", error);
            }
        }];
        
    }];
}
- (void)presentConversationListViewController
{
    LYRQuery *query = [LYRQuery queryWithQueryableClass:[LYRMessage class]];
    
    NSError *error;
    NSOrderedSet *messages = [self.layerClient executeQuery:query error:&error];
    if (messages) {
        NSLog(@"%tu messages", messages.count);
    } else {
        NSLog(@"Query failed with error %@", error);
    }
    
    LYRQuery *query2 = [LYRQuery queryWithQueryableClass:[LYRConversation class]];
    
    NSError *error2 = nil;
    NSOrderedSet *conversations = [self.layerClient executeQuery:query2 error:&error2];
    if (conversations) {
        NSLog(@"%tu conversations", conversations.count);
    } else {
        NSLog(@"Query failed with error %@", error);
    }
}


@end
