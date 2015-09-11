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
//#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse setApplicationId:@"Uj7WryNjRHDQ0O3j8HiyoFfriHV8blt2iUrJkCN0"
                  clientKey:@"F8ySjsm3T6Ur4xOnIkgkS2I7aSFyfBsa2e4pBedN"];
   // [PFFacebookUtils initializeFacebook];
   
  
    if([PFUser currentUser]){
        [PFUser enableRevocableSessionInBackground];

        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"roleType"] isEqual:@"Agent"]){
            UIStoryboard *sb2 = [UIStoryboard storyboardWithName:@"Agent" bundle:nil];
            AgentViewController *vc = [sb2 instantiateViewControllerWithIdentifier:@"AgentViewController"];
            //vc.globalCompanyId = [self.companies.companyId intValue];
            
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
                
                //vc.globalCompanyId = [self.companies.companyId intValue];
                
                UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vc2];
                navController.navigationBarHidden =YES;
                self.window.rootViewController=vc2;
                
                
            }

        }
        
    }

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
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    // NSLog(@"Did Fail to Register for Remote Notifications");
    
    //NSLog(@"%@, %@", error, error.localizedDescription);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}
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
   // [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
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

@end
