//
//  BasicProfileViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 10/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "BasicProfileViewController.h"
#import "WYPopoverController.h"
#import "PopOverListViewController.h"
#import "WYStoryboardPopoverSegue.h"
#import "DateOfBirthPopoverViewController.h"
#import "BirthTimePopoverViewController.h"
#import "GenderViewController.h"
@interface BasicProfileViewController ()<PopOverListViewControllerDelegate,DateOfBirthPopoverViewControllerDelegate,BirthTimePopoverViewControllerDelegate,GenderViewControllerDelegate,WYPopoverControllerDelegate>{
    __weak IBOutlet UIButton *btnBirthTime;
    __weak IBOutlet UIButton *btnPlaceOfBirth;
    __weak IBOutlet UIButton *btnCurrentLocation;
    __weak IBOutlet UIButton *btnDateOfBirth;
    __weak IBOutlet UIButton *btnGender;
    WYPopoverController* popoverController;
    __weak IBOutlet UITextField *txtFullName;
    NSString *selectedGender;
    NSDate *selectedDate;
    NSDate *selectedBirthTime;
    NSString *selectedHeight;
    BOOL isSelectingCurrentLocation;

}

@end

@implementation BasicProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.currentProfile ==nil){
        NSString *userId = @"m2vi20vsi4";
        PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
        
        [query whereKey:@"userId" equalTo:userId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                PFObject *obj = objects[0];
                self.currentProfile = obj;
                [self updateUserInfo];
            }
        }];

    }
    
//    PFObject *city = [PFObject objectWithClassName:@"City"];
//    [city setObject:@"indore" forKey:@"name"];
//    [city save];
//    PFObject *city2 = [PFObject objectWithClassName:@"City"];
//    [city2 setObject:@"bhopal" forKey:@"name"];
//    [city2 save];
//
//    // now we create a book object
//    PFObject *state= [PFObject objectWithClassName:@"State"];
//    [state setObject:@"Madhay Pradesh" forKey:@"name"];
//    PFObject *counrty = [PFObject objectWithClassName:@"Country"];
//    [counrty setObject:@"India" forKey:@"name"];
//    [counrty save];
//    // now let’s associate the authors with the book
//    // remember, we created a "authors" relation on Book
//    PFRelation *relation = [state relationForKey:@"City"];
//    
//    [relation addObject:city];
//    [relation addObject:city2];
//    [state save];
//
//    PFRelation *countryStateRel = [counrty relationForKey:@"State"];
//    PFRelation *countryCityRel = [counrty relationForKey:@"City"];
//    [countryCityRel addObject:city];
//    [countryCityRel addObject:city2];
//
//    [countryStateRel addObject:state];
//    [counrty saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                if (!error) {
//                    //The registration was succesful, go to the wall
//                    [self performSegueWithIdentifier:@"SignupSuccesful" sender:self];
//        
//                } else {
//                    //Something bad has ocurred
//                    NSString *errorString = [[error userInfo] objectForKey:@"error"];
//                    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                    [errorAlertView show];
//                }
//            }];
//

       // Do any additional setup after loading the view.
}
-(void)updateUserInfo{
    NSDate *dob  =[self.currentProfile valueForKey:@"dob"];
    if(dob){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"dd/MM/yyyy";
        selectedDate =[self.currentProfile valueForKey:@"dob"];
        NSString *dateString = [dateFormatter stringFromDate: [self.currentProfile valueForKey:@"dob"]];
        [btnDateOfBirth setTitle:[NSString stringWithFormat:@"%@",dateString] forState:UIControlStateNormal];
        [btnDateOfBirth setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    if([self.currentProfile valueForKey:@"tob"]){
        selectedBirthTime =[self.currentProfile valueForKey:@"tob"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"HH:mm";
        
        NSString *dateString = [dateFormatter stringFromDate: [self.currentProfile valueForKey:@"tob"]];
        [btnBirthTime setTitle:[NSString stringWithFormat:@"%@",dateString] forState:UIControlStateNormal];
        [btnBirthTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    if([self.currentProfile valueForKey:@"gender"]){
        selectedGender=[self.currentProfile valueForKey:@"gender"];
        [btnGender setTitle:[NSString stringWithFormat:@"%@",[self.currentProfile valueForKey:@"gender"]] forState:UIControlStateNormal];
        [btnGender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    if([self.currentProfile valueForKey:@"name"]){
        txtFullName.text = [self.currentProfile valueForKey:@"name"];
    }
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.view endEditing:YES];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"LocationIdentifier"])
    {isSelectingCurrentLocation = YES;
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
    if ([segue.identifier isEqualToString:@"GenderIdentifier"]){
        GenderViewController *controller = segue.destinationViewController;
        controller.contentSizeForViewInPopover = CGSizeMake(200 , 100);
        WYStoryboardPopoverSegue* popoverSegue = (WYStoryboardPopoverSegue*)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender
                                             permittedArrowDirections:WYPopoverArrowDirectionAny
                                                             animated:YES];
        controller.delegate = self;
        popoverController.popoverLayoutMargins = UIEdgeInsetsMake(4, 4, 4, 4);
        popoverController.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"DateOfBirthPickerIdentifier"]){
        DateOfBirthPopoverViewController *controller = segue.destinationViewController;
        controller.contentSizeForViewInPopover = CGSizeMake(300 , 220);
        WYStoryboardPopoverSegue* popoverSegue = (WYStoryboardPopoverSegue*)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender
                                             permittedArrowDirections:WYPopoverArrowDirectionAny
                                                             animated:YES];
        controller.delegate = self;
        popoverController.popoverLayoutMargins = UIEdgeInsetsMake(4, 4, 4, 4);
        popoverController.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"PlaceOfBirthLocationIdentifier"])
    {isSelectingCurrentLocation = NO;
        DateOfBirthPopoverViewController *controller = segue.destinationViewController;
        controller.contentSizeForViewInPopover = CGSizeMake(310, 400);
        WYStoryboardPopoverSegue* popoverSegue = (WYStoryboardPopoverSegue*)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender
                                             permittedArrowDirections:WYPopoverArrowDirectionAny
                                                             animated:YES];
        popoverController.popoverLayoutMargins = UIEdgeInsetsMake(4, 4, 4, 4);
        popoverController.delegate = self;
        controller.delegate = self;
        
    }
       if ([segue.identifier isEqualToString:@"BirthTimePopover"])
    {isSelectingCurrentLocation = NO;
        BirthTimePopoverViewController *controller = segue.destinationViewController;
        controller.contentSizeForViewInPopover = CGSizeMake(310, 222);
        WYStoryboardPopoverSegue* popoverSegue = (WYStoryboardPopoverSegue*)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender
                                             permittedArrowDirections:WYPopoverArrowDirectionAny
                                                             animated:YES];
        popoverController.popoverLayoutMargins = UIEdgeInsetsMake(4, 4, 4, 4);
        popoverController.delegate = self;
        controller.delegate = self;
        
    }
    
    
}
#pragma mark PopoverDelegates

-(void)selectedDateOfBirth:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MM/dd/yy";
    
    NSString *dateString = [dateFormatter stringFromDate: date];
    selectedDate = date;
    [btnDateOfBirth setTitle:[NSString stringWithFormat:@"%@",dateString] forState:UIControlStateNormal];
    
    [btnDateOfBirth setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [popoverController dismissPopoverAnimated:YES];
}
-(void)selectedBirthTime:(NSDate *)time{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"HH:mm";
    
    NSString *dateString = [dateFormatter stringFromDate: time];
    selectedBirthTime = time;
    [btnBirthTime setTitle:[NSString stringWithFormat:@"%@",dateString] forState:UIControlStateNormal];
    
    [btnBirthTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [popoverController dismissPopoverAnimated:YES];
    
}
-(void)selectedGender:(NSString *)gender{
    selectedGender = gender;
    [btnGender setTitle:gender forState:UIControlStateNormal];
    [btnGender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [popoverController dismissPopoverAnimated:YES];
}
-(void)selectedLocation:(Location *)location{
    if(isSelectingCurrentLocation){
       // currentLocation = location;
        [btnCurrentLocation setTitle:location.descriptions forState:UIControlStateNormal];
        [btnCurrentLocation setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [popoverController dismissPopoverAnimated:YES];
    }
    else{
       // placeOfBirthLocation = location;
        [btnPlaceOfBirth setTitle:location.descriptions forState:UIControlStateNormal];
        [btnPlaceOfBirth setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [popoverController dismissPopoverAnimated:YES];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.currentProfile setObject:txtFullName.text forKey:@"name"];
    [self.currentProfile setObject:selectedDate forKey:@"dob"];
    [self.currentProfile setObject:selectedGender forKey:@"gender"];
    [self.currentProfile setObject:selectedBirthTime forKey:@"tob"];

    [self.delegate updatedPfObject:self.currentProfile];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
