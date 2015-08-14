//
//  ReligionPopoverViewController.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 13/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Religion.h"
@protocol ReligionPopoverViewControllerDelegate
-(void)selectedReligion:(PFObject*)religion;
@end

@interface ReligionPopoverViewController : UIViewController
@property (weak, nonatomic) id <ReligionPopoverViewControllerDelegate> delegate;
@property (strong, nonatomic) Religion *religion;
@property (strong, nonatomic) NSString *type;

@end
