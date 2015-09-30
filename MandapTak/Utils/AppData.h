//
//  AppData.h
//  MSG91
//
//  Created by shubhendra Agrawal on 05/03/2015.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonMacros.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import <LayerKit/LayerKit.h>

@interface AppData : NSObject{
    NSArray *arrMatches;
}
@property (nonatomic) LYRClient *layerClient;

typedef void (^ReachablityCompletionBlock)(bool isReachable);


@property (strong, nonatomic) MBProgressHUD *hud;
-(BOOL) isInternetAvailable;
-(void) logOut;
-(void)checkReachablitywithCompletionBlock:(ReachablityCompletionBlock)completionBlock;
-(LYRClient*)installLayerClient;
-(LYRClient*)fetchLayerClient;
//- (BOOL)askContactsPermission ;
DECLARE_SINGLETON_METHOD(AppData, sharedData)
@end
