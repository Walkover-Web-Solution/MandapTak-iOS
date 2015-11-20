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
#define kSTEPFRACTION 20

@interface CreateNewUserPopoverViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>{
    UIPickerView *picView;
    UIButton *buttonCancel,*buttonDone;
    NSString *strRelation;
    IBOutlet UIButton *btnRelation;
    NSArray *arrPickerData;
    __weak IBOutlet UISlider *creditSlider;
    __weak IBOutlet UILabel *lblCredit;
    float creditToTransfer;

}
- (IBAction)selectRelationAction:(id)sender;
- (IBAction)sliderAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtMobNo;
- (IBAction)createNewUserButtonAction:(id)sender;

@end

@implementation CreateNewUserPopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrPickerData = [[NSMutableArray alloc] initWithObjects:@"Bachelor",@"Father",@"Mother",@"Sister",@"Brother",@"Guardian",@"Friend", nil];
    // Do any additional setup after loading the view.
    btnRelation.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnRelation.layer.borderWidth = .4f;
    btnRelation.layer.cornerRadius = 4.0f;
    
    UIToolbar *numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    [numberToolbar sizeToFit];
    self.txtMobNo.inputAccessoryView = numberToolbar;
    self.txtMobNo.delegate  = self;
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
    if(self.agentBal>=creditToTransfer){
        if(strRelation.length !=0 && self.txtMobNo.text.length>9){
            [self.txtMobNo resignFirstResponder];
            if([[AppData sharedData]isInternetAvailable]){
                [self.view endEditing:YES];
                MBProgressHUD *HUD;
                HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                [PFCloud callFunctionInBackground:@"addNewUserForAgent"
                                   withParameters:@{@"mobile":self.txtMobNo.text,@"agentId":[[PFUser currentUser] objectId],@"relation":strRelation}
                                            block:^(NSString *results, NSError *error)
                 {
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                     if (!error)
                     {
                         [self fetchUserId];
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
        else{
            UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"Sorry!!" message:@"Please enter valid Mobile No. and relation." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }

    }
    else{
        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"Sorry!!" message:@"Please enter a less amount." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
   }
-(void)fetchUserId{
    MBProgressHUD *HUD;
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    

    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:self.txtMobNo.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (!error) {
            PFUser *obj = objects[0];
            [self addCreditsWithUserId:obj.objectId andAgentId:[PFUser currentUser].objectId];
        }
    }];
}
-(void)addCreditsWithUserId:(NSString*)userId andAgentId:(NSString*)agentId{
    MBProgressHUD *HUD;
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    NSString *amount = [NSString stringWithFormat:@"%f",creditToTransfer-10];
    [PFCloud callFunctionInBackground:@"fundTransfer"
                       withParameters:@{@"amount":amount,
                                        @"userid" : userId,
                                        @"agentid" : agentId}
                                block:^(NSArray *results, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         if (!error)
         {
             [self.delegate userMobileNumber:self.txtMobNo.text];;
         }
         else
         {
             UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [av show];
             return;
         }
     }];

}
#pragma mark Picker View Methods
-(void) showPickerView
{
    picView=[[UIPickerView alloc] initWithFrame:CGRectZero];
    CGRect bounds = [self.view bounds];
    int pickerHeight = 150;
    picView.frame = CGRectMake(0, bounds.size.height - (pickerHeight), MIN(picView.frame.size.width, 300) , picView.frame.size.height);
    btnRelation.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnRelation.layer.borderWidth = .5f;
    btnRelation.layer.cornerRadius = 4.0f;
    picView.dataSource = self;
    picView.delegate = self;
    [picView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:picView];
    
    //picker view header
//    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, picView.frame.size.width, 30)];
//    [headerView setBackgroundColor:[UIColor colorWithRed:242/255.0f green:112/255.0f blue:114/255.0f alpha:1]];
//    //[headerView setBackgroundColor:[UIColor lightGrayColor ]];
//    [picView addSubview:headerView];
//    
//    buttonCancel=[UIButton buttonWithType:UIButtonTypeCustom];
//    buttonCancel.titleLabel.font = [UIFont fontWithName:@"MYRIADPRO-REGULAR" size:16];
//    [buttonCancel setTitle:@"Cancel" forState:UIControlStateNormal];
//    [buttonCancel setFrame:CGRectMake(5, bounds.size.height - (pickerHeight), 100, 26)];
//    buttonCancel.tag=0;
//    [buttonCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [buttonCancel addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:buttonCancel];
//    
//    buttonDone=[UIButton buttonWithType:UIButtonTypeCustom];
//    buttonDone.titleLabel.font = [UIFont fontWithName:@"MYRIADPRO-REGULAR" size:16];
//    [buttonDone setTitle:@"Done" forState:UIControlStateNormal];
//    [buttonDone setFrame:CGRectMake(self.view.frame.size.width-2-100, bounds.size.height - (pickerHeight), 100, 26)];
//    buttonDone.tag=1;
//    [buttonDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [buttonDone addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:buttonDone];
    
    if (strRelation.length > 0)
    {
        [picView selectRow:[arrPickerData indexOfObject:strRelation] inComponent:0 animated:NO];
    }
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
    //return @"status";
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
    
    // Fill the label text here
    tView.text=[arrPickerData objectAtIndex:row];
    return tView;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    int rowInt = (int)row;
    strRelation = arrPickerData[rowInt];
    [btnRelation setTitle:strRelation forState:UIControlStateNormal];
    [btnRelation setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
    picView.hidden = YES;
    [self cancelAction:pickerView];
}


- (IBAction)selectRelationAction:(id)sender{

    [self showPickerView];
}

- (IBAction)sliderAction:(id)sender {
//    CGFloat value = creditSlider.value * kSTEPFRACTION;
//    int roundValue;
//    roundValue = roundf(value);
//
//    NSString *strValue =[NSString stringWithFormat:@"%f",value];
//    lblCredit.text = [NSString stringWithFormat:@"%d",[strValue intValue]];
//    [creditSlider setValue:[strValue intValue] animated:NO];
    int value = (int)[creditSlider value];
    int stepSize = 20;
    value = (value - value % stepSize);
    creditSlider.value = value;
    // Set the new value.
    if(value==0){
        value = 10;
    }
    creditToTransfer = value;
    lblCredit.text =[NSString stringWithFormat:@"%d Credits",value];
   
}
-(void) cancelAction : (UIPickerView *)pc
{
    [pc removeFromSuperview];
    picView.hidden = YES;
    buttonCancel.hidden = buttonDone.hidden = YES;
    //[btnSchedule setImage:[UIImage imageNamed:@"sch_off.png"] forState:UIControlStateNormal];
    //lblSchedule.text = @"Schedule";
    //[btnSchedule setTitle:@"Schedule" forState:UIControlStateNormal];
}

//done button event
-(void) doneAction : (UIPickerView *)pc
{
    //NSLog(@"selected atm = %@",selAccName);
    [pc removeFromSuperview];
    picView.hidden = YES;
    buttonCancel.hidden = buttonDone.hidden = YES;
    
    //set button title
    [btnRelation setTitle:strRelation forState:UIControlStateNormal];
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
