//
//  Profile.m
//  MandapTak
//
//  Created by Anuj Jain on 8/25/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "Profile.h"

@implementation Profile

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.weight forKey:@"weight"];
    [encoder encodeObject:self.height forKey:@"height"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.name = [decoder decodeObjectForKey:@"name"];
        self.weight = [decoder decodeObjectForKey:@"weight"];
        self.height = [decoder decodeObjectForKey:@"height"];
    }
    return self;
}

@end
