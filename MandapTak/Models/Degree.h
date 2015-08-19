//
//  Degree.h
//  MandapTak
//
//  Created by Anuj Jain on 8/10/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Degree : NSObject

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *objectName;
@property (strong, nonatomic) NSString *objectType;
@property (strong, nonatomic) PFObject *objectPointer;

@end
