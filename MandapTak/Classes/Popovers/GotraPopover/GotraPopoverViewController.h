//
//  GotraPopoverViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 13/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@protocol GotraPopoverViewControllerDelegate
-(void)selectedGotra:(PFObject*)gotra;
@end

@interface GotraPopoverViewController : UIViewController
@property (weak, nonatomic) id <GotraPopoverViewControllerDelegate> delegate;
@property (strong, nonatomic) NSArray *arrTableData;
@property (strong, nonatomic) PFObject *casteObj;

@end
