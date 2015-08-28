//
//  Photos.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 22/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface Photos : UIViewController
@property (strong, nonatomic) PFObject *imgObject;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *name;

@end
