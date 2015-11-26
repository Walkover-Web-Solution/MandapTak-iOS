//
//  PreferenceVC.m
//  MandapTak
//
//  Created by Anuj Jain on 8/4/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "PreferenceVC.h"
#import "MultiSelectController.h"

@interface PreferenceVC ()

@end

@implementation PreferenceVC
@synthesize ageSlider,heightSlider,label;
- (void)viewDidLoad
{
    [super viewDidLoad];
    //set preference to handle back button in matched case
    [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"isFromPreference"];
    
    //notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveData:) name:@"ActiveStateNotification" object:nil];

    //[[UINavigationBar appearance] setBackgroundColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:(240/255.0f) green:(113/255.0f) blue:(116/255.0f) alpha:1.0f]];
    //self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName : [UIFont fontWithName:@"MYRIADPRO-REGULAR.OTF" size:17.0f]};
    
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSFontAttributeName:[UIFont fontWithName:@"MYRIADPRO-REGULAR" size:17],
                                                                    NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                    };
    //update constraints
    if ([UIScreen mainScreen].bounds.size.height == 480.0f)
    {
        //[self.view removeConstraint:equalHeightConstraint];
    }
    
    //set Range Slider Delegate
    ageSlider.delegate = self;
    heightSlider.delegate = self;
    NSNumberFormatter *customFormatter = [[NSNumberFormatter alloc] init];
    customFormatter.positiveSuffix = @"ft";
    customFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    heightSlider.numberFormatterOverride = customFormatter;
    
    //hide age text fields
    txtMinAge.hidden = YES;
    txtMaxAge.hidden = YES;
    btnMinHeight.hidden = YES;
    btnMaxHeight.hidden = YES;
    
    arrSelLocations = [[NSMutableArray alloc]init];
    arrSelDegree = [[NSMutableArray alloc]init];
    arrSelectedDegreeId = [[NSMutableArray alloc]init];
    arrDegreePref = [[NSMutableArray alloc]init];
    arrSelectedLocationId = [[NSMutableArray alloc]init];
    arrLocationPref = [[NSMutableArray alloc]init];
    arrLocationObj = [[NSMutableArray alloc]init];
    arrDegreeObject = [[NSMutableArray alloc]init];
    
    arrHeight = [NSArray arrayWithObjects:@"4ft 5in - 134cm",@"4ft 6in - 137cm",@"4ft 7in - 139cm",@"4ft 8in - 142cm",@"4ft 9in - 144cm",@"4ft 10in - 147cm",@"4ft 11in - 149cm",@"5ft - 152cm",@"5ft 1in - 154cm",@"5ft 2in - 157cm",@"5ft 3in - 160cm",@"5ft 4in - 162cm",@"5ft 5in - 165cm",@"5ft 6in - 167cm",@"5ft 7in - 170cm",@"5ft 8in - 172cm",@"5ft 9in - 175cm",@"5ft 10in - 177cm",@"5ft 11in - 180cm",@"6ft - 182cm",@"6ft 1in - 185cm",@"6ft 2in - 187cm",@"6ft 3in - 190cm",@"6ft 4in - 193cm",@"6ft 5in - 195cm",@"6ft 6in - 198cm",@"6ft 7in - 200cm",@"6ft 8in - 203cm",@"6ft 9in - 205cm",@"6ft 10in - 208cm",@"6ft 11in - 210cm",@"7ft - 213cm", nil];
    
    
    arrHeightInFeet = [NSArray arrayWithObjects:@"4.0",@"4.5",@"5.0",@"5.5",@"6.0",@"6.5",@"7.0", nil];
    arrHeightInInch = [NSArray arrayWithObjects:@"121",@"137",@"152",@"167",@"182",@"198",@"213", nil];
    //get current user preferences
    [self getUserPreference];
    
//    lblLocation.layer.borderWidth = 1.0f;
//    lblDegree.layer.borderWidth = 1.0f;
//    btnMinHeight.layer.borderWidth = 1.0f;
//    btnMaxHeight.layer.borderWidth = 1.0f;
    //height
    heightFlag = false;
    
    btnMinHeight.layer.cornerRadius = 5;
    btnMinHeight.layer.borderWidth = 0.5;
    btnMinHeight.layer.borderColor = [UIColor colorWithRed:167.0/255.0 green:140.0/255.0 blue:98.0/255.0 alpha:0.25].CGColor;
    btnMinHeight.layer.shadowColor = [UIColor blackColor].CGColor;
    btnMinHeight.layer.shadowRadius = 1;
    
    btnMaxHeight.layer.cornerRadius = 5;
    btnMaxHeight.layer.borderWidth = 0.5;
    btnMaxHeight.layer.borderColor = [UIColor colorWithRed:167.0/255.0 green:140.0/255.0 blue:98.0/255.0 alpha:0.25].CGColor;
    btnMaxHeight.layer.shadowColor = [UIColor blackColor].CGColor;
    btnMaxHeight.layer.shadowRadius = 1;
    
    lblLocation.layer.cornerRadius = 5;
    lblLocation.layer.borderWidth = 0.5;
    lblLocation.layer.borderColor = [UIColor colorWithRed:167.0/255.0 green:140.0/255.0 blue:98.0/255.0 alpha:0.25].CGColor;
    lblLocation.layer.shadowColor = [UIColor blackColor].CGColor;
    lblLocation.layer.shadowRadius = 1;
    
    lblDegree.layer.cornerRadius = 5;
    lblDegree.layer.borderWidth = 0.5;
    lblDegree.layer.borderColor = [UIColor colorWithRed:167.0/255.0 green:140.0/255.0 blue:98.0/255.0 alpha:0.25].CGColor;
    lblDegree.layer.shadowColor = [UIColor blackColor].CGColor;
    lblDegree.layer.shadowRadius = 1;
    
    //set toolbar for numberpad
    UIToolbar *numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           nil];
    [numberToolbar sizeToFit];
    txtIncome.inputAccessoryView = numberToolbar;
    txtMaxAge.inputAccessoryView = numberToolbar;
    txtMinAge.inputAccessoryView = numberToolbar;
    txtminBudget.inputAccessoryView = numberToolbar;
    txtMaxBudget.inputAccessoryView = numberToolbar;
    
    //hide budget option
    lblBudget.hidden = YES;
    txtMaxBudget.hidden = YES;
    txtminBudget.hidden = YES;
    
    //hide degree option
    lblDegree.hidden = YES;
    btnAddDegree.hidden = YES;
    
    //hide preferred loaction button
    btnPreferredLocation.hidden = YES;
   // [self checkBudgetVisiblity];
    
    /*
    [super viewWillLayoutSubviews];
    rangeSlider = [[MARKRangeSlider alloc] init] ;
    rangeSlider.frame = CGRectMake(20, 80 , 290.0, 20.0);
    [rangeSlider addTarget:self
                         action:@selector(rangeSliderValueDidChange:)
               forControlEvents:UIControlEventValueChanged];
    rangeSlider.minimumValue = 0;
    rangeSlider.maximumValue = 4.0;
    rangeSlider.leftValue = 0.8;
    rangeSlider.rightValue = 4.0;
    rangeSlider.minimumDistance = 0.1;
    
    [self.view addSubview:rangeSlider];
     */
}

- (void)rangeSliderValueDidChange:(MARKRangeSlider *)slider {
    NSLog(@"%0.1f - %0.2f", slider.leftValue, slider.rightValue);
}

-(void)viewWillAppear:(BOOL)animated
{
}

-(void)cancelNumberPad{
    [txtMinAge resignFirstResponder];
    [txtMaxAge resignFirstResponder];
    [txtIncome resignFirstResponder];
    [txtminBudget resignFirstResponder];
    [txtMaxBudget resignFirstResponder];
    //  numberTextField.text = @"";
}

-(void) getUserPreference
{
    if([[AppData sharedData]isInternetAvailable])
    {
        //MBProgressHUD * hud;
        //hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self showLoader];
        NSString *profileId = [[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"];   //@"nASUvS6R7Z";    //gDlvVzftXF
        
        PFQuery *query = [PFQuery queryWithClassName:@"Preference"];
        [query whereKey:@"profileId" equalTo:[PFObject objectWithoutDataWithClassName:@"Profile" objectId:profileId]];
        //query.cachePolicy = kPFCachePolicyCacheElseNetwork;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             //[MBProgressHUD hideHUDForView:self.view animated:YES];
             [self hideLoader];
             if (!error)
             {
                 if (objects.count > 0)
                 {
                     insertFlag = false;
                     for (PFObject *object in objects)
                     {
                         //NSLog(@"%@", object.objectId);
                         
                         //get Degree Preference
                         [self getDegreePrefFromPreferenceId:object.objectId];
                         
                         //get Location Preference
                         [self getLocationPrefFromPreferenceId:object.objectId];
                         
                         //set age slider value
                         strObj = object.objectId;
                         txtMinAge.text = [NSString stringWithFormat:@"%@",[object valueForKey:@"ageFrom"]];
                         ageSlider.selectedMinimum = [[object valueForKey:@"ageFrom"] floatValue];
                         if (!([[object valueForKey:@"ageFrom"] intValue] > 0))
                         {
                             ageSlider.selectedMinimum = 18;
                             txtMinAge.text = nil;
                         }
                         
                         txtMaxAge.text = [NSString stringWithFormat:@"%@",[object valueForKey:@"ageTo"]];
                         ageSlider.selectedMaximum = [[object valueForKey:@"ageTo"] floatValue];
                         if (!([[object valueForKey:@"ageTo"] intValue] > 0))
                         {
                             ageSlider.selectedMaximum = 45;
                             txtMaxAge.text = nil;
                         }
                         
                         //set age limit title label value
                         lblAgeLimit.text = [NSString stringWithFormat:@"AGE LIMIT (%.0f - %.0f)",[[object valueForKey:@"ageFrom"] floatValue],[[object valueForKey:@"ageTo"] floatValue]];
                         
                         txtIncome.text = [NSString stringWithFormat:@"%@",[object valueForKey:@"minIncome"]];   //[object valueForKey:@"minIncome"];
                         if (!([[object valueForKey:@"minIncome"] intValue] > 0))
                         {
                             txtIncome.text = nil;
                         }
                         
                         txtminBudget.text = [NSString stringWithFormat:@"%@",[object valueForKey:@"minBudget"]];    //[object valueForKey:@"minBudget"];
                         if (!([[object valueForKey:@"minBudget"] intValue] > 0))
                         {
                             txtminBudget.text = nil;
                         }
                         
                         txtMaxBudget.text = [NSString stringWithFormat:@"%@",[object valueForKey:@"maxBudget"]];    //[object valueForKey:@"maxBudget"];
                         if (!([[object valueForKey:@"maxBudget"] intValue] > 0))
                         {
                             txtMaxBudget.text = nil;
                         }
                         
                         //find height value from array
                         /*
                         NSString *strMinHeight = [self getFormattedHeightFromValue:[NSString stringWithFormat:@"%@cm",[object valueForKey:@"minHeight"]]];
                         NSString *strMaxHeight = [self getFormattedHeightFromValue:[NSString stringWithFormat:@"%@cm",[object valueForKey:@"maxHeight"]]];
                         
                         minHeight = [[object valueForKey:@"minHeight"] intValue];
                         maxHeight = [[object valueForKey:@"maxHeight"] intValue];
                         */
                         //set height range slider value
                         NSString *strHeightMin = [[object valueForKey:@"minHeight"] stringValue];
                         minHeight = [strHeightMin intValue];
                         int minHeightInFeet = [arrHeightInInch indexOfObject:strHeightMin];
                         float sliderMinHeight = [[arrHeightInFeet objectAtIndex:minHeightInFeet] floatValue];
                         heightSlider.selectedMinimum = sliderMinHeight;
                         
                         NSString *strHeightMax = [[object valueForKey:@"maxHeight"] stringValue];
                         maxHeight = [strHeightMax intValue];
                         int maxHeightInFeet = [arrHeightInInch indexOfObject:strHeightMax];
                         float sliderMaxHeight = [[arrHeightInFeet objectAtIndex:maxHeightInFeet] floatValue];
                         heightSlider.selectedMaximum = sliderMaxHeight;
                         
                         lblHeight.text = [NSString stringWithFormat:@"HEIGHT (%.1f ft - %.1f ft)",sliderMinHeight,sliderMaxHeight];
                         
                         //[btnMinHeight setTitle:strMinHeight forState:UIControlStateNormal];
                         //[btnMaxHeight setTitle:strMaxHeight forState:UIControlStateNormal];
                         roundValue = [[object valueForKey:@"working"] intValue];
                         [sliderWork setValue:roundValue animated:YES];
                         [self sliderChanged:nil];
                         
                         roundValueManglik = [[object valueForKey:@"manglik"] intValue];
                         [sliderManglik setValue:roundValueManglik animated:YES];
                         [self manglikSliderChanged:nil];
                         
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
                 //NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
                 // Do something with the found objects
                 
             } else {
                 // Log details of the failure
                 NSLog(@"Error: %@ %@", error, [error userInfo]);
             }
         }];
    }
    else
    {
        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"Opps!!" message:@"Please Check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (void) getDegreePrefFromPreferenceId :(NSString *)prefId
{
    if ([[AppData sharedData] isInternetAvailable])
    {
    //MBProgressHUD * hud;
    //hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self showLoader];
    PFQuery *query = [PFQuery queryWithClassName:@"DegreePreferences"];
    [query whereKey:@"preferenceId" equalTo:[PFObject objectWithoutDataWithClassName:@"Preference" objectId:prefId]];     //@"0hIRQZw3di"
    [query includeKey:@"degreeId"];
    [query includeKey:@"degreeTypeId"];
       // query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         //[MBProgressHUD hideHUDForView:self.view animated:YES];
         [self hideLoader];
         if (!error)
         {
             if (objects.count > 0)
             {
                 NSMutableArray *arrTempDegree = [[NSMutableArray alloc] init];
                 for (PFObject *object in objects)
                 {
                     
                     PFObject *degree = [object valueForKey:@"degreeId"];
                      if (!degree)
                      {
                          degree = [object valueForKey:@"degreeTypeId"];
                      }
                     //NSLog(@"Degree ID => %@", degree.objectId);
                     //NSLog(@"\n Degree Name %@",[degree valueForKey:@"name"]);
                     Degree *obj = [[Degree alloc] init];
                     obj.objectId = degree.objectId;
                     obj.objectPointer = degree;
                     
                     if ([degree.parseClassName isEqualToString:@"Degree"])
                     {
                         obj.objectName = [degree valueForKey:@"name"];
                     }
                     else if ([degree.parseClassName isEqualToString:@"DegreeType"])
                     {
                         obj.objectType = [degree valueForKey:@"typeOfDegree"];
                     }
                     
                     [arrTempDegree addObject:obj];
                     
                     /*
                     //new code
                     PFObject *degree = [object valueForKey:@"degreeId"];
                     if (!degree)
                     {
                         degree = [object valueForKey:@"degreeTypeId"];
                     }
                     NSLog(@"Location ID => %@", location.objectId);
                     NSLog(@"\n Location Name %@",[location valueForKey:@"name"]);
                     Location *obj = [[Location alloc] init];
                     obj.placeId = location.objectId;
                     obj.cityPointer = location;
                     
                     if ([location.parseClassName isEqualToString:@"City"])
                     {
                         obj.city = [location valueForKey:@"name"];
                     }
                     else if ([location.parseClassName isEqualToString:@"State"])
                     {
                         obj.state = [location valueForKey:@"name"];
                     }
                     
                     //obj.degreeType = [degree valueForKey:@"name"];
                     [arrLocationObj addObject:obj];
                      */
                 }
                 [self showSelDegree:arrTempDegree];
             }
             else
             {
                 //insertFlag = true;
             }
             // The find succeeded.
             NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
             // Do something with the found objects
             
         }
         else {
             // Log details of the failure
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
    }
    else
    {
        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"Opps!!" message:@"Please Check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}


- (void) getLocationPrefFromPreferenceId : (NSString *)prefId
{
    if ([[AppData sharedData]isInternetAvailable])
    {
    //MBProgressHUD * hud;
    //hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self showLoader];
    PFQuery *query = [PFQuery queryWithClassName:@"LocationPreferences"];
    [query whereKey:@"preferenceId" equalTo:[PFObject objectWithoutDataWithClassName:@"Preference" objectId:prefId]];     //@"0hIRQZw3di"
    [query includeKey:@"cityId"];
    [query includeKey:@"stateId"];
    //query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [self hideLoader];
         if (!error)
         {
             if (objects.count > 0)
             {
                 //NSMutableArray *arrTempLocation = [[NSMutableArray alloc] init];
                 for (PFObject *object in objects)
                 {
                     PFObject *location = [object valueForKey:@"cityId"];
                     if (!location)
                     {
                         location = [object valueForKey:@"stateId"];
                     }
                     NSLog(@"Location ID => %@", location.objectId);
                     NSLog(@"\n Location Name %@",[location valueForKey:@"name"]);
                     Location *obj = [[Location alloc] init];
                     obj.placeId = location.objectId;
                     obj.cityPointer = location;
                     
                     if ([location.parseClassName isEqualToString:@"City"])
                     {
                        obj.city = [location valueForKey:@"name"];
                     }
                     else if ([location.parseClassName isEqualToString:@"State"])
                     {
                         obj.state = [location valueForKey:@"name"];
                     }
                     
                     //obj.degreeType = [degree valueForKey:@"name"];
                     [arrLocationObj addObject:obj];
                 }
                 //[self showSelDegree:arrTempLocation];
                 [self showSelectedLocation:arrLocationObj];
             }
             else
             {
                 //insertFlag = true;
             }
             // The find succeeded.
             NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
             // Do something with the found objects
             
         }
         else {
             // Log details of the failure
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
    }
    else
    {
        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"Opps!!" message:@"Please Check your internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (NSString *)getFormattedHeightFromValue:(NSString *)value
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", value];
    NSString *strFiltered = [[arrHeight filteredArrayUsingPredicate:predicate] firstObject];
    return strFiltered;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Range Slider 
-(void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum
{
    //NSLog(@"min age = %f and max age = %F",sender.selectedMinimum,sender.selectedMaximum);
    if (sender == ageSlider)
    {
        NSLog(@"Age slider updated. Min Value: %.0f Max Value: %.0f", selectedMinimum, selectedMaximum);
        lblAgeLimit.text = [NSString stringWithFormat:@"AGE LIMIT (%.0f - %.0f)",selectedMinimum,selectedMaximum];
    }
    else if(sender == heightSlider)
    {
        NSLog(@"Height slider updated. Min Value: %.1f Max Value: %.1f", selectedMinimum, selectedMaximum);
        lblHeight.text = [NSString stringWithFormat:@"HEIGHT (%.1f ft - %.1f ft)",selectedMinimum,selectedMaximum];
        NSString *strMinHeight = [NSString stringWithFormat:@"%.1f",selectedMinimum];
        
        minHeight = [[arrHeightInInch objectAtIndex:[arrHeightInFeet indexOfObject:strMinHeight]] floatValue];
        maxHeight = [[arrHeightInInch objectAtIndex:[arrHeightInFeet indexOfObject:[NSString stringWithFormat:@"%.1f",selectedMaximum]]] floatValue];
        NSLog(@"DB min = %d and max = %d ",minHeight,maxHeight);
    }
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
    //set validations
    if (txtMinAge.text.length > 0)
    {
        if ([txtMinAge.text intValue] < 18)
        {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Min age should be 18 years" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [av show];
            return;
        }
        else if (txtMaxAge.text.length > 0)
        {
            int intMinAge = [txtMinAge.text intValue];
            int intMaxAge = [txtMaxAge.text intValue];
            if (intMaxAge < intMinAge)
            {
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Min age should be less than Max Age " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [av show];
                return;
            }
        }
        else
        {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Enter Max Age " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [av show];
            return;
        }
        
    }
    if (txtMaxAge.text.length > 0)
    {
        if (txtMinAge.text.length > 0)
        {
            int intMinAge = [txtMinAge.text intValue];
            int intMaxAge = [txtMaxAge.text intValue];
            if (intMaxAge < intMinAge)
            {
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Max age should be greater than Min Age " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [av show];
                return;
            }
        }
        else
        {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Enter Min Age " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [av show];
            return;
        }
    }
    
    //height validations
    if (maxHeight < minHeight)
    {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Min Height should be less than Max Height " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    
    //budget validations
    if (txtminBudget.text.length > 0)
    {
        if (txtMaxBudget.text.length > 0)
        {
            int intMinBudget = [txtminBudget.text intValue];
            int intMaxBudget = [txtMaxBudget.text intValue];
            if (intMaxBudget < intMinBudget)
            {
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Min Budget should be less than Max Budget " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [av show];
                return;
            }
        }
        else
        {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Enter Max Budget " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [av show];
            return;
        }
        
    }
    if (txtMaxBudget.text.length > 0)
    {
        if (txtminBudget.text.length > 0)
        {
            int intMinBudget = [txtminBudget.text intValue];
            int intMaxBudget = [txtMaxBudget.text intValue];
            if (intMaxBudget < intMinBudget)
            {
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Max Budget should be greater than Min Budget " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [av show];
                return;
            }
        }
        else
        {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Enter Min Budget " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [av show];
            return;
        }
    }
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self showLoader];
    /*
    NSString *strMinHeight = [[btnMinHeight.titleLabel.text componentsSeparatedByString:@" "]  lastObject];
    minHeight = [[self extractNumberFromText:strMinHeight] intValue];
    NSString *strMaxHeight = [[btnMaxHeight.titleLabel.text componentsSeparatedByString:@" "]  lastObject];
    maxHeight = [[self extractNumberFromText:strMaxHeight] intValue];
    */
    
    if ([[AppData sharedData]isInternetAvailable])
    {
        if (insertFlag)
        {
            //insert preferences
            PFObject *pref = [PFObject objectWithClassName:@"Preference"];
            pref[@"profileId"] = [PFObject objectWithoutDataWithClassName:@"Profile" objectId:[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"]];
            pref[@"ageTo"] = [NSNumber numberWithInt:floorf(ageSlider.selectedMaximum)];//[NSNumber numberWithInt:[txtMaxAge.text intValue]];
            pref[@"ageFrom"] = [NSNumber numberWithInt:floorf(ageSlider.selectedMinimum)];//[NSNumber numberWithInt:[txtMinAge.text intValue]];
            pref[@"minHeight"] = [NSNumber numberWithInt:minHeight];
            pref[@"maxHeight"] = [NSNumber numberWithInt:maxHeight];
            pref[@"minIncome"] = [NSNumber numberWithInt:[txtIncome.text intValue]];
            pref[@"working"] = [NSNumber numberWithInt:roundValue];
            pref[@"minBudget"] = [NSNumber numberWithInt:[txtminBudget.text intValue]];
            pref[@"maxBudget"] = [NSNumber numberWithInt:[txtMaxBudget.text intValue]];
            pref[@"minGunMatch"] = @0;
            pref[@"manglik"] = [NSNumber numberWithInt:roundValueManglik];
            
            [pref saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
             {
                 //[MBProgressHUD hideHUDForView:self.view animated:YES];
                 [self hideLoader];
                 if (succeeded)
                 {
                     // The object has been saved.
                     //execute further query of degree and location preference
                     NSLog(@"new object Id = %@",pref.objectId);
                     strObj = pref.objectId;
                     [self saveDegreePreference];
                     [self saveLocationPreference];
                 }
                 else  if (error.code ==209){
                     UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Logged in from another device, Please login again!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                     [errorAlertView show];
                 }
             }];
            
        }
        else
        {
            //update preferences
            PFQuery *query = [PFQuery queryWithClassName:@"Preference"];
            //query.cachePolicy = kPFCachePolicyCacheElseNetwork;
            // Retrieve the object by id
            [query getObjectInBackgroundWithId:strObj
                                         block:^(PFObject *pref, NSError *error)
             {
                 // Now let's update it with some new data. In this case, only cheatMode and score
                 // will get sent to the cloud. playerName hasn't changed.
                 NSLog(@"min age = %@ ,\n max age = %@ ,\n min budget = %@,\n max budget = %@,\n income = %@\n and workStatus = %d ,\n minHeight = %d ,\n max height = %d", txtMinAge.text,txtMaxAge.text,txtminBudget.text,txtMaxBudget.text,txtIncome.text,roundValue,minHeight,maxHeight);
                 
                 pref[@"ageTo"] = [NSNumber numberWithInt:floorf(ageSlider.selectedMaximum)];//[NSNumber numberWithInt:[txtMaxAge.text intValue]];
                 pref[@"ageFrom"] = [NSNumber numberWithInt:floorf(ageSlider.selectedMinimum)];//[NSNumber numberWithInt:[txtMinAge.text intValue]];
                 pref[@"minHeight"] = [NSNumber numberWithInt:minHeight];
                 pref[@"maxHeight"] = [NSNumber numberWithInt:maxHeight];
                 pref[@"minIncome"] = [NSNumber numberWithInt:[txtIncome.text intValue]];
                 pref[@"working"] = [NSNumber numberWithInt:roundValue];
                 pref[@"minBudget"] = [NSNumber numberWithInt:[txtminBudget.text intValue]];
                 pref[@"maxBudget"] = [NSNumber numberWithInt:[txtMaxBudget.text intValue]];
                 pref[@"minGunMatch"] = @0;
                 pref[@"manglik"] = [NSNumber numberWithInt:roundValueManglik];
                 [pref saveInBackground];
                 
                 //execute further query of degree and location preference
                 [self saveDegreePreference];
                 [self saveLocationPreference];
             }];
            
        }
    }
    else
    {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Enter Min Budget " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    
}


-(void) saveDegreePreference
{
    if ([[AppData sharedData] isInternetAvailable])
    {
    //delete previously set degree preferences
    //[arrSelectedDegreeId removeAllObjects];
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self showLoader];
    
    PFQuery *query = [PFQuery queryWithClassName:@"DegreePreferences"];
    [query whereKey:@"preferenceId" equalTo:[PFObject objectWithoutDataWithClassName:@"Preference" objectId:strObj]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error)
        {
            // The find succeeded.
            //NSLog(@"Successfully retrieved %lu degree preferences.", objects.count);
            // Do something with the found objects
            if (objects.count > 0)
            {
                [PFObject deleteAllInBackground:objects];
            }
            
            //[self addNewDegreePreference];
            [self performSelector:@selector(addNewDegreePreference) withObject:nil afterDelay:1.0];
            
        }
        else  if (error.code ==209){
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Logged in from another device, Please login again!!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
        else
        {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [av show];
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    }
    else
    {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet not available " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
}

- (void) addNewDegreePreference
{
    if ([[AppData sharedData] isInternetAvailable])
    {
        for (int i=0; i< [arrDegreeObject count]; i++)
        {
            //save data in
            PFObject *object = [PFObject objectWithClassName:@"DegreePreferences"];
            //object[@"degreeId"] = [PFObject objectWithoutDataWithClassName:@"Degree" objectId:arrSelectedDegreeId[i]];
            object[@"preferenceId"] = [PFObject objectWithoutDataWithClassName:@"Preference" objectId:strObj];
            Degree *objDegree = arrDegreeObject[i];
            PFObject *currentObj = objDegree.objectPointer;
            NSString *strClassName = currentObj.parseClassName;
            
            //check object class from object id
            if ([strClassName isEqualToString:@"Degree"])
            {
                object[@"degreeId"] = [PFObject objectWithoutDataWithClassName:@"Degree" objectId:currentObj.objectId];
            }
            else if ([strClassName isEqualToString:@"DegreeType"])
            {
                object[@"degreeTypeId"] = [PFObject objectWithoutDataWithClassName:@"DegreeType" objectId:currentObj.objectId];
            }
            [arrDegreePref addObject:object];
        }
        
        
        
        [PFObject saveAllInBackground:arrDegreePref block:^(BOOL succeeded, NSError *error)
         {
             //[MBProgressHUD hideHUDForView:self.view animated:YES];
             [self hideLoader];
             if(!error)
             {
                 NSLog(@"save complete");
                 //[arrSelectedDegreeId removeAllObjects];
             }else{
                 NSLog(@"SaveAll error %@", error);
             }
         }];
    }
    else
    {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Enter Min Budget " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
}

#pragma mark Parse Location Preference
-(void) saveLocationPreference
{
    if ([[AppData sharedData]isInternetAvailable])
    {
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self showLoader];
    //delete previously set degree preferences
    //[arrSelectedDegreeId removeAllObjects];
    
    PFQuery *query = [PFQuery queryWithClassName:@"LocationPreferences"];
    [query whereKey:@"preferenceId" equalTo:[PFObject objectWithoutDataWithClassName:@"Preference" objectId:strObj]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu location preferences.", objects.count);
            // Do something with the found objects
            if (objects.count >0)
            {
                [PFObject deleteAllInBackground:objects];
            }
            
            //[self addNewDegreePreference];
            [self performSelector:@selector(addNewLocationPreference) withObject:nil afterDelay:1.0];
            
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    }
    else
    {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Enter Min Budget " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    //then add new objects
    
}

- (void) addNewLocationPreference
{
    //insert fresh data
    if ([[AppData sharedData]isInternetAvailable])
    {
        //for (int i=0; i< [arrLocationObj count]; i++)
        for (int i=0; i< [arrLocationObj count]; i++)
        {
            Location *objLoc = arrLocationObj[i];
            PFObject *currentObj = objLoc.cityPointer;
            NSString *strClassName = currentObj.parseClassName;
            
            PFObject *object = [PFObject objectWithClassName:@"LocationPreferences"];
            object[@"preferenceId"] = [PFObject objectWithoutDataWithClassName:@"Preference" objectId:strObj];
            
            //check object class from object id
            if ([strClassName isEqualToString:@"City"])
            {
                object[@"cityId"] = [PFObject objectWithoutDataWithClassName:@"City" objectId:currentObj.objectId];
            }
            else if ([strClassName isEqualToString:@"State"])
            {
                object[@"stateId"] = [PFObject objectWithoutDataWithClassName:@"State" objectId:currentObj.objectId];
            }
            //save data in
            
            [arrLocationPref addObject:object];
        }
        
    //    for (int i=0; i< [arrSelectedLocationId count]; i++)
    //    {
    //        //save data in
    //        PFObject *object = [PFObject objectWithClassName:@"LocationPreferences"];
    //        object[@"cityId"] = [PFObject objectWithoutDataWithClassName:@"City" objectId:arrSelectedLocationId[i]];
    //        object[@"preferenceId"] = [PFObject objectWithoutDataWithClassName:@"Preference" objectId:strObj];
    //        [arrLocationPref addObject:object];
    //    }
        
        [PFObject saveAllInBackground:arrLocationPref block:^(BOOL succeeded, NSError *error)
         {
             //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             [self hideLoader];
             [self back:nil];
             if(!error)
             {
                 NSLog(@"save complete");
                 //[arrSelectedLocationId removeAllObjects];
             }else{
                 NSLog(@"SaveAll error %@", error);
             }
         }];
    }
    else
    {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Enter Min Budget " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
}

- (IBAction)goAction:(id)sender{
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
            strStatus = @"Both";
            break;
        case 1:
            strStatus = @"YES";
            break;
        case 2:
            strStatus = @"NO";
            break;
        default:
            break;
    }
    [lblWorkStatus setText:[NSString stringWithFormat:@" %@ ",strStatus]];
}

- (IBAction)manglikSliderChanged:(id)sender
{
    // Adjust knob (to rounded value)
    NSString *strStatus;
    CGFloat value = [sliderManglik value];
    
    roundValueManglik = roundf(value);
    
    if (value != roundValueManglik) {
        // Almost 100% of the time - Adjust:
        
        [sliderManglik setValue:roundValueManglik];
    }
    switch (roundValueManglik) {
        case 0:
            strStatus = @"Both";
            break;
        case 1:
            strStatus = @"YES";
            break;
        case 2:
            strStatus = @"NO";
            break;
        default:
            break;
    }
    [lblManglik setText:[NSString stringWithFormat:@" %@ ",strStatus]];
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
-(void)selectedLocation:(Location *)location andUpdateFlag:(BOOL)flag
{
    //[arrSelectedLocationId removeAllObjects];
    lblLocation.text = @"";
    if (location)
    {
        if(flag)
        {
            [arrLocationObj addObject:location];
        }
        PFObject *objLoc  = location.cityPointer;
        if ([objLoc.parseClassName isEqualToString:@"City"])
        {
            [arrSelLocations addObject:location.city];
        }
        else
        {
            [arrSelLocations addObject:location.state];
        }
        
        [arrSelectedLocationId addObject:location];
    }
    NSString *strLocations = [arrSelLocations componentsJoinedByString:@","];
    [popoverController dismissPopoverAnimated:YES];
    lblLocation.text = strLocations;
}


-(void)selectedLocationArray:(NSArray *)locationArray andUpdateFlag:(BOOL)flag
{
    [arrSelectedLocationId removeAllObjects];
    [arrSelLocations removeAllObjects];
    
    lblLocation.text = @"";
    if (locationArray.count > 0)
    {
        arrLocationObj = [locationArray mutableCopy];
        if(flag)
        {
            //[arrLocationObj addObject:location];
        }
        for (Location *location in locationArray) {
            PFObject *objLoc  = location.cityPointer;
            if ([objLoc.parseClassName isEqualToString:@"City"])
            {
                [arrSelLocations addObject:location.city];
            }
            else
            {
                [arrSelLocations addObject:location.state];
            }
            
            [arrSelectedLocationId addObject:location];
        }
        NSString *strLocations = [arrSelLocations componentsJoinedByString:@","];
        lblLocation.text = strLocations;
    }
    else
    {
        lblLocation.text = @"Select Location";
        [arrLocationObj removeAllObjects];
    }
    
    
    //dismiss popover
    [popoverController dismissPopoverAnimated:YES];
}

- (void)showSelLocations : (NSArray *)arrLocation
{
    [self selectedLocation:nil andUpdateFlag:NO];
}

//set Locations From Parse
-(void)showSelectedLocation:(NSArray *)arrLocation
{
    //[arrLocationObj removeAllObjects];
    [arrSelectedLocationId removeAllObjects];
    [arrSelLocations removeAllObjects];
    lblLocation.text = @"";
//    if (location)
//    {
//        [arrSelLocations addObject:location.city];
//        [arrSelectedLocationId addObject:location.placeId];
//    }
//    NSString *strLocations = [arrSelLocations componentsJoinedByString:@","];
//    [popoverController dismissPopoverAnimated:YES];
//    lblLocation.text = strLocations;
    
    //new code
    //NSMutableArray *arrLoc = [[NSMutableArray alloc] init];
    for (Location *obj in arrLocation)
    {
        [self selectedLocation:obj andUpdateFlag:NO];
//        NSString *strLoc = obj.city;
//        [arrLoc addObject:strLoc];
//        [arrSelLocations addObject:obj.city];
//        [arrSelectedLocationId addObject:obj.placeId];
    }
    //[arrLocationObj removeAllObjects];
//    NSString *strLoc = [arrLoc componentsJoinedByString:@","];
//    [popoverController dismissPopoverAnimated:YES];
//    lblLocation.text = strLoc;
}

#pragma mark Degree Preference
-(void)showSelDegree:(NSArray *)arrDegree
{
    [arrSelectedDegreeId removeAllObjects];
    [arrDegreeObject removeAllObjects];
    arrSelDegree = arrDegree;
    lblDegree.text = @"";
    NSMutableArray *arrDeg = [[NSMutableArray alloc] init];
    for (Degree *obj in arrDegree)
    {
        NSString *strDeg;
        PFObject *degreeObject = obj.objectPointer;
        if ([degreeObject.parseClassName isEqualToString:@"Degree"])
        {
            strDeg = obj.objectName;
        }
        else if ([degreeObject.parseClassName isEqualToString:@"DegreeType"])
        {
            strDeg = obj.objectType;
        }
        
        [arrDeg addObject:strDeg];
        [arrSelectedDegreeId addObject:obj.objectId];
        [arrDegreeObject addObject:obj];
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

#pragma mark Check Budget Visiblity
#pragma mark User Profile Pic
-(void) checkBudgetVisiblity
{
    //get user profile pic
    PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
    [query whereKey:@"objectId" equalTo:[[NSUserDefaults standardUserDefaults]valueForKey:@"currentProfileId"]];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
         if (!error)
         {
             // The find succeeded.
             PFObject *obj= objects[0];
             //lblUserName.text = [obj valueForKey:@"isBudgetVisible"];
             
             int visibleFlag = [obj[@"isBudgetVisible"] intValue];
             if (visibleFlag == 1)
             {
                //show budget option
                 lblBudget.hidden = NO;
                 txtMaxBudget.hidden = NO;
                 txtminBudget.hidden = NO;
             }
             else
             {
                 //hide budget option
                 lblBudget.hidden = YES;
                 txtMaxBudget.hidden = YES;
                 txtminBudget.hidden = YES;
             }
         }
     }];
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
        LocationPreferencePopoverVC *controller = segue.destinationViewController;
        controller.arrSelectedData = arrSelectedLocationId;
        //controller.contentSizeForViewInPopover = CGSizeMake(310, 300);
        controller.preferredContentSize = CGSizeMake(310,300);
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
        controller.arrTableData = arrLocationObj;
        //controller.contentSizeForViewInPopover = CGSizeMake(310, 300);
        controller.preferredContentSize = CGSizeMake(310,300);
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
        controller.contentSizeForViewInPopover = CGSizeMake(300, 190);
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
        controller.contentSizeForViewInPopover = CGSizeMake(300, 190);
        WYStoryboardPopoverSegue* popoverSegue = (WYStoryboardPopoverSegue*)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender
                                             permittedArrowDirections:WYPopoverArrowDirectionAny
                                                             animated:YES];
        popoverController.popoverLayoutMargins = UIEdgeInsetsMake(4, 4, 4, 4);
        popoverController.delegate = self;
        controller.delegate = self;
        
    }
    
    else if ([segue.identifier isEqualToString:@"multiLocationIdentifier"])
    {
        //MultiSelectController *multiSelect =[self.storyboard instantiateViewControllerWithIdentifier:@"MultiSelectController"];
        MultiSelectController *multiSelect = [segue destinationViewController];
        multiSelect.delegate = self;
        multiSelect.multiSelectCellBackgroundColor =[UIColor colorWithRed:253.0/255.0 green:72.0/255.0 blue:47.0/255.0 alpha:1.0];
        
        NSMutableArray *arrOptions =[[NSMutableArray alloc] initWithArray:@[@"India",@"United States",@"Canada",@"Australia",@"United Kingdom",@"Philippines",@"Japan",@"Italy",@"Germany",@"Russia",@"Malaysia",@"France",@"Sweden",@"New Zealand",@"Singapore"]];
        
        multiSelect.arrOptions =arrOptions;
        
        multiSelect.leftButtonText = @"Cancel";
        multiSelect.leftButtonTextColor = [UIColor blackColor];
        
        multiSelect.rightButtonText = @"Apply";
        multiSelect.rightButtonTextColor = [UIColor blackColor];
        
        UINavigationController *navi =[[UINavigationController alloc] initWithRootViewController:multiSelect];
        
        [self.navigationController presentViewController:navi animated:YES completion:^{
            
            
        }];
    }
}

#pragma mark ShowActivityIndicator

-(void)showLoader{
    activityIndicator.hidden = NO;
    [activityIndicator startAnimating];
    txtMinAge.enabled = NO;
    txtMaxAge.enabled = NO;
    txtIncome.enabled = NO;
    txtminBudget.enabled = NO;
    txtMaxBudget.enabled = NO;
    btnLocation.enabled = NO;
    btnMinHeight.enabled = NO;
    btnMaxHeight.enabled = NO;
}

-(void)hideLoader
{
    activityIndicator.hidden = YES;
    [activityIndicator stopAnimating];
    txtMinAge.enabled = YES;
    txtMaxAge.enabled = YES;
    txtIncome.enabled = YES;
    txtminBudget.enabled = YES;
    txtMaxBudget.enabled = YES;
    btnLocation.enabled = YES;
    btnMinHeight.enabled = YES;
    btnMaxHeight.enabled = YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"preference delegate method called");
}

#pragma mark - Notification
-(void)saveData:(NSNotification *)notification
{
    [self setPreferences:nil];
}
@end
