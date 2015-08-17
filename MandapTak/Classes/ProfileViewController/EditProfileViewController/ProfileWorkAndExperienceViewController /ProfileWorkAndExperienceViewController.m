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
@interface ProfileWorkAndExperienceViewController ()<WYPopoverControllerDelegate,UITableViewDelegate,DegreePopoverForProfileViewControllerDelegate,UITextFieldDelegate,WorkAfterMarriagePopoverViewControllerDelegate,IndustryPopoverViewControllerDelegate>{
    WYPopoverController *settingsPopoverController;
    NSInteger numberOfRowsInEducationSection;
    NSMutableArray *arrEducationData;
    NSString *selectedDesignation;
    NSString *selectedIncome;
    NSString *selectedCompany;
    NSString *selectedWorkAfterMarraige;
    CGRect industryCellRect;
    CGRect marraigeCellRect;
}
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

    }
    normalCell.selectionStyle = UITableViewCellSelectionStyleNone;
    txtFldCell.selectionStyle = UITableViewCellSelectionStyleNone;

    degCell.selectionStyle = UITableViewCellSelectionStyleNone;
    Education * education;
    if(arrEducationData.count==indexPath.row+1){
        education =arrEducationData[indexPath.row];

    }
    txtFldCell.txtField.delegate = self;
    switch (indexPath.section) {
            
        case 0:
            switch (indexPath.row) {
                case 0:
                    industryCellRect = [tableView rectForRowAtIndexPath:indexPath];

                    normalCell.textLabel.text = @"Industry";
                    return normalCell;
                    //Normal Cell for Industry Selction
                    break;
                case 1:
                    txtFldCell.txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Current Designation" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
                    txtFldCell.txtField.tag = 1;
                    //Text Field cell for designation
                    return txtFldCell;
                    break;
                    
                case 2:
                    txtFldCell.txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Company" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
                    txtFldCell.txtField.tag = 2;

                    return txtFldCell;

                    //Text Field cell for company
                    break;
                    
                case 3:
                    //Text Field cell for current incomw
                    txtFldCell.txtField.tag = 3;

                       txtFldCell.txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Current Income" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
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
                    [degCell.btnDegree addTarget:self action:@selector(specialisationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                     [degCell.btnMore addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    education =arrEducationData[indexPath.row];
                    if(education.degree){
                        [degCell.btnDegree setTitle:education.degree forState:UIControlStateNormal];
                        [degCell.btnDegree  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
                    degCell.btnDegree.tag = indexPath.row;
                    degCell.btnSpecialisation.tag = indexPath.row;
                    [degCell.btnDegree addTarget:self action:@selector(degreeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    [degCell.btnDegree addTarget:self action:@selector(specialisationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
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
                        [degCell.btnDegree setTitle:education.degree forState:UIControlStateNormal];
                        [degCell.btnDegree  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
                        normalCell.textLabel.text = @"Work after Marriage";
                        normalCell.detailTextLabel.text =selectedWorkAfterMarraige;
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
    viewController.preferredContentSize = CGSizeMake(320, 280);
    viewController.delegate = self;
    viewController.title = @"Select Degree";
    viewController.btnTag = [sender tag];
       viewController.modalInPopover = NO;
    
    UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:viewController];

    settingsPopoverController = [[WYPopoverController alloc]initWithContentViewController:contentViewController];
    settingsPopoverController.delegate = self;
    settingsPopoverController.passthroughViews = @[btn];
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
    NSLog(@"%ld",(long)[sender tag]);

}

-(void)moreButtonAction:(id)sender{
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

#pragma mark PopoverDelegates

-(void)selectedDegree:(NSString *)degree forTag:(NSInteger)tag{
    Education *education = [arrEducationData objectAtIndex:tag];
    education.degree = degree;
    [arrEducationData replaceObjectAtIndex:tag withObject:education];
    [self.tableView reloadData];
    [settingsPopoverController dismissPopoverAnimated:YES];
}
-(void)selectedMarraigeType:(NSString *)marraigeType{
    selectedWorkAfterMarraige = marraigeType;
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
#pragma mark ShowPopover
-(void)selectIndustry{
    [self.view endEditing:YES];
    [settingsPopoverController dismissPopoverAnimated:YES];
    
    IndustryPopoverViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IndustryPopoverViewController"];
    viewController.preferredContentSize = CGSizeMake(320, 200);
    viewController.delegate = self;
    viewController.title = @"Select Industry";
    viewController.modalInPopover = NO;
    
    UINavigationController *contentViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    settingsPopoverController = [[WYPopoverController alloc]initWithContentViewController:contentViewController];
    settingsPopoverController.delegate = self;
    //settingsPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
    settingsPopoverController.wantsDefaultContentAppearance = NO;
    
    [settingsPopoverController presentPopoverFromRect:industryCellRect
                                               inView:self.tableView
                             permittedArrowDirections:WYPopoverArrowDirectionAny
                                             animated:YES
                                              options:WYPopoverAnimationOptionFadeWithScale];

}
-(void)selectWorkAfterMarriage{
    [self.view endEditing:YES];
    [settingsPopoverController dismissPopoverAnimated:YES];
    WorkAfterMarriagePopoverViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WorkAfterMarriagePopoverViewController"];
    viewController.preferredContentSize = CGSizeMake(320, 200);
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
@end
