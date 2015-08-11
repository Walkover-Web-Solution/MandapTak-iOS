//
//  TutorialContentViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 27/07/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "TutorialContentViewController.h"
#import "Constants.h"
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
    NSArray *arrImages = @[@"Matches_icon.png",@"Fake_icon.png",@"Kundli_icon",@"Spam_icon",@"Weeding_icon"];
    self.imgView.image = [UIImage imageNamed:arrImages[self.pageIndex]];
    NSArray *detailLbl = @[@"Meet your perfect partner right here",@"All profiles are verified by MandapTak team",@"Only matches can send messsage to each other",@"See the number of traits out of 36 matching for each profile you see",@"Ready to meet your dream partner"];
    NSArray * contentLbl = @[@"Perfect Match", @"No Fake Profiles", @"No Spam Messages",@"See Matching Traits",@""];

    self.lbldetail.text = detailLbl[self.pageIndex];
    self.lblTitle.text = contentLbl[self.pageIndex];

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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)loginButtonAction:(id)sender {
    
}
@end
