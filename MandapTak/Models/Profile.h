//
//  Profile.h
//  MandapTak
//
//  Created by Anuj Jain on 8/25/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Profile : NSObject
@property (strong, nonatomic) PFObject *profilePointer;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *dob;
@property (strong, nonatomic) NSString *placeOfBirth;
@property (strong, nonatomic) NSString *currentLocation;
@property (strong, nonatomic) NSString *tob;
@property (strong, nonatomic) NSString *height;
@property (strong, nonatomic) NSString *weight;
@property (strong, nonatomic) NSString *religion;
@property (strong, nonatomic) NSString *caste;
@property (strong, nonatomic) NSString *gotra;
@property (strong, nonatomic) NSString *income;
@property (strong, nonatomic) NSString *minBudget;
@property (strong, nonatomic) NSString *maxBudget;
@property (strong, nonatomic) NSString *designation;
@property (strong, nonatomic) NSString *company;
@property (strong, nonatomic) UIImage *profilePic;
@end
