//
//  UploadPhotosProfileViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 20/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photos.h"
#import <Parse/Parse.h>
@protocol UploadPhotosProfileViewControllerDelegate
//-(void)selectedDateOfBirth:(NSDate*)date andTime:(NSDate*)time;
-(void)updatedPfObjectForFourthTab:(PFObject *)updatedUserProfile withNewImg:(NSArray*)arrNewImg withProfilePic:(Photos*)profilePic andCropedProfilePic:(UIImage*)cropedProfilePic;
@end
@interface UploadPhotosProfileViewController : UIViewController{
    __weak IBOutlet UIButton *choosePhotoBtn;
}
@property (weak, nonatomic) id <UploadPhotosProfileViewControllerDelegate> delegate;
@property (strong, nonatomic) PFObject *currentProfile;

@property (nonatomic, retain) IBOutlet UIButton * choosePhotoBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *btnUploadBiodata;
@property (weak, nonatomic) IBOutlet UIImageView *biodataImgView;

@end
