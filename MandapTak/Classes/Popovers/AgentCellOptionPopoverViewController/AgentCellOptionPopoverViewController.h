//
//  AgentCellOptionPopoverViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 07/09/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@protocol AgentCellOptionPopoverViewControllerDelegate
-(void)selectedOption:(NSString*)option withTag:(NSInteger)tag;

@end

@interface AgentCellOptionPopoverViewController : UIViewController
@property (weak, nonatomic) id <AgentCellOptionPopoverViewControllerDelegate> delegate;
@property (assign, nonatomic) NSInteger btnTag;
@property (assign, nonatomic) PFObject *userProfile;
@property (assign,nonatomic) NSString *type;
@end
