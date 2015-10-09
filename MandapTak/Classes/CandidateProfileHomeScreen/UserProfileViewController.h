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
#import "StartMainViewController.h"
#import "MatchScreenVC.h"
#import "WYPopoverController.h"
#import "WYStoryboardPopoverSegue.h"
#import "MBCircularProgressBar/MBCircularProgressBarView.h"
#import <LayerKit/LayerKit.h>
#import "PreferenceVC.h"

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
    IBOutlet UIButton *btnLike;
    IBOutlet UIButton *btnDislike;
    IBOutlet UIButton *btnPin;
    IBOutlet UIButton *btnDetail;
    IBOutlet NSLayoutConstraint *imageViewConstraint;
    IBOutlet UIView *loaderView;
    
    IBOutlet UIImageView *animationImageView;
    //blur image view
    ALDBlurImageProcessor *blurImageProcessor;
    //UIImageView *blurTargetImageView;
    
    BOOL isTraitsAvailable;
    IBOutlet UIImageView *userImageView;
    IBOutlet MBCircularProgressBarView *progressBar;
    IBOutlet UILabel *lblTraitMatch;

    //activity indicator
    IBOutlet UIActivityIndicatorView *activityIndicator;
}
@property (nonatomic) LYRClient *layerClient;
- (IBAction)showCandidateProfile:(id)sender;
- (IBAction)pinAction:(id)sender;
- (IBAction)likeAction:(id)sender;
- (IBAction)dislikeAction:(id)sender;
- (IBAction)openChatPinMatchScreen:(id)sender;
- (IBAction)undoAction:(id)sender;
- (IBAction)refreshAction:(id)sender;
@end
