//
//  ServiceManager.h
//  Giddh
//
//  Created by Admin on 15/04/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonMacros.h"
// hussain api section


//Anuj Api section
typedef void (^LocationCompletionBlock)(NSArray *arrLocation, NSError *error);

@interface ServiceManager : NSObject
{
    NSUserDefaults *userDef;
}

DECLARE_SINGLETON_METHOD(ServiceManager, sharedManager);


// hussain api section
-(void)getLocationFromCityInput:(NSString*)input withCompletionBlock:(LocationCompletionBlock)completionBlock;

@end
