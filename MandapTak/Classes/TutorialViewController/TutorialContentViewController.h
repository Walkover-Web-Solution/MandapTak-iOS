//
//  TutorialContentViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 27/07/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LayerKit/LayerKit.h>
@interface TutorialContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property NSUInteger pageIndex;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property NSString *titleText;
@property NSString *imageFile;

@end
