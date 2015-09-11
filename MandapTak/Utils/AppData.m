//
//  AppData.m
//  MSG91
//
//  Created by shubhendra Agrawal on 05/03/2015.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "AppData.h"
#import "AppDelegate.h"
#import "ServiceManager.h"
#import "SCNetworkReachability.h"
#import <Parse/Parse.h>
@implementation AppData{
     SCNetworkReachability *_reachability;
}

SYNTHESIZE_SINGLETON_METHOD(AppData, sharedData);
-(BOOL) isInternetAvailable{
    BOOL available = NO;
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (!networkStatus == NotReachable) {
        available = YES;
    }
    return available;
}
-(void)checkReachablitywithCompletionBlock:(ReachablityCompletionBlock)completionBlock{
    _reachability = [[SCNetworkReachability alloc] initWithHost:@"https://www.parse.com/apps/mandaptak/"];
    [_reachability observeReachability:^(SCNetworkStatus status)
     {
         
         if(status==0){
             completionBlock (false);
             NSLog(@"Not reachable");
         }
         else{
             completionBlock (TRUE);
         }
     }
     ];

}
-(void)logOut{
    [PFUser logOutInBackgroundWithBlock:^(NSError *PF_NULLABLE_S error){
        NSLog(@"%@",error.userInfo);
    }];
    PFUser *user  = nil;
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setObject:user forKey:@"user"];
    [currentInstallation saveInBackground];

}
//-(BOOL)checkReachablity{
//    _reachability = [[SCNetworkReachability alloc] initWithHost:@"https://www.parse.com/apps/mandaptak/"];
//    [_reachability observeReachability:^(SCNetworkStatus status)
//     {
//         
//         if(status==0){
//             NSLog(@"Not reachable");
//         }
//     }
//     ];
//
//}
@end
