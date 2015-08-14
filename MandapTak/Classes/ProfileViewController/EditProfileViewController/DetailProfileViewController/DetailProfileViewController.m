//
//  DetailProfileViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 10/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "DetailProfileViewController.h"
#import "TextFieldTableViewCell.h"
#import "WYStoryboardPopoverSegue.h"
#import "HeightPopoverViewController.h"
#import "ReligionPopoverViewController.h"
#import "Religion.h"
#import "CastePopoverViewController.h"
#import "GotraPopoverViewController.h"
@interface DetailProfileViewController ()<HeightPopoverViewControllerDelegate,WYPopoverControllerDelegate,ReligionPopoverViewControllerDelegate,CastePopoverViewControllerDelegate,GotraPopoverViewControllerDelegate>{
    WYPopoverController* popoverController;

    __weak IBOutlet UIButton *btnGotra;
    __weak IBOutlet UIButton *btnCaste;
    __weak IBOutlet UIButton *btnReligion;
    __weak IBOutlet UIButton *btnHeight;
    __weak IBOutlet UITextField *txtWeight;
    BOOL isReligionSelected;
    BOOL isCasteSelected;
    NSString *selectedHeight;
    NSString *selectedHeightInCms;

    PFObject *selectedReligion;
    PFObject *selectedCaste;
    PFObject *selectedGotra;
    NSString *selectedWeight;
    NSString *religionSelectionType;
}
- (IBAction)religionButtonAction:(id)sender;
- (IBAction)gotraButtonAction:(id)sender;
- (IBAction)casteButtonAction:(id)sender;

@end

@implementation DetailProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.currentProfile ==nil){
        NSString *userId = @"m2vi20vsi4";
        PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
        
        [query whereKey:@"userId" equalTo:userId];
        [query includeKey:@"currentLocation.Parent.Parent"];
        [query includeKey:@"placeOfBirth.Parent.Parent"];
        [query includeKey:@"casteId.Parent.Parent"];
        [query includeKey:@"religionId.Parent.Parent"];
        [query includeKey:@"gotraId.Parent.Parent"];

        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                PFObject *obj = objects[0];
                self.currentProfile = obj;
                [self updateUserInfo];
            }
        }];
        
    }
    else{
        [self updateUserInfo];
        
    }

    // Do any additional setup after loading the view.
}
-(void)updateUserInfo{
    if([self.currentProfile valueForKey:@"height"]){
        selectedHeightInCms =[NSString stringWithFormat:@"%@",[self.currentProfile valueForKey:@"height"]];
        NSArray *arrHeight = [NSArray arrayWithObjects:@"4ft 5in - 134cm",@"4ft 6in - 137cm",@"4ft 7in - 139cm",@"4ft 8in - 142cm",@"4ft 9in - 144cm",@"4ft 10in - 147cm",@"4ft 11in - 149cm",@"5ft - 152cm",@"5ft 1in - 154cm",@"5ft 2in - 157cm",@"5ft 3in - 160cm",@"5ft 4in - 162cm",@"5ft 5in - 165cm",@"5ft 6in - 167cm",@"5ft 7in - 170cm",@"5ft 8in - 172cm",@"5ft 9in - 175cm",@"5ft 10in - 177cm",@"5ft 11in - 180cm",@"6ft - 182cm",@"6ft 1in - 185cm",@"6ft 2in - 187cm",@"6ft 3in - 190cm",@"6ft 4in - 193cm",@"6ft 5in - 195cm",@"6ft 6in - 198cm",@"6ft 7in - 200cm",@"6ft 8in - 203cm",@"6ft 9in - 205cm",@"6ft 10in - 208cm",@"6ft 11in - 210cm",@"7ft - 213cm", nil];
        for(NSString *height in arrHeight){
            if([height containsString:selectedHeightInCms]){
                selectedHeight = height;
                break;
            }
        }
        [btnHeight setTitle:selectedHeight forState:UIControlStateNormal];
        [btnHeight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [popoverController dismissPopoverAnimated:YES];

    }
    if([self.currentProfile valueForKey:@"weight"]){
        txtWeight.text = [NSString stringWithFormat:@"%@",[self.currentProfile valueForKey:@"weight"] ] ;
    }
    if(![[self.currentProfile valueForKey:@"casteId"] isKindOfClass: [NSNull class]]){
        PFObject *obj  = [self.currentProfile valueForKey:@"casteId"];
        selectedCaste = obj;
        [btnCaste setTitle:[obj valueForKey:@"name"] forState:UIControlStateNormal];
        [btnCaste setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    }
    if(![[self.currentProfile valueForKey:@"gotraId"] isKindOfClass: [NSNull class]]){
        PFObject *obj  = [self.currentProfile valueForKey:@"gotraId"];
        selectedCaste = obj;
        [btnGotra setTitle:[obj valueForKey:@"name"] forState:UIControlStateNormal];
        [btnGotra setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];    }
    if(![[self.currentProfile valueForKey:@"religionId"] isKindOfClass: [NSNull class]]){
        PFObject *obj  = [self.currentProfile valueForKey:@"religionId"];
        selectedCaste = obj;
        [btnReligion setTitle:[obj valueForKey:@"name"] forState:UIControlStateNormal];
        [btnReligion setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    [txtWeight resignFirstResponder];
    [self.view endEditing:YES];
    if ([segue.identifier isEqualToString:@"HeightIdentifier"])
    {
        HeightPopoverViewController *controller = segue.destinationViewController;
        controller.preferredContentSize = CGSizeMake(300, 190);
        WYStoryboardPopoverSegue* popoverSegue = (WYStoryboardPopoverSegue*)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender
                                             permittedArrowDirections:WYPopoverArrowDirectionAny
                                                             animated:YES];
        popoverController.popoverLayoutMargins = UIEdgeInsetsMake(4, 4, 4, 4);
        popoverController.delegate = self;
        controller.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"ReligionIdentifier"])
    {
        ReligionPopoverViewController *controller = segue.destinationViewController;
        controller.preferredContentSize = CGSizeMake(300, 400);
        WYStoryboardPopoverSegue* popoverSegue = (WYStoryboardPopoverSegue*)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender
                                             permittedArrowDirections:WYPopoverArrowDirectionAny
                                                             animated:YES];
        popoverController.popoverLayoutMargins = UIEdgeInsetsMake(4, 4, 4, 4);
        popoverController.delegate = self;
        controller.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"CasteIdentifier"])
    {
        CastePopoverViewController *controller = segue.destinationViewController;
        controller.arrTableData = [selectedReligion valueForKey:@"Parent"];
        controller.religionObj = selectedReligion;
        controller.preferredContentSize = CGSizeMake(300, 400);
        WYStoryboardPopoverSegue* popoverSegue = (WYStoryboardPopoverSegue*)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender
                                             permittedArrowDirections:WYPopoverArrowDirectionAny
                                                             animated:YES];
        popoverController.popoverLayoutMargins = UIEdgeInsetsMake(4, 4, 4, 4);
        popoverController.delegate = self;
        controller.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"GotraIdentifier"])
    {
        GotraPopoverViewController *controller = segue.destinationViewController;
        controller.casteObj = selectedCaste;
        controller.preferredContentSize = CGSizeMake(300, 400);
        WYStoryboardPopoverSegue* popoverSegue = (WYStoryboardPopoverSegue*)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender
                                             permittedArrowDirections:WYPopoverArrowDirectionAny
                                                             animated:YES];
        popoverController.popoverLayoutMargins = UIEdgeInsetsMake(4, 4, 4, 4);
        popoverController.delegate = self;
        controller.delegate = self;
    }

    
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
        if([identifier isEqualToString:@"CasteIdentifier"]){
            if(isReligionSelected)
                return YES;
            else{
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Opps!" message:@"Please Select Religion first" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                return NO;
            }


        }

    
        if([identifier isEqualToString:@"GotraIdenifier"]){
            if(isReligionSelected){
                if(isCasteSelected)
                    return YES;
                else{
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Opps!" message:@"Please Select Caste first" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                    return NO;
                }

            }
            else{
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Opps!" message:@"Please Select Religion first" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                return NO;
            }

          
            
        
    }
      return YES;
}
-(void)selectedReligion:(PFObject *)religion{
    selectedReligion =religion;
    isReligionSelected = YES;
    
    //reset caste to nil
    selectedCaste = nil;
    [btnCaste setTitle:@"Caste" forState:UIControlStateNormal];
    [btnCaste setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    //reset gotra to nil
    selectedGotra = nil;
    [btnGotra setTitle:@"Gotra" forState:UIControlStateNormal];
    [btnGotra setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    [btnReligion setTitle:[religion valueForKey:@"name"] forState:UIControlStateNormal];
    [btnReligion setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [popoverController dismissPopoverAnimated:YES];

}
-(void)selectedHeight:(NSString *)height{
    NSArray *array = [height componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
    selectedHeightInCms = [array lastObject];
    selectedHeight = height;
    [btnHeight setTitle:height forState:UIControlStateNormal];
    [btnHeight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [popoverController dismissPopoverAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)religionButtonAction:(id)sender {
    religionSelectionType = @"Religion";
}
- (IBAction)gotraButtonAction:(id)sender {
    religionSelectionType = @"Gotra";

}

- (IBAction)casteButtonAction:(id)sender {
    religionSelectionType = @"Caste";
}
-(void)selectedGotra:(PFObject *)gotra{
    selectedGotra = gotra;
    [btnGotra setTitle:[gotra valueForKey:@"name"] forState:UIControlStateNormal];
    [btnGotra setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [popoverController dismissPopoverAnimated:YES];

}

-(void)selectedCaste:(PFObject *)religion{
    isCasteSelected = YES;
    selectedGotra = nil;
    [btnGotra setTitle:@"Gotra" forState:UIControlStateNormal];
    [btnGotra setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    selectedCaste = religion;
    [btnCaste setTitle:[religion valueForKey:@"name"] forState:UIControlStateNormal];
    [btnCaste setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [popoverController dismissPopoverAnimated:YES];

}
-(void)viewWillDisappear:(BOOL)animated{
    int height  = [selectedHeightInCms intValue];
    if(txtWeight.text.length>0)
        self.currentProfile[@"weight"] = @([txtWeight.text floatValue]);
    if(selectedHeight)
        self.currentProfile[@"height"] = @(height);
   if(selectedCaste)
        [self.currentProfile setObject:selectedCaste forKey:@"casteId"];
    else
        [self.currentProfile setObject:[NSNull null] forKey:@"casteId"];

    if(selectedGotra)
        [self.currentProfile setObject:selectedGotra forKey:@"gotraId"];
    else
        [self.currentProfile setObject:[NSNull null] forKey:@"gotraId"];
    if(selectedReligion)
        [self.currentProfile setObject:selectedReligion forKey:@"religionId"];
    else
        [self.currentProfile setObject:[NSNull null] forKey:@"religionId"];

        [self.delegate updatedPfObjectForSecondTab:self.currentProfile];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *sepStr;
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if([textField.text containsString:@"."]&&[string containsString:@"."]){
        return NO;
    }
    NSArray *sep = [newString componentsSeparatedByString:@"."];
    if([sep count]>=2)
    {
        sepStr=[NSString stringWithFormat:@"%@",[sep objectAtIndex:1]];
        NSLog(@"sepStr:%@",sepStr);
        if([sepStr length] >1)
        {
            return NO;
        }
        else
        {
            return YES;
        }
        
    }
    return YES;
}@end
