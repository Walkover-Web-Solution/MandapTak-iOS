//
//  ProfileWorkAndExperienceViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 14/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "ProfileWorkAndExperienceViewController.h"
#import "WYPopoverController.h"
#import "TextFieldTableViewCell.h"
#import "DegreeTableViewCell.h"
#import "DateOfBirthPopoverViewController.h"
#import "DegreePopoverForProfileViewController.h"
#import "Education.h"
#import "WorkAfterMarriagePopoverViewController.h"
#import "IndustryPopoverViewController.h"
#import "Constants.h"
#import "SpecialisationPopoverViewController.h"
@interface ProfileWorkAndExperienceViewController ()<WYPopoverControllerDelegate,UITableViewDelegate,DegreePopoverForProfileViewControllerDelegate,UITextFieldDelegate,WorkAfterMarriagePopoverViewControllerDelegate,IndustryPopoverViewControllerDelegate,SpecialisationPopoverViewControllerDelegate>{
    WYPopoverController *settingsPopoverController;
    NSInteger numberOfRowsInEducationSection;
    NSMutableArray *arrEducationData;
    NSString *selectedDesignation;
    NSString *selectedIncome;
    NSString *selectedCompany;
    PFObject *selectedIndustry;
    NSString *selectedWorkAfterMarraige;
    CGRect industryCellRect;
    CGRect marraigeCellRect;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btn;
- (IBAction)testButtonAction:(id)sender;
@end

@implementation ProfileWorkAndExperienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrEducationData = [NSMutableArray array];
    Education *education = [[Education alloc]init];
    [arrEducationData addObject:education];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    numberOfRowsInEducationSection = 1;

    if(IS_IPHONE_5){
        self.heightConstraint.constant = 400;

    }
    else if(IS_IPHONE_6){
        self.heightConstraint.constant = 499;

    }
    else if(IS_IPHONE_6PLUS){
        self.heightConstraint.constant = 568;

    }
    else if(IS_IPHONE){
        self.heightConstraint.constant = 312;
        
    }
    if(self.currentProfile ==nil){
        NSString *userId = @"m2vi20vsi4";
        PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
        
        [query whereKey:@"userId" equalTo:userId];
        [query includeKey:@"currentLocation.Parent.Parent"];
        [query includeKey:@"placeOfBirth.Parent.Parent"];
        [query includeKey:@"casteId.Parent.Parent"];
        [query includeKey:@"religionId.Parent.Parent"];
        [query includeKey:@"gotraId.Parent.Parent"];
        [query includeKey:@"education1.degreeId"];
        [query includeKey:@"education2.degreeId"];
        [query includeKey:@"education3.degreeId"];
        [query includeKey:@"industryId"];

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
-(void)updateUserInfo{
   
    if(![[self.currentProfile valueForKey:@"designation"] isKindOfClass: [NSNull class]]){
        selectedDesignation  = [self.currentProfile valueForKey:@"designation"];
    }
    if(![[self.currentProfile valueForKey:@"industryId"] isKindOfClass: [NSNull class]]){
        selectedIndustry  = [self.currentProfile valueForKey:@"industryId"];
    }
    if(![[self.currentProfile valueForKey:@"company"] isKindOfClass: [NSNull class]]){
        selectedCompany  = [self.currentProfile valueForKey:@"company"];
    }
    if(![[self.currentProfile valueForKey:@"package"] isKindOfClass: [NSNull class]]){
        selectedIncome = [NSString stringWithFormat:@"%@",[self.currentProfile valueForKey:@"package"] ] ;
    }
    if(![[self.currentProfile valueForKey:@"education1"] isKindOfClass: [NSNull class]]){
        Education *education1 =arrEducationData[0];
        education1.specialisation= [self.currentProfile valueForKey:@"education1"];
        PFObject * deg = [education1.specialisation valueForKey:@"degreeId"];
        education1.degree = deg;

        if(![[self.currentProfile valueForKey:@"education2"] isKindOfClass: [NSNull class]]){
            if(arrEducationData.count==2){
                Education *education2 =arrEducationData[0];
                education2.specialisation= [self.currentProfile valueForKey:@"education2"];
                PFObject * deg = [education2.specialisation valueForKey:@"degreeId"];
                education2.degree = deg;
                
            }
            else {
                Education *education2 =[[Education alloc]init];
                education2.specialisation= [self.currentProfile valueForKey:@"education2"];
                PFObject * deg = [education2.specialisation valueForKey:@"degreeId"];
                education2.degree = deg;
                [arrEducationData addObject:education2];
            }
        }
        if(![[self.currentProfile valueForKey:@"education3"] isKindOfClass: [NSNull class]]){
            if(arrEducationData.count==3){
                Education *education3 =arrEducationData[0];
                education3.specialisation= [self.currentProfile valueForKey:@"education3"];
                PFObject * deg = [education3.specialisation valueForKey:@"degreeId"];
                education3.degree = deg;

            }
            else {
                Education *education3 =[[Education alloc]init];
                education3.specialisation= [self.currentProfile valueForKey:@"education3"];
                PFObject * deg = [education3.specialisation valueForKey:@"degreeId"];
                education3.degree = deg;
                [arrEducationData addObject:education3];
            }
        }

    }
    if(![[self.currentProfile valueForKey:@"workAfterMarriage"] isKindOfClass: [NSNull class]]){
        int type  = [[self.currentProfile valueForKey:@"workAfterMarriage"] intValue];
        if(type==0)
            selectedWorkAfterMarraige = @"No";
        else if (type==1)
            selectedWorkAfterMarraige = @"Yes";
        else if (type ==2)
            selectedWorkAfterMarraige = @"May be";

    }
    numberOfRowsInEducationSection = arrEducationData.count;
    [self.tableView reloadData];

}
#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            return numberOfRowsInEducationSection;
            break;
        case 2:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}



- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"NormalCell";
    UITableViewCell *normalCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    static NSString *cellIdentifier2 = @"TextFieldTableViewCell";
    TextFieldTableViewCell *txtFldCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
    
    static NSString *cellIdentifier3 = @"DegreeTableViewCell";
    DegreeTableViewCell *degCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
    
    if (!normalCell) {
        normalCell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        [normalCell setBackgroundColor:[UIColor clearColor]];
        normalCell.textLabel.textColor = [UIColor lightGrayColor];
        normalCell.textLabel.font = [UIFont preferredFontForTextStyle:@"Light"];
        normalCell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        normalCell.detailTextLabel.font = [UIFont preferredFontForTextStyle:@"Light"];
        normalCell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
        normalCell.detailTextLabel.textColor = [UIColor blackColor];

    }
    normalCell.selectionStyle = UITableViewCellSelectionStyleNone;
    txtFldCell.selectionStyle = UITableViewCellSelectionStyleNone;

    degCell.selectionStyle = UITableViewCellSelectionStyleNone;
    Education * education;
    if(arrEducationData.count==indexPath.row+1){
        education =arrEducationData[indexPath.row];

    }
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];

    txtFldCell.txtField.delegate = self;
    switch (indexPath.section) {
            
        case 0:
            switch (indexPath.row) {
                case 0:
                    industryCellRect = [tableView rectForRowAtIndexPath:indexPath];
                    if(selectedIndustry){
                        normalCell.textLabel.text = [selectedIndustry valueForKey:@"name"];
                        normalCell.textLabel.textColor = [UIColor blackColor];
                        
                    }
                    else
                        normalCell.detailTextLabel.text=@"";

                        normalCell.textLabel.text = @"Industry";
                    return normalCell;
                    //Normal Cell for Industry Selction
                    break;
                case 1:
                    txtFldCell.txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Current Designation" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
                    if(selectedDesignation){
                        txtFldCell.txtField.text = selectedDesignation;
                    }
                    txtFldCell.txtField.tag = 1;
                    //Text Field cell for designation
                    return txtFldCell;
                    break;
                    
                case 2:
                    txtFldCell.txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Company" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
                    txtFldCell.txtField.tag = 2;
                    if(selectedCompany){
                        txtFldCell.txtField.text = selectedCompany;
                    }
                    return txtFldCell;

                    //Text Field cell for company
                    break;
                    
                case 3:
                    //Text Field cell for current incomw
                    txtFldCell.txtField.tag = 3;
                    [txtFldCell.txtField setKeyboardType:UIKeyboardTypeNumberPad];
                    if(selectedIncome){
                        txtFldCell.txtField.text = selectedIncome;
                    }
                       txtFldCell.txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Current Income" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
                    numberToolbar.barStyle = UIBarStyleDefault;
                    //    numberToolbar.items = [NSArray arrayWithObjects:
                    //                           [[UIBarButtonItem alloc]initWithTitle:@"Hide" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                    //                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                    //                           nil];
                    numberToolbar.items = [NSArray arrayWithObjects:
                                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPad)],
                                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                           nil];
                    
                    
                    [numberToolbar sizeToFit];
                    txtFldCell.txtField.inputAccessoryView = numberToolbar;

                    return txtFldCell;
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    // Degree cell
                    degCell.separatorInset = UIEdgeInsetsMake(0.f, degCell.bounds.size.width, 0.f, 0.f);

                    degCell.btnDegree.tag = indexPath.row;
                    degCell.btnSpecialisation.tag = indexPath.row;

                    [degCell.btnDegree addTarget:self action:@selector(degreeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    [degCell.btnSpecialisation addTarget:self action:@selector(specialisationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                     [degCell.btnMore addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    education =arrEducationData[indexPath.row];
                    if(education.degree){
                        [degCell.btnDegree setTitle:[education.degree valueForKey:@"name"] forState:UIControlStateNormal];
                        [degCell.btnDegree  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        [degCell.btnSpecialisation setTitle:[education.specialisation valueForKey:@"name"] forState:UIControlStateNormal];
                        [degCell.btnSpecialisation  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }

                    if(indexPath.row ==numberOfRowsInEducationSection-1 ){
                        degCell.btnMore.hidden = NO;
                    }
                    else{
                        degCell.btnMore.hidden = YES;

                    }
                    
                    return degCell;
                    break;
                default:
                    degCell.separatorInset = UIEdgeInsetsMake(0.f, degCell.bounds.size.width, 0.f, 0.f);

                    degCell.btnDegree.tag = indexPath.row;
                    degCell.btnSpecialisation.tag = indexPath.row;
                    [degCell.btnDegree addTarget:self action:@selector(degreeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    [degCell.btnSpecialisation addTarget:self action:@selector(specialisationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    [degCell.btnMore addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    degCell.btnMore.hidden = YES;
                    if(indexPath.row ==numberOfRowsInEducationSection-1 ){
                        degCell.btnMore.hidden = NO;
                    }
                    else{
                        degCell.btnMore.hidden = YES;
                        
                    }
                    Education * education =arrEducationData[indexPath.row];
                    if(education.degree){
                        [degCell.btnDegree setTitle:[education.degree valueForKey:@"name"] forState:UIControlStateNormal];
                        [degCell.btnDegree  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        [degCell.btnSpecialisation setTitle:[education.specialisation valueForKey:@"name"] forState:UIControlStateNormal];
                        [degCell.btnSpecialisation  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }
                    
                    // cell with more education field
                    return degCell;

                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                  
                    // normal cell Deg sel
                   marraigeCellRect = [tableView rectForRowAtIndexPath:indexPath];

                    if(selectedWorkAfterMarraige){
                        normalCell.textLabel.text = @"Work after Marriage:";
                        normalCell.detailTextLabel.text =selectedWorkAfterMarraige;
                        normalCell.textLabel.textColor = [UIColor blackColor];
                    }
                    else
                        normalCell.textLabel.text = @"Work after marraige?";

                    return normalCell;
                    break;
                default:
                    break;
            }
            break;

            
            
        default:
            break;
            
    }
        return normalCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            if(indexPath.row==0){
                [self selectIndustry];
            }
            break;
        case 2:
            if(indexPath.row==0){
                [self selectWorkAfterMarriage];
            }
            break;
            

        default:
            break;
    }
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSString *sectionName;
//    switch (section)
//    {
//        case 0:
//            sectionName = NSLocalizedString(@"Work", @"Work");
//            break;
//        case 1:
//            sectionName = NSLocalizedString(@"Education", @"Education");
//            break;
//            // ...
//        case 2:
//            sectionName = NSLocalizedString(@" ", @" ");
//            break;
//        default:
//            sectionName = @"";
//            break;
//    }
//    return sectionName;
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    /* Section header is in 0th index... */
   // [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor whiteColor]]; //your background color...
    label.textColor = [[UIColor lightGrayColor]colorWithAlphaComponent:.5f];
    NSString *sectionName;
    switch (section)
    {
        case 0:
            label.text = NSLocalizedString(@"Work", @"Work");
            break;
        case 1:
            label.text = NSLocalizedString(@"Education", @"Education");
            break;
            // ...
        case 2:
            label.text = NSLocalizedString(@" ", @" ");
            break;
        default:
            label.text = @"";
            break;
    }

    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section)
    {
        case 0:
            return 45;

            break;
        case 1:
            return 114;
            break;
            // ...
        default:
            return 45;

            break;
    }

}

-(void)degreeButtonAction:(id)sender{
    [self.view endEditing:YES];
   [settingsPopoverController dismissPopoverAnimated:YES];
    NSLog(@"%ld",(long)[sender tag]);
    UIView *btn = (UIView *)sender;
    
    DegreePopoverForProfileViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DegreePopoverForProfileViewController"];
    viewController.preferredContentSize = CGSizeMake(310, 280);
    viewController.delegate = self;
    viewController.title = @"Select Degree";
    viewController.btnTag = [sender tag];
       viewController.modalInPopover = NO;
    viewController.arrEducation = arrEducationData;
    UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:viewController];

    settingsPopoverController = [[WYPopoverController alloc]initWithContentViewController:contentViewController];
    settingsPopoverController.delegate = self;
    // settingsPopoverController.passthroughViews = @[btn];
    //settingsPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    settingsPopoverController.wantsDefaultContentAppearance = NO;
    
           [settingsPopoverController presentPopoverFromRect:btn.bounds
                                                   inView:btn
                                 permittedArrowDirections:WYPopoverArrowDirectionAny
                                                 animated:YES
                                                  options:WYPopoverAnimationOptionFadeWithScale];
    }
-(void)specialisationButtonAction:(id)sender{
    [self.view endEditing:YES];
     Education *education = [arrEducationData objectAtIndex:[sender tag]];
    if(education.degree !=nil){
        [settingsPopoverController dismissPopoverAnimated:YES];
        NSLog(@"%ld",(long)[sender tag]);
        UIView *btn = (UIView *)sender;
        
        SpecialisationPopoverViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SpecialisationPopoverViewController"];
        viewController.preferredContentSize = CGSizeMake(310, 280);
        viewController.delegate = self;
        viewController.title = @"Select Specialization";
        viewController.btnTag = [sender tag];
        viewController.modalInPopover = NO;
        viewController.selectedDegree = education.degree;
        UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        settingsPopoverController = [[WYPopoverController alloc]initWithContentViewController:contentViewController];
        settingsPopoverController.delegate = self;
        // settingsPopoverController.passthroughViews = @[btn];
        //settingsPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
        settingsPopoverController.wantsDefaultContentAppearance = NO;
        
        [settingsPopoverController presentPopoverFromRect:btn.bounds
                                                   inView:btn
                                 permittedArrowDirections:WYPopoverArrowDirectionAny
                                                 animated:YES
                                                  options:WYPopoverAnimationOptionFadeWithScale];
    }
    else{
        NSString *message  = [NSString stringWithFormat:@"Please select Degree %ld",(long)[sender tag]+1];
        UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"Opps!!" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

-(void)moreButtonAction:(id)sender{
    Education *education = [arrEducationData objectAtIndex:[sender tag]];
    if(education.specialisation !=nil){
        NSLog(@"%ld",(long)[sender tag]);
        if(numberOfRowsInEducationSection<3){
            Education *education = [[Education alloc]init];
            [arrEducationData addObject:education];
            numberOfRowsInEducationSection ++;
            
        }
        [self.tableView reloadData];
        NSIndexPath *index = [NSIndexPath indexPathForRow:numberOfRowsInEducationSection-1 inSection:1];
        [self.tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    else {
        UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"Opps!!" message:@"Select Degree and Specialization first." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
   }

#pragma mark PopoverDelegates
-(void)selectedIndustry:(PFObject *)industry{
    selectedIndustry = industry;
    [self.tableView reloadData];
    [settingsPopoverController dismissPopoverAnimated:YES];

}
-(void)selectedDegree:(PFObject *)degree andSpecialization:(PFObject *)specialization forTag:(NSInteger)tag{
    Education *education = [arrEducationData objectAtIndex:tag];
    education.degree = degree;
    education.specialisation = specialization;
    [arrEducationData replaceObjectAtIndex:tag withObject:education];
    [self.tableView reloadData];
    [settingsPopoverController dismissPopoverAnimated:YES];

}
-(void)selectedDegree:(PFObject *)degree forTag:(NSInteger)tag{
    Education *education = [arrEducationData objectAtIndex:tag];
    education.degree = degree;
    [arrEducationData replaceObjectAtIndex:tag withObject:education];
    PFQuery *query = [PFQuery queryWithClassName:@"Specialization"];
    [query whereKey:@"degreeId" equalTo:education.degree];
    //[query whereKey:@"name" matchesRegex:[NSString stringWithFormat:@"(?i)^%@",searchBar.text]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        if(comments.count ==1){
            PFObject *specialization = [comments objectAtIndex:0];
            education.specialisation = specialization;
        }
        [self.tableView reloadData];
    }];

    [self.tableView reloadData];
    [settingsPopoverController dismissPopoverAnimated:YES];
}
-(void)selectedMarraigeType:(NSString *)marraigeType{
    selectedWorkAfterMarraige = marraigeType;
    [self.tableView reloadData];
    [settingsPopoverController dismissPopoverAnimated:YES];

}
#pragma mark UITextFeildDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    switch (textField.tag) {
        case 1:
            selectedDesignation = textField.text;
            break;
        case 2:
            selectedCompany = textField.text;
            break;
        case 3:
            selectedIncome = textField.text;
            break;

        default:
            break;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

-(void)cancelNumberPad{
    [self.view endEditing:YES];

}
#pragma mark ShowPopover
-(void)selectIndustry{
    [self.view endEditing:YES];
    [settingsPopoverController dismissPopoverAnimated:YES];
    
    IndustryPopoverViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IndustryPopoverViewController"];
    viewController.preferredContentSize = CGSizeMake(310, 200);
    viewController.delegate = self;
    viewController.title = @"Select Industry";
    viewController.modalInPopover = NO;
    
   // UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    settingsPopoverController = [[WYPopoverController alloc]initWithContentViewController:viewController];
    settingsPopoverController.delegate = self;
    //settingsPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    settingsPopoverController.wantsDefaultContentAppearance = NO;
    
    [settingsPopoverController presentPopoverFromRect:industryCellRect
                                               inView:self.tableView
                             permittedArrowDirections:WYPopoverArrowDirectionAny
                                             animated:YES
                                              options:WYPopoverAnimationOptionFadeWithScale];
//    [settingsPopoverController presentPopoverAsDialogAnimated:YES
//                                                      options:WYPopoverAnimationOptionFadeWithScale];
}
-(void)selectedSpecialization:(PFObject *)specialization forTag:(NSInteger)tag{
    Education *education = [arrEducationData objectAtIndex:tag];
    education.specialisation = specialization;
    [arrEducationData replaceObjectAtIndex:tag withObject:education];
    [self.tableView reloadData];
    [settingsPopoverController dismissPopoverAnimated:YES];
}

-(void)selectWorkAfterMarriage{
    [self.view endEditing:YES];
    [settingsPopoverController dismissPopoverAnimated:YES];
    WorkAfterMarriagePopoverViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WorkAfterMarriagePopoverViewController"];
    viewController.preferredContentSize = CGSizeMake(310, 200);
    viewController.delegate = self;
    viewController.title = @"Want to work after Marriage?";
    viewController.modalInPopover = NO;
    UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
    settingsPopoverController = [[WYPopoverController alloc]initWithContentViewController:contentViewController];
    settingsPopoverController.delegate = self;
    //settingsPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    settingsPopoverController.wantsDefaultContentAppearance = NO;
    [settingsPopoverController presentPopoverFromRect:marraigeCellRect
                                               inView:self.tableView
                             permittedArrowDirections:WYPopoverArrowDirectionAny
                                             animated:YES
                                              options:WYPopoverAnimationOptionFadeWithScale];

}

-(void)viewWillDisappear:(BOOL)animated{
    if(selectedWorkAfterMarraige){
        int type;
            if([selectedWorkAfterMarraige isEqual:@"No"])
                type=0;
            else if ([selectedWorkAfterMarraige isEqual:@"Yes"])
                type=1;
            else if ([selectedWorkAfterMarraige isEqual:@"May be"])
                type = 2;
        self.currentProfile[@"workAfterMarriage"] = @(type);
    }
     if(selectedIndustry)
        [self.currentProfile setObject:selectedIndustry forKey:@"industryId"];
    if(selectedDesignation)
        [self.currentProfile setObject:selectedDesignation forKey:@"designation"];

    if(selectedIncome)
         self.currentProfile[@"package"] = @([selectedIncome integerValue]);
     if(selectedDesignation)
        [self.currentProfile setObject:selectedDesignation forKey:@"placeOfWork"];
     if(selectedCompany)
        [self.currentProfile setObject:selectedCompany forKey:@"company"];
        for(Education *education in arrEducationData){
        if(education.specialisation!=nil){
            
            [self.currentProfile setObject:education.specialisation forKey:@"education"];
        }
    }
    for(int i =0;i<arrEducationData.count;i++){
        Education *education = arrEducationData[i];
        if(education.specialisation !=nil){
            [self.currentProfile setObject:education.specialisation forKey:[NSString stringWithFormat:@"education%d",i+1]];

        }
    }
    [self.delegate updatedPfObjectForThirdTab:self.currentProfile];

}
@end
