//
//  Education.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 17/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
@interface Education : NSObject
@property (strong, nonatomic) PFObject *degree;
@property (strong, nonatomic) PFObject *specialisation;
@end
