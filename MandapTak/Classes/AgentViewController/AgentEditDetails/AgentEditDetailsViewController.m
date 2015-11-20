//
//  AgentEditDetailsViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 16/11/15.
//  Copyright © 2015 Walkover. All rights reserved.
//

#import "AgentEditDetailsViewController.h"
#import "MBProgressHUD.h"
@interface AgentEditDetailsViewController ()<UITextFieldDelegate>{
    NSArray *arrPickerData;
    NSString *strRelation;
    __weak IBOutlet UILabel *lblUserInfo;
    NSMutableArray * arrMobNumber;
    
}
- (IBAction)backButtonAction:(id)sender;
- (IBAction)doneButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextField *txtMobileNumber;
- (IBAction)selectRelationButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UIButton *btnRelation;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation AgentEditDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.containBachelor)
        arrPickerData = [[NSMutableArray alloc] initWithObjects:@"Father",@"Mother",@"Sister",@"Brother",@"Guardian",@"Friend", nil];
    else
        arrPickerData = [[NSMutableArray alloc] initWithObjects:@"Bachelor",@"Father",@"Mother",@"Sister",@"Brother",@"Guardian",@"Friend", nil];

    self.pickerView.hidden = YES;
    self.pickerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.pickerView.layer.borderWidth = .3f;
    self.pickerView.layer.cornerRadius = 8.0f;
    arrMobNumber = [NSMutableArray array];
    _btnRelation.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnRelation.layer.borderWidth = .4f;
    _btnRelation.layer.cornerRadius = 4.0f;
    PFUser *user = [self.userProfile valueForKey:@"userId"];
    NSString *relation =[self.userProfile valueForKey:@"relation"];
    // show mobile number if editing details.
    if(![self.optionType isEqual:@"GivePermission"]){
        self.txtMobileNumber.text = user.username;
        [self.btnRelation setTitle: relation forState:UIControlStateNormal];
        strRelation  = relation;
        if([strRelation isEqual:@"Bachelor"])
            arrPickerData = [[NSMutableArray alloc] initWithObjects:@"Bachelor",@"Father",@"Mother",@"Sister",@"Brother",@"Guardian",@"Friend", nil];
        lblUserInfo.text = @"Edit mobile number and relation of user.";
        [_btnRelation setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
    }
    else{
        self.navBar.topItem.title = @"Give Permission";
      
        lblUserInfo.text = @"Enter the mobile number and relation of person to give permission.";
    }
    [self.pickerView reloadAllComponents];

    [self fetchAllAlreadyExistingMobileNumber];;
    self.txtMobileNumber.delegate = self;
}



-(void)fetchAllAlreadyExistingMobileNumber{
    PFObject *profile = [self.userProfile valueForKey:@"profileId"];
    [self showLoader];
    PFQuery *query = [PFQuery queryWithClassName:@"UserProfile"];
    [query includeKey:@"profileId"];
    [query includeKey:@"userId"];
    [query includeKey:@"profileId.userId"];
    [query whereKey:@"profileId" equalTo:profile];
    //[query whereKey:@"relation" notEqualTo:@"Bachelor"];
    //[query whereKey:@"relation" notEqualTo:@"Agent"];
    [query whereKey:@"relation" notContainedIn:@[ @"Agent"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self hideLoader];
        
        if (!error) {
            for(PFObject *object in objects){
                PFUser * user  = [object valueForKey:@"userId"];
                [arrMobNumber addObject:user.username];
                if([[object valueForKey:@"relation"] isEqual:@"Bachelor"]){
                    
                    arrPickerData = [[NSMutableArray alloc] initWithObjects:@"Father",@"Mother",@"Sister",@"Brother",@"Guardian",@"Friend", nil];
                    [self.pickerView reloadAllComponents];
                }
                NSString *relation =[self.userProfile valueForKey:@"relation"];
                if([relation isEqual:@"Bachelor"])
                    arrPickerData = [[NSMutableArray alloc] initWithObjects:@"Bachelor",@"Father",@"Mother",@"Sister",@"Brother",@"Guardian",@"Friend", nil];
                }
        }
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ShowActivityIndicator
-(void)showLoader{
    [self.activityIndicator startAnimating];
    self.btnRelation.userInteractionEnabled = NO;
    self.txtMobileNumber.userInteractionEnabled = NO;
}

-(void)hideLoader{
    [self.activityIndicator stopAnimating];
    self.txtMobileNumber.userInteractionEnabled = YES;
    self.btnRelation.userInteractionEnabled = YES;
}

- (IBAction)backButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonAction:(id)sender {
    NSString *mobNo = self.txtMobileNumber.text;
    
    if(self.txtMobileNumber.text.length>=10 && strRelation.length>2  ){
        if([self.optionType isEqual:@"EditDetails"]){
            [self showLoader];

            PFObject *profile = [self.userProfile valueForKey:@"profileId"];
            [PFCloud callFunctionInBackground:@"changeUserNameAndUserRelation"
                               withParameters:@{@"userId":[[self.userProfile valueForKey:@"userId"] valueForKey:@"objectId"],
                                                @"profileId" : [profile valueForKey:@"objectId"],
                                                @"relation" : strRelation,
                                                @"username": self.txtMobileNumber.text}
                                        block:^(NSArray *results, NSError *error)
             {
                 [self dismissViewControllerAnimated:YES completion:nil];

                 [self hideLoader];
                 if (!error)
                 {
                     UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Success!!" message:@"Edited sucessfully." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [av show];
                     [self dismissViewControllerAnimated:YES completion:nil];
                 }
                 else
                 {
                     UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [av show];
                     return;
                 }
             }];
            
        }
        else{
            [self showLoader];
            if(![arrMobNumber containsObject:mobNo]){
                PFObject *profile = [self.userProfile valueForKey:@"profileId"];
                [PFCloud callFunctionInBackground:@"givePermissiontoNewUser"
                                   withParameters:@{@"mobile":self.txtMobileNumber.text,
                                                    @"profileId" : [profile valueForKey:@"objectId"],
                                                    @"relation" : strRelation}
                                            block:^(NSArray *results, NSError *error)
                 {
                     [self hideLoader];
                     [self dismissViewControllerAnimated:YES completion:nil];
                     
                     if (!error)
                     {
                         UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Success!!" message:@"Permission given sucessfully." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         [av show];
                         [self dismissViewControllerAnimated:YES completion:nil];
                     }
                     else
                     {
                         UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         [av show];
                         return;
                     }
                 }];

            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid input" message:@"Can not give permission to same number." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];

            }
                    }
    }
    else{
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid input" message:@"Please enter a valid mobile number and relation." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
          [alert show];
    }
}
- (IBAction)selectRelationButtonAction:(id)sender {
    self.pickerView.hidden = NO;
}

#pragma mark UIPickerViewDelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return arrPickerData.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return arrPickerData[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont fontWithName:@"MYRIADPRO-REGULAR" size:16]];
        [tView setTextAlignment:NSTextAlignmentCenter];
    }
    
    tView.text=[arrPickerData objectAtIndex:row];
    return tView;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    int rowInt = (int)row;
    strRelation = arrPickerData[rowInt];
    [_btnRelation setTitle:strRelation forState:UIControlStateNormal];
    [_btnRelation setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
    self.pickerView.hidden = YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField.text.length>9){
        const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
        int isBackSpace = strcmp(_char, "\b");
        
        if (isBackSpace == -8) {
            return YES;
        }
        
        return NO;
    }
    if(textField.text.length<=10){
        return YES;
    }
    return YES;
}


@end
