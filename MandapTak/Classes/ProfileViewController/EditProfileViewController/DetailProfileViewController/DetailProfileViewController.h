//
//  DetailProfileViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 10/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@protocol DetailProfileViewControllerrDelegate
//-(void)selectedDateOfBirth:(NSDate*)date andTime:(NSDate*)time;
-(void)updatedPfObjectForSecondTab:(PFObject *)updatedUserProfile;
@end

@interface DetailProfileViewController : UIViewController
@property (weak, nonatomic) id <DetailProfileViewControllerrDelegate> delegate;
@property (strong, nonatomic) PFObject *currentProfile;

@end
