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
    Location * currentLocation;
    Location * placeOfBirthLocation;

}

@end

@implementation BasicProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.currentProfile ==nil){
        NSString *userId = @"m2vi20vsi4";
        PFQuery *query = [PFQuery queryWithClassName:@"Profile"];
        
        [query whereKey:@"userId" equalTo:userId];
        [query includeKey:@"currentLocation.Parent.Parent"];
        [query includeKey:@"placeOfBirth.Parent.Parent"];

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
    
}
-(void)updateUserInfo{
    NSDate *dob  =[self.currentProfile valueForKey:@"dob"];
    if(dob){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"dd/MM/yyyy";
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];

        selectedDate =[self.currentProfile valueForKey:@"dob"];
        NSString *dateString = [dateFormatter stringFromDate: [self.currentProfile valueForKey:@"dob"]];
        [btnDateOfBirth setTitle:[NSString stringWithFormat:@"%@",dateString] forState:UIControlStateNormal];
        [btnDateOfBirth setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    if([self.currentProfile valueForKey:@"tob"]){
        selectedBirthTime =[self.currentProfile valueForKey:@"tob"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"HH:mm";
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];

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
    if([self.currentProfile valueForKey:@"currentLocation"]){
        PFObject *obj  = [self.currentProfile valueForKey:@"currentLocation"];
            Location *location = [[Location alloc]init];
            NSLog(@"cityName %@",[obj valueForKey:@"name"]);
            PFObject *parent = [obj valueForKey:@"Parent"];
            location.city = [obj valueForKey:@"name"];
            location.cityPointer  = obj;
            location.placeId = [obj valueForKey:@"objectId"];
            NSLog(@"placeId ---- %@",[parent valueForKey:@"objectId"]);
            NSLog(@"StateName %@",[parent valueForKey:@"name"]);
            location.state = [parent valueForKey:@"name"];
            PFObject *subParent = [parent valueForKey:@"Parent"];
            NSLog(@"CountryName %@",[subParent valueForKey:@"name"]);
            location.country = [subParent valueForKey:@"name"];
            location.descriptions = [NSString stringWithFormat:@"%@, %@, %@",[obj valueForKey:@"name"],[parent valueForKey:@"name"],[subParent valueForKey:@"name"]];
            currentLocation = location;
        [btnCurrentLocation setTitle:[NSString stringWithFormat:@"%@",location.descriptions] forState:UIControlStateNormal];
        [btnCurrentLocation setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
    if([self.currentProfile valueForKey:@"placeOfBirth"]){
        PFObject *obj  = [self.currentProfile valueForKey:@"placeOfBirth"];
        Location *location = [[Location alloc]init];
        NSLog(@"cityName %@",[obj valueForKey:@"name"]);
        PFObject *parent = [obj valueForKey:@"Parent"];
        location.city = [obj valueForKey:@"name"];
        location.cityPointer  = obj;
        location.placeId = [obj valueForKey:@"objectId"];
        NSLog(@"placeId ---- %@",[parent valueForKey:@"objectId"]);
        NSLog(@"StateName %@",[parent valueForKey:@"name"]);
        location.state = [parent valueForKey:@"name"];
        PFObject *subParent = [parent valueForKey:@"Parent"];
        NSLog(@"CountryName %@",[subParent valueForKey:@"name"]);
        location.country = [subParent valueForKey:@"name"];
        location.descriptions = [NSString stringWithFormat:@"%@, %@, %@",[obj valueForKey:@"name"],[parent valueForKey:@"name"],[subParent valueForKey:@"name"]];
        placeOfBirthLocation = location;
        [btnPlaceOfBirth setTitle:[NSString stringWithFormat:@"%@",location.descriptions] forState:UIControlStateNormal];
        [btnPlaceOfBirth setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.view endEditing:YES];
if ([segue.identifier isEqualToString:@"LocationIdentifier"])
    {isSelectingCurrentLocation = YES;
        PopOverListViewController *controller = segue.destinationViewController;
        controller.preferredContentSize = CGSizeMake(310, 400);
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
        controller.preferredContentSize = CGSizeMake(200 , 100);
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
        controller.preferredContentSize = CGSizeMake(310 , 206);
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
        controller.preferredContentSize = CGSizeMake(310, 400);
        WYStoryboardPopoverSegue* popoverSegue = (WYStoryboardPopoverSegue*)segue;
        popoverController = [popoverSegue popoverControllerWithSender:sender
                                             permittedArrowDirections:WYPopoverArrowDirectionAny
                                                             animated:YES];
        popoverController.popoverLayoutMargins = UIEdgeInsetsMake(4, 4, 4, 4);
        popoverController.delegate = self;
        controller.delegate = self;
        
    }
       if ([segue.identifier isEqualToString:@"BirthTimePopover"])
    {
        BirthTimePopoverViewController *controller = segue.destinationViewController;
        controller.preferredContentSize = CGSizeMake(310, 222);
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
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];

    dateFormatter.dateFormat = @"HH:mm";

    NSString *dateString = [dateFormatter stringFromDate:time];
    selectedBirthTime = time;
    [btnBirthTime setTitle:[NSString stringWithFormat:@"%@",dateString] forState:UIControlStateNormal];
    [btnBirthTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [popoverController dismissPopoverAnimated:YES];
    
}

-(NSDate*)getLocaldateForDate:(NSDate*)date{
    NSDate *gmtDate  = [NSDate date];
    NSTimeInterval timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:gmtDate];
    return [gmtDate dateByAddingTimeInterval:-timeZoneOffset];

}
-(NSDate*)getGMTdateForDate:(NSDate*)date{
    NSDate *localDate = [NSDate date];
    NSTimeInterval timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:localDate];
    return [localDate dateByAddingTimeInterval:+timeZoneOffset]; // NOTE the "-" sign!
}

-(void)selectedGender:(NSString *)gender{
    selectedGender = gender;
    [btnGender setTitle:gender forState:UIControlStateNormal];
    [btnGender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [popoverController dismissPopoverAnimated:YES];
}
-(void)selectedLocation:(Location *)location{
    if(isSelectingCurrentLocation){
        currentLocation = location;
        [btnCurrentLocation setTitle:location.descriptions forState:UIControlStateNormal];
        [btnCurrentLocation setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [popoverController dismissPopoverAnimated:YES];
    }
    else{
        placeOfBirthLocation = location;
        [btnPlaceOfBirth setTitle:location.descriptions forState:UIControlStateNormal];
        [btnPlaceOfBirth setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [popoverController dismissPopoverAnimated:YES];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [self.currentProfile setObject:txtFullName.text forKey:@"name"];
    if(selectedDate)
        [self.currentProfile setObject:selectedDate forKey:@"dob"];
    if(selectedGender)
        [self.currentProfile setObject:selectedGender forKey:@"gender"];
    if(selectedBirthTime)
        [self.currentProfile setObject:selectedBirthTime forKey:@"tob"];
    if(currentLocation)
        [self.currentProfile setObject:currentLocation.cityPointer forKey:@"currentLocation"];
    if(placeOfBirthLocation)
        [self.currentProfile setObject:placeOfBirthLocation.cityPointer forKey:@"placeOfBirth"];
    NSLog(@"placeOfBirthLocation%@",placeOfBirthLocation.descriptions);
    NSLog(@"currentLocation%@",currentLocation.descriptions);

    [self.delegate updatedPfObject:self.currentProfile];
}

#pragma mark UITextFeildDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [txtFullName resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
