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
#import <Parse/Parse.h>

@interface AppData : NSObject{
    NSArray *arrMatches;
}
@property (nonatomic) LYRClient *layerClient;
@property (nonatomic) NSArray *arrMatches;
@property (strong, nonatomic) PFObject *currentProfile;
@property (strong, nonatomic) PFObject *profileId;

typedef void (^ReachablityCompletionBlock)(bool isReachable);
typedef void (^GetProfilesCompletionBlock)(PFObject *profile, NSError *error);


@property (strong, nonatomic) MBProgressHUD *hud;
-(BOOL) isInternetAvailable;
-(void) logOut;
-(void)checkReachablitywithCompletionBlock:(ReachablityCompletionBlock)completionBlock;
-(LYRClient*)installLayerClient;
-(LYRClient*)fetchLayerClient;
-(void)loadAllMatches;
-(NSArray*)fetchAllMatches;
-(NSArray*)refreshAllMatches;
-(void)loadCurrentProfile;
-(void)setProfileForCurrentUserwithCompletionBlock:(GetProfilesCompletionBlock)completionBlock;;
//- (BOOL)askContactsPermission ;
DECLARE_SINGLETON_METHOD(AppData, sharedData)
@end
