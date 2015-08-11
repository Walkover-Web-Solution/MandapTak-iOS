//
//  BirthTimePopoverViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 08/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BirthTimePopoverViewControllerDelegate
-(void)selectedBirthTime:(NSDate*)time;
@end
@interface BirthTimePopoverViewController : UIViewController
@property (weak, nonatomic) id <BirthTimePopoverViewControllerDelegate> delegate;

@end
