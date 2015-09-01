//
//  History.h
//  MandapTak
//
//  Created by Anuj Jain on 9/1/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface History : NSObject
@property (strong, nonatomic) NSString *historyObjectId;
@property (strong, nonatomic) NSString *profileId;
@property (strong, nonatomic) NSString *actionProfileId;
@property (nonatomic) int actionType;   //dislike:0 , like:1 , pin:2
@end
