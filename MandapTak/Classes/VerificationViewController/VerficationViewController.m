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


@interface VerficationViewController ()<UITextFieldDelegate>

- (IBAction)loginButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtVerfication;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbldetail;
- (IBAction)verifyButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@end
@implementation VerficationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
    [self.txtVerfication setValue:[UIFont fontWithName: @"MYRIADPRO-BOLD" size: 15] forKeyPath:@"_placeholderLabel.font"];
    [self.txtVerfication setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];

    // Do any additional setup after loading the view.
}


#pragma mark UITextFieldDelegate
- (void) performKeyboardAnimation: (NSInteger) offset  {
    [UIView beginAnimations:@"moveKeyboard" context:nil];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + offset, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.txtVerfication resignFirstResponder];
    return YES;
}
-(void) textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.txtVerfication) {
        [self performKeyboardAnimation:-LOGIN_TEXTFIELD_OFFSET];
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.txtVerfication) {
        [self performKeyboardAnimation:LOGIN_TEXTFIELD_OFFSET];
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
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + keyboardRect.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
  //  [self setNeedsUpdateConstraints];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    // Reset the desired height (keep the duration)
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    [UIView beginAnimations:@"moveKeyboard" context:nil];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - keyboardRect.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];

  //  [self setNeedsUpdateConstraints];
}
- (IBAction)verifyButtonAction:(id)sender {
}
@end
