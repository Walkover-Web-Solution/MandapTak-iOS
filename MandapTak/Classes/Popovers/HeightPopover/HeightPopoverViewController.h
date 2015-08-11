//
//  HeightPopoverViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 06/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HeightPopoverViewControllerDelegate
-(void)selectedHeight:(NSString*)height;
@end

@interface HeightPopoverViewController : UIViewController
@property (weak, nonatomic) id <HeightPopoverViewControllerDelegate> delegate;

@end
