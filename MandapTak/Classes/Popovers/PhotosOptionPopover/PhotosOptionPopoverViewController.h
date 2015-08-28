//
//  PhotosOptionPopoverViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 21/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@protocol PhotosOptionPopoverViewControllerDelegate
-(void)selectedTag:(NSInteger)tag;
@end
@interface PhotosOptionPopoverViewController : UIViewController
@property (weak, nonatomic) id <PhotosOptionPopoverViewControllerDelegate> delegate;

@end
