//
//  DateOfBirthPopoverViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 06/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "DateOfBirthPopoverViewController.h"

@interface DateOfBirthPopoverViewController (){
    BOOL isDateSelected;
    NSDate *selectedDate;
    NSDate *selectedTime;
    BOOL isSkipHeight;
}
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)doneButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePickerView;
- (IBAction)skipButtonAction:(id)sender;


@end

@implementation DateOfBirthPopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timePickerView.hidden = YES;
    self.datePicker.hidden = NO;
    isDateSelected = NO;
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.timePickerView.datePickerMode = UIDatePickerModeTime;
    self.datePicker.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDate * currentDate = [NSDate date];
    NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];

    NSDateComponents * comps = [[NSDateComponents alloc] init];
    [comps setYear: -18];
    NSDate * minDate = [gregorian dateByAddingComponents: comps toDate: currentDate options: 0];
    
    //self.datePicker.minimumDate = minDate;
    self.datePicker.maximumDate = minDate;
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

- (IBAction)doneButtonAction:(id)sender {
    [self.delegate selectedDateOfBirth:self.datePicker.date];
}
//- (IBAction)skipButtonAction:(id)sender {
//    if(!isDateSelected){
//        [UIView transitionWithView:self.timePickerView
//                          duration:0.4
//                           options:UIViewAnimationOptionTransitionCrossDissolve
//                        animations:NULL
//                        completion:NULL];
//        
//        self.timePickerView.hidden = NO;
//        self.lblSelect.text = @"Select Birth time";
//        self.datePicker.hidden = YES;
//        isDateSelected  = YES;
//        selectedDate = nil;
//    }
//    else{
//        if(selectedTime && selectedDate){
//            [self.delegate selectedDateOfBirth:selectedDate andTime:self.timePickerView.date];
//        }
//        else if(selectedDate!=nil &&selectedTime == nil){
//            [self.delegate selectedDateOfBirth:selectedDate andTime:nil];
//
//        }
//        else if(selectedDate==nil &&selectedTime != nil){
//            [self.delegate selectedDateOfBirth:nil andTime:self.timePickerView.date];
//        }
//        else if(selectedDate==nil &&selectedTime == nil){
//            [self.delegate selectedDateOfBirth:nil andTime:nil];
//        }
//
//
//    }
//
//}
@end
