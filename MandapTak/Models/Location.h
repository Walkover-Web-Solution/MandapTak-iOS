//
//  Location.h
//  MandapTak
//
//  Created by Hussain Chhatriwala on 06/08/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
@interface Location : NSObject
@property (strong, nonatomic) NSString *descriptions;
@property (strong, nonatomic) NSString *placeId;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) PFObject *cityPointer;

@end
