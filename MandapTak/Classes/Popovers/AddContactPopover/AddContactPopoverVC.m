//
//  AddContactPopoverVC.m
//  MandapTak
//
//  Created by Anuj Jain on 9/5/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "AddContactPopoverVC.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "AppData.h"

@interface AddContactPopoverVC ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    UIPickerView *picView;
    
    UIButton *buttonCancel,*buttonDone;
    NSMutableArray *arrPickerData;
    NSString *strRelation;
    IBOutlet UIButton *btnRelation;
    IBOutlet UITextField *txtNumber;
}
- (IBAction)selectRelationAction:(id)sender;
- (IBAction)saveAction:(id)sender;

@end

@implementation AddContactPopoverVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrPickerData = [NSMutableArray array];
    arrPickerData = [[NSMutableArray alloc] initWithObjects:@"Bachelor",@"Father",@"Mother",@"Sister",@"Brother",@"Guardian",@"Friend", nil];
    // Do any additional setup after loading the view.
    //set toolbar for numberpad
    UIToolbar *numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           nil];
    [numberToolbar sizeToFit];
    txtNumber.inputAccessoryView = numberToolbar;
}

-(void)cancelNumberPad
{
    [txtNumber resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= 10 && range.length == 0)
        return NO;
    return YES;
}

- (IBAction)selectRelationAction:(id)sender
{
    [self showPickerView];
}

#pragma mark Picker View Methods
-(void) showPickerView
{
    picView=[[UIPickerView alloc] initWithFrame:CGRectZero];
    CGRect bounds = [self.view bounds];
    int pickerHeight = picView.frame.size.height;
    picView.frame = CGRectMake(0, bounds.size.height - (pickerHeight), MIN(picView.frame.size.width, 310) , picView.frame.size.height);
    NSLog(@"pic view width -> %f",picView.frame.size.width);
    picView.dataSource = self;
    picView.delegate = self;
    [picView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:picView];
    
    //picker view header
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, picView.frame.size.width, 30)];
    [headerView setBackgroundColor:[UIColor colorWithRed:242/255.0f green:112/255.0f blue:114/255.0f alpha:1]];
    //[headerView setBackgroundColor:[UIColor lightGrayColor ]];
    [picView addSubview:headerView];
    
    buttonCancel=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonCancel.titleLabel.font = [UIFont fontWithName:@"MYRIADPRO-REGULAR" size:16];
    [buttonCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [buttonCancel setFrame:CGRectMake(5, bounds.size.height - (pickerHeight), 100, 26)];
    buttonCancel.tag=0;
    [buttonCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonCancel addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonCancel];
    
    buttonDone=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonDone.titleLabel.font = [UIFont fontWithName:@"MYRIADPRO-REGULAR" size:16];
    [buttonDone setTitle:@"Done" forState:UIControlStateNormal];
    [buttonDone setFrame:CGRectMake(self.view.frame.size.width-2-100, bounds.size.height - (pickerHeight), 100, 26)];
    buttonDone.tag=1;
    [buttonDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonDone addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonDone];
    
    if (strRelation.length > 0)
    {
        [picView selectRow:[arrPickerData indexOfObject:strRelation] inComponent:0 animated:NO];
    }
}

//cancel button event
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

//picker view methods
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
    
}

- (IBAction)saveAction:(id)sender
{
    if (txtNumber.text.length > 0)
    {
        if (txtNumber.text.length < 10)
        {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Mobile Number should be of 10 digits" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [av show];
            return;
        }
        if ([btnRelation.titleLabel.text isEqualToString:@"Select Relation"])
        {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Select Relation" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [av show];
            return;
        }
    }
    else
    {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Enter Mobile Number" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    
    //hit query and close popover
    //check internet connection
    if ([[AppData sharedData] isInternetAvailable])
    {
        MBProgressHUD *HUD;
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [PFCloud callFunctionInBackground:@"givePermissiontoNewUser"
                           withParameters:@{@"profileId":[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"],
                                            @"mobile" : [NSString stringWithFormat:@"%@", txtNumber.text],
                                            @"relation" : [NSString stringWithFormat:@"%@", strRelation]}
                                    block:^(NSArray *results, NSError *error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             if (!error)
             {
                 // this is where you handle the results and change the UI.
                 [self.delegate showSelectedContacts:nil];
             }
             else  if (error.code ==209){
                 UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Logged in from another device, Please login again!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [errorAlertView show];
             }
             else
             {
                 UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [av show];
                 return;
             }
         }];
        
        
    }
    else
    {
        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"Opps!!" message:@"Please Check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}
@end
