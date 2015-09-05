//
//  ManglikPopoverViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 04/09/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ManglikPopoverViewControllerDelegate
-(void)selectedManglik:(int)manglikTag;
@end
@interface ManglikPopoverViewController : UIViewController
@property (weak, nonatomic) id <ManglikPopoverViewControllerDelegate> delegate;

@end
