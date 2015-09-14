//
//  FacebooKProfilePictureViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 26/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FacebooKProfilePictureViewControllerDelegate
//-(void)selectedDateOfBirth:(NSDate*)date andTime:(NSDate*)time;
-(void)selectedProfilePhotoArray:(NSArray*)arrSelectedProfilePics;
@end

@interface FacebooKProfilePictureViewController : UIViewController
@property (weak, nonatomic) id <FacebooKProfilePictureViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString *userId;
@end
