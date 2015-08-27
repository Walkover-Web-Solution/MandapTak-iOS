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

@interface UserProfileViewController : UIViewController
{
    NSMutableArray *arrCandidateProfiles;
}
- (IBAction)showCandidateProfile:(id)sender;

@end
