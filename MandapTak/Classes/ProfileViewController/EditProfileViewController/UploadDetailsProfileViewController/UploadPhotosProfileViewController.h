//
//  UploadPhotosProfileViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 20/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@protocol UploadPhotosProfileViewControllerDelegate
//-(void)selectedDateOfBirth:(NSDate*)date andTime:(NSDate*)time;
-(void)updatedPfObjectForFourthTab:(PFObject *)updatedUserProfile;
@end
@interface UploadPhotosProfileViewController : UIViewController{
    __weak IBOutlet UIButton *choosePhotoBtn;
    __weak IBOutlet UIButton *takePhotoBtn;
}
@property (weak, nonatomic) id <UploadPhotosProfileViewControllerDelegate> delegate;
@property (strong, nonatomic) PFObject *currentProfile;

@property (nonatomic, retain) IBOutlet UIImageView * imageView;
@property (nonatomic, retain) IBOutlet UIButton * choosePhotoBtn;
@property (nonatomic, retain) IBOutlet UIButton * takePhotoBtn;

@end
