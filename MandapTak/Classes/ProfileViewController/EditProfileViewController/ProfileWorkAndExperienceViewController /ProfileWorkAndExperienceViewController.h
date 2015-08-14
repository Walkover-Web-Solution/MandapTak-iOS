//
//  ProfileWorkAndExperienceViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 14/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@protocol ProfileWorkAndExperienceViewControllerDelegate
//-(void)selectedDateOfBirth:(NSDate*)date andTime:(NSDate*)time;
-(void)updatedPfObjectForThirdTab:(PFObject *)updatedUserProfile;
@end

@interface ProfileWorkAndExperienceViewController : UIViewController
@property (weak, nonatomic) id <ProfileWorkAndExperienceViewControllerDelegate> delegate;
@property (strong, nonatomic) PFObject *currentProfile;

@end
