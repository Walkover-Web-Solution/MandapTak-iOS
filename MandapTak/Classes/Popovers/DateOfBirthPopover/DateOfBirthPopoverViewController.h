//
//  DateOfBirthPopoverViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 06/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DateOfBirthPopoverViewControllerDelegate
//-(void)selectedDateOfBirth:(NSDate*)date andTime:(NSDate*)time;
-(void)selectedDateOfBirth:(NSDate*)date;
@end
@interface DateOfBirthPopoverViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblSelect;
@property (weak, nonatomic) id <DateOfBirthPopoverViewControllerDelegate> delegate;

@end
