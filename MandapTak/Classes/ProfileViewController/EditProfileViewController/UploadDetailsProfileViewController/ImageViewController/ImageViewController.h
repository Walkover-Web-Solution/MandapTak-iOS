//
//  ImageViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 20/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photos.h"
@protocol ImageViewControllerDelegate

//-(void)selectedDateOfBirth:(NSDate*)date andTime:(NSDate*)time;
-(void)selectedPrimaryPhoto:(Photos*)primaryPhoto andCropedPhoto:(UIImage*)cropedPhoto andIndex:(NSInteger)index withDeletedPhotos:(NSArray*)arrDeletedPhotos;
@end

@interface ImageViewController : UIViewController{
    __weak IBOutlet UIImageView *imageView;
}
@property (weak, nonatomic) id <ImageViewControllerDelegate> delegate;

@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) NSMutableArray *arrImages;
@property (assign, nonatomic) NSInteger currentIndex;
@end
