//
//  Religion.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 13/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
@interface Religion : NSObject
@property (strong, nonatomic) PFObject *religion;
@property (strong, nonatomic) PFObject *caste;
@property (strong, nonatomic) PFObject *gotra;

@end
