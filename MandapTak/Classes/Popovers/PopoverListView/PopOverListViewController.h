//
//  PopOverListViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 04/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
@protocol PopOverListViewControllerDelegate
-(void)selectedLocation:(Location*)location;
@end
@interface PopOverListViewController : UIViewController
@property (weak, nonatomic) id <PopOverListViewControllerDelegate> delegate;

@end
