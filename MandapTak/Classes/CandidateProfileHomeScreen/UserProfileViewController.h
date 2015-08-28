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

@interface UserProfileViewController : UIViewController
{
    NSMutableArray *arrCandidateProfiles,*arrEducation;
    IBOutlet UIImageView *imgViewProfilePic;
    NSArray *arrHeight;
    int profileNumber;
}
- (IBAction)showCandidateProfile:(id)sender;
- (IBAction)pinAction:(id)sender;
- (IBAction)likeAction:(id)sender;
- (IBAction)dislikeAction:(id)sender;

@end
