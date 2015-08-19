//
//  IndustryPopoverViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 17/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@protocol IndustryPopoverViewControllerDelegate
-(void)selectedIndustry:(PFObject*)industry ;
@end
@interface IndustryPopoverViewController : UIViewController
@property (weak, nonatomic) id <IndustryPopoverViewControllerDelegate> delegate;

@end
