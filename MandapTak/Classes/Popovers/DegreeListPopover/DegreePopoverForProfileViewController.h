//
//  DegreePopoverForProfileViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 17/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DegreePopoverForProfileViewControllerDelegate
-(void)selectedDegree:(NSString*)degree forTag:(NSInteger)tag;
@end

@interface DegreePopoverForProfileViewController : UIViewController
@property (assign, nonatomic) NSInteger btnTag;
@property (weak, nonatomic) id <DegreePopoverForProfileViewControllerDelegate> delegate;

@end
