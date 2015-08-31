 //
//  TutorialContentViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 27/07/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "TutorialContentViewController.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import <Parse/Parse.h>
#import "VerficationViewController.h"
#define LOGIN_TEXTFIELD_OFFSET        (IS_IPHONE_5 ? 160 :100)

@interface TutorialContentViewController ()<UITextFieldDelegate>

- (IBAction)loginButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtMobNumber;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbldetail;

@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@end

@implementation TutorialContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageControl.currentPage = self.pageIndex;
    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
   // NSArray *arrImages = @[@"Matches_icon.png",@"Fake_icon.png",@"Kundli_icon",@"Spam_icon",@"Weeding_icon"];
    NSArray *arrImages = @[@"Matches_icon.png",@"Fake_icon.png",@"Spam_icon",@"Weeding_icon"];

    self.imgView.image = [UIImage imageNamed:arrImages[self.pageIndex]];
//    NSArray *detailLbl = @[@"Meet your perfect partner right here",@"All profiles are verified by MandapTak team",@"Only matches can send messsage to each other",@"See the number of traits out of 36 matching for each profile you see",@"Ready to meet your dream partner"];
    NSArray *detailLbl = @[@"Meet your perfect partner right here",@"All profiles are verified by MandapTak team",@"Only matches can send messsage to each other",@"Ready to meet your dream partner"];

   // NSArray * contentLbl = @[@"Perfect Match", @"No Fake Profiles", @"No Spam Messages",@"See Matching Traits",@""];
    NSArray * contentLbl = @[@"Perfect Match", @"No Fake Profiles", @"No Spam Messages",@""];

    self.lbldetail.text = detailLbl[self.pageIndex];
    self.lblTitle.text = contentLbl[self.pageIndex];

    [self.txtMobNumber setValue:[UIFont fontWithName: @"MYRIADPRO-BOLD" size: 15] forKeyPath:@"_placeholderLabel.font"];
    [self.txtMobNumber setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];

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

#pragma mark UITextFieldDelegate
- (void) performKeyboardAnimation: (NSInteger) offset  {
    [UIView beginAnimations:@"moveKeyboard" context:nil];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + offset, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.txtMobNumber resignFirstResponder];
    return YES;
}
-(void) textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.txtMobNumber) {
        [self performKeyboardAnimation:-LOGIN_TEXTFIELD_OFFSET];
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.txtMobNumber) {
        [self performKeyboardAnimation:LOGIN_TEXTFIELD_OFFSET];
    }
}
 */

#pragma mark UITextFieldDelegate
- (void) performKeyboardAnimation: (NSInteger) offset  {
    [UIView beginAnimations:@"moveKeyboard" context:nil];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + offset, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.txtMobNumber resignFirstResponder];
    return YES;
}
-(void) textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.txtMobNumber) {
        //[self performKeyboardAnimation:-LOGIN_TEXTFIELD_OFFSET];
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.txtMobNumber) {
       // [self performKeyboardAnimation:LOGIN_TEXTFIELD_OFFSET];
    }
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


- (IBAction)loginButtonAction:(id)sender {
    if(self.txtMobNumber.text.length !=10){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Enter a number with 10 digits." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        MBProgressHUD *HUD;
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [PFCloud callFunctionInBackground:@"sendOtp"
                           withParameters:@{@"mobile":self.txtMobNumber.text}
                                    block:^(NSString *results, NSError *error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             if (!error)
             {
                 UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                 VerficationViewController *vc = [sb instantiateViewControllerWithIdentifier:@"VerficationViewController"];
                 [self presentViewController:vc animated:YES completion:nil];
             }
             else{
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Opps" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alert show];
             }
         }];

    }
   
}

@end
