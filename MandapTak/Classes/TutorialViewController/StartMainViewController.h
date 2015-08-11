//
//  StartMainViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 27/07/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartMainViewController : UIViewController
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) NSArray *pageImages;
@end
