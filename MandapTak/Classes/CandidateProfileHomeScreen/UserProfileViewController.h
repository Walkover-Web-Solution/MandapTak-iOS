//
//  UserProfileViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 27/07/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CandidateProfileDetailScreenVC.h"
#import <Parse/Parse.h>
#import "Profile.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "ChatPinMatchViewController.h"
#import "History.h"
#import "ALDBlurImageProcessor/ALDBlurImageProcessor.h"
#import "UIImageEffects.h"

@interface UserProfileViewController : UIViewController
{
    NSMutableArray *arrCandidateProfiles,*arrEducation,*arrCache,*arrHistory;
    IBOutlet UIImageView *imgViewProfilePic;
    NSArray *arrHeight;
    int profileNumber;
    IBOutlet UIView *blankView;
    IBOutlet UIView *profileView;
    IBOutlet UILabel *lblMessage;
    IBOutlet UIButton *btnUndo;
    IBOutlet UIButton *btnRefresh;
    IBOutlet NSLayoutConstraint *imageViewConstraint;
    IBOutlet UIView *loaderView;
    
    //blur image view
    ALDBlurImageProcessor *blurImageProcessor;
    //UIImageView *blurTargetImageView;
}
- (IBAction)showCandidateProfile:(id)sender;
- (IBAction)pinAction:(id)sender;
- (IBAction)likeAction:(id)sender;
- (IBAction)dislikeAction:(id)sender;
- (IBAction)openChatPinMatchScreen:(id)sender;
- (IBAction)undoAction:(id)sender;
- (IBAction)refreshAction:(id)sender;
@end
