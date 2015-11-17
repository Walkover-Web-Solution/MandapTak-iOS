//
//  CreateNewUserPopoverViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 07/09/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CreateNewUserPopoverViewControllerDelegate
-(void)userMobileNumber:(NSString*)mobNo ;
@end

@interface CreateNewUserPopoverViewController : UIViewController
@property (weak, nonatomic) id <CreateNewUserPopoverViewControllerDelegate> delegate;
@property (assign, nonatomic) NSInteger agentBal;
@end
