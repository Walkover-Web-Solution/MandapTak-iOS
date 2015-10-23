//
//  PrimaryImagePickerViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 20/10/15.
//  Copyright © 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photos.h"
#import "PhotoTweaksViewController.h"

@protocol PrimaryImagePickerViewControllerDelegate
-(void)selectedPrimaryPhoto:(Photos*)primaryPhoto andCropedPhoto:(UIImage*)cropedPhoto;
@end
@interface PrimaryImagePickerViewController : UIViewController
@property (strong, nonatomic) NSArray *arrImageList;
@property (weak, nonatomic) id <PrimaryImagePickerViewControllerDelegate> delegate;

@end
