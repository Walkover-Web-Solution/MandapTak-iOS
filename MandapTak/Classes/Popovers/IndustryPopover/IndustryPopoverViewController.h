//
//  IndustryPopoverViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 17/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol IndustryPopoverViewControllerDelegate
-(void)selectedIndustry:(NSString*)industry ;
@end
@interface IndustryPopoverViewController : UIViewController
@property (weak, nonatomic) id <IndustryPopoverViewControllerDelegate> delegate;

@end
