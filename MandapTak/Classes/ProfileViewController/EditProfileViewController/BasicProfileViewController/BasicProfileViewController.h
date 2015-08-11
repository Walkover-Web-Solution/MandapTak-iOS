//
//  BasicProfileViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 10/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@protocol BasicProfileViewControllerDelegate
//-(void)selectedDateOfBirth:(NSDate*)date andTime:(NSDate*)time;
-(void)updatedPfObject:(PFObject *)updatedUserProfile;
@end

@interface BasicProfileViewController : UIViewController
@property (strong, nonatomic) PFObject *currentProfile;
@property (weak, nonatomic) id <BasicProfileViewControllerDelegate> delegate;

@end
