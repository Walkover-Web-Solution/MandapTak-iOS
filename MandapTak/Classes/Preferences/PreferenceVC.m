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
    
    lblLocation.layer.borderWidth = 1.0f;
    lblDegree.layer.borderWidth = 1.0f;
    
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

- (IBAction)setPreferences:(id)sender
{
    //hide autocomplete table view before saving
   // autocompleteTableView.hidden = YES;
    NSLog(@"min age = %@ , max age = %@ , min budget = %@,max budget = %@, income = %@",txtMinAge.text,txtMaxAge.text,txtminBudget.text,txtMaxBudget.text,txtIncome.text);
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
    
    int roundValue = roundf(value);
    
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
        //isSelectingCurrentLocation = YES;
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
        //isSelectingCurrentLocation = YES;
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
