//
//  AppDelegate.m
//  MandapTak
//
//  Created by Hussain Chhatriwala on 27/07/15.
//  Copyright (c) 2015 Walkover. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "WYPopoverController.h"
#import "WYStoryboardPopoverSegue.h"
#import "SWRevealViewController.h"
#import "EditProfileViewController.h"
#import "AgentViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "MatchScreenVC.h"
#import <LayerKit/LayerKit.h>
#import <Atlas.h>
#import "StartMainViewController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "AppData.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "TourOptionsVC.h"
#import "OptionsListVC.h"

//#import <Raygun4iOS/Raygun.h>
#import <NewRelicAgent/NewRelic.h>
@interface AppDelegate ()
{
    BOOL allowRotation;
}
@property (nonatomic) LYRClient *layerClient;

@end

@implementation AppDelegate

static NSString *const LayerAppIDString = @"layer:///apps/staging/3ffe495e-45e8-11e5-9685-919001005125";
static NSString *const ParseAppIDString = @"Uj7WryNjRHDQ0O3j8HiyoFfriHV8blt2iUrJkCN0";
static NSString *const ParseClientKeyString = @"F8ySjsm3T6Ur4xOnIkgkS2I7aSFyfBsa2e4pBedN";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NewRelicAgent startWithApplicationToken:@"AA2875f7ae1c1a56c03450a6cf9036195aff7b4924"];

    //apply firstload condition
    [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"isFirstLoad"];
    //Remote notification info
    NSDictionary *remoteNotifiInfo = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    //Accept push notification when app is not open
    if (remoteNotifiInfo) {
        [self application:application didReceiveRemoteNotification:remoteNotifiInfo];
    }
    // Raygun Initialisation
    //[Raygun sharedReporterWithApiKey:@"FmwFxRVKP/T932mxk9zzEA=="];

    [Parse setApplicationId:@"Uj7WryNjRHDQ0O3j8HiyoFfriHV8blt2iUrJkCN0"
                  clientKey:@"F8ySjsm3T6Ur4xOnIkgkS2I7aSFyfBsa2e4pBedN"];
    [PFUser enableRevocableSessionInBackground];
    
    //restrict rotation
    //[[NSUserDefaults standardUserDefaults] setValue:@"no" forKey:@"shouldRotateToLandscape"];
    
    // Set default ACLs
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    if([PFUser currentUser]){
        [[AppData sharedData]loadAllMatches];
        [[AppData sharedData]loadCurrentProfile];
        //[[Raygun sharedReporter] identify:[[PFUser currentUser] valueForKey:@"username"]];

        self.layerClient = [[AppData sharedData] installLayerClient];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"roleType"] isEqual:@"Agent"]){
            UIStoryboard *sb2 = [UIStoryboard storyboardWithName:@"Agent" bundle:nil];
            AgentViewController *vc = [sb2 instantiateViewControllerWithIdentifier:@"AgentViewController"];
            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vc];
            navController.navigationBarHidden =YES;
            self.window.rootViewController=vc;
        }
        else{
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"isProfileComplete"] isEqual:@"completed"]){
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                SWRevealViewController *vc = [sb instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                self.window.rootViewController=vc;
            }
            else{
                UIStoryboard *sb2 = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
                EditProfileViewController *vc2 = [sb2 instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
                vc2.isMakingNewProfile =YES;
                UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vc2];
                navController.navigationBarHidden =YES;
                self.window.rootViewController=vc2;
            }

        }
        
    }
    //[Fabric with:@[[Crashlytics class]]];
    
    WYPopoverBackgroundView* popoverAppearance = [WYPopoverBackgroundView appearance];
    
    [popoverAppearance setTintColor:[UIColor colorWithRed:63./255. green:92./255. blue:128./255. alpha:1]];
    [popoverAppearance setFillTopColor:[UIColor colorWithWhite:1 alpha:1]];
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    [[FBSDKApplicationDelegate sharedInstance]application:application didFinishLaunchingWithOptions:launchOptions];
    
    // Override point for customization after application launch.
    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    // NSLog(@"Did Fail to Register for Remote Notifications");
    
    //NSLog(@"%@, %@", error, error.localizedDescription);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo
{
    /*
    [PFPush handlePush:userInfo];
    if (application.applicationState == UIApplicationStateActive)
        
    {
        // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notification" message:[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]]delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
           [alertView show];
        
    }
    else
    {
        //handle inactive state condition
        //show match screen with user profile info
        [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"isNotification"];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SWRevealViewController *vc = [sb instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        self.window.rootViewController=vc;
    }
*/
    [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:@"isNotification"];
    //NSLog(@"profile id -> %@",[userInfo valueForKey:@"profileid"]);
    [[NSUserDefaults standardUserDefaults] setValue:[userInfo valueForKey:@"profileid"] forKey:@"notificationProfileId"];
    //[[[UIAlertView alloc] initWithTitle:@"Test" message:@"notification msg" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    
    if (application.applicationState == UIApplicationStateActive )
    {
        /*
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.userInfo = userInfo;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertBody = @"local notification";
        localNotification.fireDate = [NSDate date];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        */
        /*
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Preference" bundle:nil];
        MatchScreenVC *vc = [sb instantiateViewControllerWithIdentifier:@"PreferenceVC"];
        UINavigationController *navController =(UINavigationController *) self.window.rootViewController;
        [navController presentViewController:vc animated:YES completion:nil];
         */
        //[[[UIAlertView alloc]initWithTitle:@"Success" message:@"Someone liked you back" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"View", nil] show];
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SWRevealViewController *vc = [sb instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        self.window.rootViewController=vc;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ActiveStateNotification" object:self];
    }
    else
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SWRevealViewController *vc = [sb instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        self.window.rootViewController=vc;
    }
    
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    MatchScreenVC *vc = [sb instantiateViewControllerWithIdentifier:@"MatchScreenVC"];
//    self.window.rootViewController=vc;
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (application.applicationState == UIApplicationStateActive)
    {
        /*
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SWRevealViewController *vc = [sb instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        self.window.rootViewController=vc;
         */
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MatchScreenVC *vc = [sb instantiateViewControllerWithIdentifier:@"MatchScreenVC"];
        //self.window.rootViewController = vc ;
        UINavigationController *navController =(UINavigationController *) self.window.rootViewController;
        [navController pushViewController:vc animated:YES];
    }
}


/*
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [[[UIAlertView alloc] initWithTitle:@"Test" message:@"notification handler called" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];

}
*/
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    return [FBAppCall handleOpenURL:url
//                  sourceApplication:sourceApplication
//                        withSession:[PFFacebookUtils session]];
//}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [FBSDKAppEvents activateApp];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
   // [[PFFacebookUtils session] close];

    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.walkover.mandapTak.MandapTak" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MandapTak" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MandapTak.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
    
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
/*
 - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NS
 Dictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
 {
 NSError *error;
 
 BOOL success = [self.applicationController.layerClient synchronizeWithRemoteNotification:userInfo completion:^(NSArray *changes, NSError *error) {
 if (changes) {
 if ([changes count]) {
 message = [self messageFromRemoteNotification:userInfo];
 completionHandler(UIBackgroundFetchResultNewData);
 } else {
 completionHandler(UIBackgroundFetchResultNoData);
 }
 } else {
 completionHandler(UIBackgroundFetchResultFailed);
 }
 }];
 if (!success) {
 completionHandler(UIBackgroundFetchResultNoData);
 }
 */
 - (LYRMessage *)messageFromRemoteNotification:(NSDictionary *)remoteNotification
 {
     static NSString *const LQSPushMessageIdentifierKeyPath = @"layer.message_identifier";
     
     // Retrieve message URL from Push Notification
     NSURL *messageURL = [NSURL URLWithString:[remoteNotification valueForKeyPath:LQSPushMessageIdentifierKeyPath]];
     
     // Retrieve LYRMessage from Message URL
     LYRQuery *query = [LYRQuery queryWithQueryableClass:[LYRMessage class]];
     query.predicate = [LYRPredicate predicateWithProperty:@"identifier" predicateOperator:LYRPredicateOperatorIsIn value:[NSSet setWithObject:messageURL]];
     
     NSError *error = nil;
     NSOrderedSet *messages = [self.layerClient executeQuery:query error:&error];
     if (messages) {
     NSLog(@"Query contains %lu messages", (unsigned long)messages.count);
     LYRMessage *message= messages.firstObject;
     LYRMessagePart *messagePart = message.parts[0];
     NSLog(@"Pushed Message Contents: %@", [[NSString alloc] initWithData:messagePart.data encoding:NSUTF8StringEncoding]);
     } else {
     NSLog(@"Query failed with error %@", error);
     }
     
     return [messages firstObject];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"app delegate method called");
}

#pragma mark Movie Player Orientation Methods
- (void) moviePlayerWillEnterFullscreenNotification:(NSNotification*)notification {
    allowRotation = YES;
}

- (void) moviePlayerWillExitFullscreenNotification:(NSNotification*)notification {
    allowRotation = NO;
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)windowx
{
    if ([[self.window.rootViewController presentedViewController] isKindOfClass:[MPMoviePlayerViewController class]] ||
        [[self.window.rootViewController presentedViewController] isKindOfClass:[AVPlayerLayer class]] ||
        [[self.window.rootViewController presentedViewController] isKindOfClass:[AVPlayer class]] ||
        [[self.window.rootViewController presentedViewController] isKindOfClass:NSClassFromString(@"MPInlineVideoFullscreenViewController")])
    {
        if ([self.window.rootViewController presentedViewController].isBeingDismissed)
        {
            return UIInterfaceOrientationMaskPortrait;
        }
        else
        {
            return UIInterfaceOrientationMaskAllButUpsideDown;
        }
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if ([[self.window.rootViewController presentedViewController] isKindOfClass:[MPMoviePlayerViewController class]] ||
        [[self.window.rootViewController presentedViewController] isKindOfClass:[AVPlayerLayer class]] ||
        [[self.window.rootViewController presentedViewController] isKindOfClass:[AVPlayer class]] ||
        [[self.window.rootViewController presentedViewController] isKindOfClass:NSClassFromString(@"MPInlineVideoFullscreenViewController")])
    {
       return UIInterfaceOrientationLandscapeLeft;
    }
    else
    {
        return UIInterfaceOrientationPortrait;
    }
}

@end
