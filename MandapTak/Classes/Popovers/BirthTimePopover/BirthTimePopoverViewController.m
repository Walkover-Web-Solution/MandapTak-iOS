//
//  BirthTimePopoverViewController.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 08/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "BirthTimePopoverViewController.h"

@interface BirthTimePopoverViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
- (IBAction)doneButtonAction:(id)sender;

@end

@implementation BirthTimePopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timePicker.datePickerMode = UIDatePickerModeTime;
    self.timePicker.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    

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
    [self.delegate selectedBirthTime:self.timePicker.date];
}
@end
