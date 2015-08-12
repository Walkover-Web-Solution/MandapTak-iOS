//
//  PreferenceVC.m
//  MandapTak
//
//  Created by Anuj Jain on 8/4/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "PreferenceVC.h"

@interface PreferenceVC ()

@end

@implementation PreferenceVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[[UINavigationBar appearance] setBackgroundColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:(240/255.0f) green:(113/255.0f) blue:(116/255.0f) alpha:1.0f]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    arrSelLocations = [[NSMutableArray alloc]init];
    arrSelDegree = [[NSMutableArray alloc]init];
    
    //get current user preferences
    [self getUserPreference];
    
    lblLocation.layer.borderWidth = 1.0f;
    lblDegree.layer.borderWidth = 1.0f;
    btnMinHeight.layer.borderWidth = 1.0f;
    btnMaxHeight.layer.borderWidth = 1.0f;
    //height
    heightFlag = false;
    
    btnMinHeight.layer.cornerRadius = 5;
    btnMinHeight.layer.borderWidth = 1.0;
    btnMinHeight.layer.borderColor = [UIColor colorWithRed:167.0/255.0 green:140.0/255.0 blue:98.0/255.0 alpha:0.25].CGColor;
    btnMinHeight.layer.shadowColor = [UIColor blackColor].CGColor;
    btnMinHeight.layer.shadowRadius = 1;
    
    btnMaxHeight.layer.cornerRadius = 5;
    btnMaxHeight.layer.borderWidth = 1.0;
    btnMaxHeight.layer.borderColor = [UIColor colorWithRed:167.0/255.0 green:140.0/255.0 blue:98.0/255.0 alpha:0.25].CGColor;
    btnMaxHeight.layer.shadowColor = [UIColor blackColor].CGColor;
    btnMaxHeight.layer.shadowRadius = 1;
    
    lblLocation.layer.cornerRadius = 5;
    lblLocation.layer.borderWidth = 1.0;
    lblLocation.layer.borderColor = [UIColor colorWithRed:167.0/255.0 green:140.0/255.0 blue:98.0/255.0 alpha:0.25].CGColor;
    lblLocation.layer.shadowColor = [UIColor blackColor].CGColor;
    lblLocation.layer.shadowRadius = 1;
    
    lblDegree.layer.cornerRadius = 5;
    lblDegree.layer.borderWidth = 1.0;
    lblDegree.layer.borderColor = [UIColor colorWithRed:167.0/255.0 green:140.0/255.0 blue:98.0/255.0 alpha:0.25].CGColor;
    lblDegree.layer.shadowColor = [UIColor blackColor].CGColor;
    lblDegree.layer.shadowRadius = 1;
    
//    [[btnLocation layer] setBorderWidth:1.0f];
//    [[btnLocation layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    /*
    //autocomplete view conditions
    autocompleteTableView = [[UITableView alloc] init];
    autocompleteTableView.hidden = YES;
    arrAutoComplete = [[NSMutableArray alloc]init];
    arrDegree = [[NSMutableArray alloc] initWithObjects:@"B.E.",@"B Tech",@"M Tech",@"CA",@"CS",@"BBA",@"MBA",@"BCA",@"MCA", nil];
    
    [txtDegree addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    //set autocomplete tableview properties for sender ID
    arrAutoComplete = [[NSMutableArray alloc]init];
    autocompleteTableView.frame = CGRectMake(5, 210, 310, 120);
    autocompleteTableView.delegate = self;
    autocompleteTableView.dataSource = self;
    autocompleteTableView.scrollEnabled = YES;
    autocompleteTableView.hidden = YES;
    
    [self.view addSubview:autocompleteTableView];
     */
}

-(void) getUserPreference
{
    NSString *profileId = @"nASUvS6R7Z";    //gDlvVzftXF
    PFQuery *query = [PFQuery queryWithClassName:@"Preference"];
    [query whereKey:@"profileId" equalTo:[PFObject objectWithoutDataWithClassName:@"Profile" objectId:profileId]];
    //PFQuery *query = [PFQuery queryWithClassName:@"User"];
    //[query whereKey:@"objectId" equalTo:@"gDlvVzftXF"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            if (objects.count > 0)
            {
                insertFlag = false;
                for (PFObject *object in objects) {
                    NSLog(@"%@", object.objectId);
                    strObj = object.objectId;
                    txtMinAge.text = [NSString stringWithFormat:@"%@",[object valueForKey:@"ageFrom"]];
                    txtMaxAge.text = [NSString stringWithFormat:@"%@",[object valueForKey:@"ageTo"]];
                    txtIncome.text = [NSString stringWithFormat:@"%@",[object valueForKey:@"minIncome"]];   //[object valueForKey:@"minIncome"];
                    txtminBudget.text = [NSString stringWithFormat:@"%@",[object valueForKey:@"minBudget"]];    //[object valueForKey:@"minBudget"];
                    txtMaxBudget.text = [NSString stringWithFormat:@"%@",[object valueForKey:@"maxBudget"]];    //[object valueForKey:@"maxBudget"];
                    
                    [btnMinHeight setTitle:[NSString stringWithFormat:@"%@",[object valueForKey:@"minHeight"]] forState:UIControlStateNormal];
                    [btnMaxHeight setTitle:[NSString stringWithFormat:@"%@",[object valueForKey:@"maxHeight"]] forState:UIControlStateNormal];
                    roundValue = [[object valueForKey:@"working"] intValue];
                    [sliderWork setValue:roundValue animated:YES];
                    [self sliderChanged:nil];
                    
                    //NSLog(@"min age = %@ ,\n max age = %@ ,\n min budget = %@,\n max budget = %@,\n income = %@\n and workStatus = %d ,\n minHeight = %d ,\n max height = %d", txtMinAge.text,txtMaxAge.text,txtminBudget.text,txtMaxBudget.text,txtIncome.text,roundValue,minHeight,maxHeight);
                }
                //PFObject *objUser = objects[0];
                
                //[self showUserPreference:objects];
            }
            else
            {
                insertFlag = true;
            }
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            // Do something with the found objects
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


-(void) showUserPreference : (PFObject *)object
{
    NSLog(@"object = %@",object);
    for (NSDictionary *dict in object)
    {
        //set min age
        
        txtMinAge.text = [dict valueForKey:@"ageFrom"];
        txtMaxAge.text = [dict valueForKey:@"ageTo"];
        txtIncome.text = [dict valueForKey:@"minIncome"];
        txtminBudget.text = [dict valueForKey:@"minBudget"];
        txtMaxBudget.text = [dict valueForKey:@"maxBudget"];
        
        [btnMinHeight setTitle:[NSString stringWithFormat:@"%@ cm",[dict valueForKey:@"minHeight"]] forState:UIControlStateNormal];
        [btnMaxHeight setTitle:[NSString stringWithFormat:@"%@ cm",[dict valueForKey:@"maxHeight"]] forState:UIControlStateNormal];
        [sliderWork setValue:[[dict valueForKey:@"working"] floatValue] animated:YES];
        [self sliderChanged:nil];
        
        NSLog(@"min age = %@ ,\n max age = %@ ,\n min budget = %@,\n max budget = %@,\n income = %@\n and workStatus = %d ,\n minHeight = %d ,\n max height = %d", txtMinAge.text,txtMaxAge.text,txtminBudget.text,txtMaxBudget.text,txtIncome.text,roundValue,minHeight,maxHeight);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender
{
    [scrollView setContentOffset:CGPointZero animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    /*
    UIStoryboard *sbMain = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserProfileViewController *vc = [sbMain instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
    //vc.globalCompanyId = [self.companies.companyId intValue];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navController animated:YES completion:nil];
     */
}

-(NSString *)extractNumberFromText:(NSString *)text
{
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [[text componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
}

- (IBAction)setPreferences:(id)sender
{
    if (insertFlag)
    {
        //insert preferences
        PFObject *pref = [PFObject objectWithClassName:@"Preference"];
        pref[@"profileId"] = [PFObject objectWithoutDataWithClassName:@"Profile" objectId:@"nASUvS6R7Z"];
        pref[@"ageTo"] = [NSNumber numberWithInt:[txtMaxAge.text intValue]];
        pref[@"ageFrom"] = [NSNumber numberWithInt:[txtMinAge.text intValue]];
        pref[@"minHeight"] = [NSNumber numberWithInt:minHeight];
        pref[@"maxHeight"] = [NSNumber numberWithInt:maxHeight];
        pref[@"minIncome"] = [NSNumber numberWithInt:[txtIncome.text intValue]];
        pref[@"working"] = [NSNumber numberWithInt:roundValue];
        pref[@"minBudget"] = [NSNumber numberWithInt:[txtminBudget.text intValue]];
        pref[@"maxBudget"] = [NSNumber numberWithInt:[txtMaxBudget.text intValue]];
        pref[@"minGunMatch"] = @0;
        pref[@"manglik"] = @0;
        
        [pref saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }];
        
    }
    else
    {
        //update preferences
        PFQuery *query = [PFQuery queryWithClassName:@"Preference"];
        
        // Retrieve the object by id
        [query getObjectInBackgroundWithId:strObj
                                     block:^(PFObject *pref, NSError *error) {
                                         // Now let's update it with some new data. In this case, only cheatMode and score
                                         // will get sent to the cloud. playerName hasn't changed.
                        NSLog(@"min age = %@ ,\n max age = %@ ,\n min budget = %@,\n max budget = %@,\n income = %@\n and workStatus = %d ,\n minHeight = %d ,\n max height = %d", txtMinAge.text,txtMaxAge.text,txtminBudget.text,txtMaxBudget.text,txtIncome.text,roundValue,minHeight,maxHeight);
                                         
                                         pref[@"ageTo"] = [NSNumber numberWithInt:[txtMaxAge.text intValue]];
                                         pref[@"ageFrom"] = [NSNumber numberWithInt:[txtMinAge.text intValue]];
                                         pref[@"minHeight"] = [NSNumber numberWithInt:minHeight];
                                         pref[@"maxHeight"] = [NSNumber numberWithInt:maxHeight];
                                         pref[@"minIncome"] = [NSNumber numberWithInt:[txtIncome.text intValue]];
                                         pref[@"working"] = [NSNumber numberWithInt:roundValue];
                                         pref[@"minBudget"] = [NSNumber numberWithInt:[txtminBudget.text intValue]];
                                         pref[@"maxBudget"] = [NSNumber numberWithInt:[txtMaxBudget.text intValue]];
                                         pref[@"minGunMatch"] = @0;
                                         pref[@"manglik"] = @0;
                                         [pref saveInBackground];
                                     }];
       
    }
    
    (BOOL)saveAll:(PF_NULLABLE NSArray *)objects error:(NSError **)error
    [];
   
}


- (IBAction)goAction:(id)sender {
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark AutoComplete Methods
-(void)textFieldDidChange:(UITextField *)txt
{
    NSString *substring;
    
    NSArray *arrTemp = [txt.text componentsSeparatedByString:@","];
    if ([arrTemp count] < 2)
    {
        substring = [NSString stringWithString:txt.text];
    }
    else
    {
        //for multiple values already selected in textfield
        substring = [NSString stringWithString:[arrTemp lastObject]];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y-100);
    if (!(([textField isEqual:txtMinAge]) || ([textField isEqual:txtMaxAge])))
    {
        CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y + scrollView.contentInset.top - 150);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    //CGPoint scrollPoint = CGPointMake(0, textField.frame.origin.y - 50);
    if (!(([textField isEqual:txtMinAge]) || ([textField isEqual:txtMaxAge])))
    {
        [scrollView setContentOffset:CGPointZero animated:YES];
    }
}

#pragma mark Slider Methods
- (IBAction)sliderChanged:(id)sender
{
    // Adjust knob (to rounded value)
    NSString *strStatus;
    CGFloat value = [sliderWork value];
    
    roundValue = roundf(value);
    
    if (value != roundValue) {
        // Almost 100% of the time - Adjust:
        
        [sliderWork setValue:roundValue];
    }
    switch (roundValue) {
        case 0:
            strStatus = @"NO";
            break;
        case 1:
            strStatus = @"YES";
            break;
        case 2:
            strStatus = @"May Be";
            break;
        default:
            break;
    }
    [lblWorkStatus setText:[NSString stringWithFormat:@" %@ ",strStatus]];
}

- (IBAction)sliderValueChanged:(id)sender
{
    // Action Hooked to 'Value Changed' (continuous)
    
    // Update label (to rounded value)
    
    //CGFloat value = [sliderWork value];
    
    //int roundValue = roundf(value);
    
}

#pragma mark PopOver Controller Methods
#pragma mark Location Preference
-(void)selectedLocation:(Location *)location
{
    lblLocation.text = @"";
    if (location)
    {
        [arrSelLocations addObject:location.city];
    }
    NSString *strLocations = [arrSelLocations componentsJoinedByString:@","];
    [popoverController dismissPopoverAnimated:YES];
    lblLocation.text = strLocations;
}

- (void)showSelLocations : (NSArray *)arrLocation
{
    [self selectedLocation:nil];
}

#pragma mark Degree Preference
-(void)showSelDegree:(NSArray *)arrDegree
{
    arrSelDegree = arrDegree;
    lblDegree.text = @"";
    NSMutableArray *arrDeg = [[NSMutableArray alloc] init];
    for (Degree *obj in arrDegree)
    {
        NSString *strDeg = obj.degreeName;
        [arrDeg addObject:strDeg];
    }
    
    NSString *strDegree = [arrDeg componentsJoinedByString:@","];
    [popoverController dismissPopoverAnimated:YES];
    lblDegree.text = strDegree;
}

#pragma mark Height Preference
-(void)selectedHeight:(NSString*)height
{
    [popoverController dismissPopoverAnimated:YES];
    if (heightFlag)
    {
        //set max height
        [btnMaxHeight setTitle:height forState:UIControlStateNormal];
        NSString *strHeight = [[height componentsSeparatedByString:@" "]  lastObject];
        maxHeight = [[self extractNumberFromText:strHeight] intValue];
    }
    else
    {
        //set minimum height
        [btnMinHeight setTitle:height forState:UIControlStateNormal];
        NSString *strHeight = [[height componentsSeparatedByString:@" "]  lastObject];
        minHeight = [[self extractNumberFromText:strHeight] intValue];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"LocationIdentifier"])
    {
        //isSelectingCurrentLocation = YES;
        PopOverListViewController *controller = segue.destinationViewController;
        controller.contentSizeForViewInPopover = CGSizeMake(310, 400);
        WYStoryboardPopoverSegue* popoverSegue = (WYStoryboardPopoverSegue*)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender
                                             permittedArrowDirections:WYPopoverArrowDirectionAny
                                                             animated:YES];
        popoverController.popoverLayoutMargins = UIEdgeInsetsMake(4, 4, 4, 4);
        popoverController.delegate = self;
        controller.delegate = self;
        
    }
    
    else if ([segue.identifier isEqualToString:@"SelectedLocationIdentifier"])
    {
        //isSelectingCurrentLocation = YES;
        SelectedLocationVC *controller = segue.destinationViewController;
        controller.arrTableData = arrSelLocations;
        controller.contentSizeForViewInPopover = CGSizeMake(310, 400);
        WYStoryboardPopoverSegue* popoverSegue = (WYStoryboardPopoverSegue*)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender
                                             permittedArrowDirections:WYPopoverArrowDirectionAny
                                                             animated:YES];
        popoverController.popoverLayoutMargins = UIEdgeInsetsMake(4, 4, 4, 4);
        popoverController.delegate = self;
        controller.delegate = self;
        
    }
    
    //Degree View
    else if ([segue.identifier isEqualToString:@"DegreeListIdentifier"])
    {
        //isSelectingCurrentLocation = YES;
        DegreeListVC *controller = segue.destinationViewController;
        controller.arrSelDegree = arrSelDegree;
        controller.contentSizeForViewInPopover = CGSizeMake(310, 300);
        WYStoryboardPopoverSegue* popoverSegue = (WYStoryboardPopoverSegue*)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender
                                             permittedArrowDirections:WYPopoverArrowDirectionAny
                                                             animated:YES];
        popoverController.popoverLayoutMargins = UIEdgeInsetsMake(4, 4, 4, 4);
        popoverController.delegate = self;
        controller.delegate = self;
        
    }
    
    //Min height View
    else if ([segue.identifier isEqualToString:@"minHeightIdentifier"])
    {
        heightFlag = false;
        HeightPopoverViewController *controller = segue.destinationViewController;
        //controller.arrSelDegree = arrSelDegree;
        controller.contentSizeForViewInPopover = CGSizeMake(310, 300);
        WYStoryboardPopoverSegue* popoverSegue = (WYStoryboardPopoverSegue*)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender
                                             permittedArrowDirections:WYPopoverArrowDirectionAny
                                                             animated:YES];
        popoverController.popoverLayoutMargins = UIEdgeInsetsMake(4, 4, 4, 4);
        popoverController.delegate = self;
        controller.delegate = self;
        
    }
    
    //Max height View
    else if ([segue.identifier isEqualToString:@"maxHeightIdentifier"])
    {
        heightFlag = true;
        HeightPopoverViewController *controller = segue.destinationViewController;
        //controller.arrSelDegree = arrSelDegree;
        controller.contentSizeForViewInPopover = CGSizeMake(310, 300);
        WYStoryboardPopoverSegue* popoverSegue = (WYStoryboardPopoverSegue*)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender
                                             permittedArrowDirections:WYPopoverArrowDirectionAny
                                                             animated:YES];
        popoverController.popoverLayoutMargins = UIEdgeInsetsMake(4, 4, 4, 4);
        popoverController.delegate = self;
        controller.delegate = self;
        
    }
    
    
}
@end
