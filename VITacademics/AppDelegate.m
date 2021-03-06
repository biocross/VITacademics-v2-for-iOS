//
//  AppDelegate.m
//  VITacademics
//
//  Created by Siddharth on 08/12/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "Appirater.h"
#import "Pigeon.h"

#define MIXPANEL_TOKEN @"a24729f70174747da8bdd913eacf9643"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    DataManager *sharedManager = [DataManager sharedManager];
    sharedManager.context = self.managedObjectContext;
    
    UIFont *newFont = [UIFont fontWithName:@"MuseoSans-300" size:14];
    [[UILabel appearance] setFont:newFont];
    //self.window.tintColor = [UIColor colorWithRed:0.905 green:0.298 blue:0.133 alpha:1];
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:                                                        [UIFont fontWithName:@"MuseoSans-300" size:18], NSFontAttributeName, nil]];
    
    
    [Parse setApplicationId:@"vtpDFHGacMwZIpMtpDaFuu0ToBol9b9nQM9VD57N"
                  clientKey:@"OCKn8dB6wqeGqvSdYbXHgYe9mDGFb2yukyDHT3Fs"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [PFFacebookUtils initializeFacebook];
    
    
    [Crittercism enableWithAppID:@"526e47368b2e337b2700000a" andDelegate:self andURLFilters:nil disableInstrumentation:NO];
    [Crittercism setAsyncBreadcrumbMode:YES];
    [Crittercism leaveBreadcrumb:@"App Started!"];
    
    [[Pigeon sharedInstance] enableLocalNotification];
    [[Pigeon sharedInstance] startWithAppleId:@"727796987"];
    
    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
    Mixpanel *mixpanel = [Mixpanel sharedInstance];

    NSUserDefaults *temp = [NSUserDefaults standardUserDefaults];
    NSString *ttKey = [NSString stringWithFormat:@"TTOf%@", [temp objectForKey:@"registrationNumber"]];
    
    if([temp objectForKey:@"registrationNumber"] && [temp objectForKey:[temp objectForKey:@"registrationNumber"]] && [temp objectForKey:@"dateOfBirth"] && [temp objectForKey:ttKey]){
        NSLog(@"All Systems OK");
        [mixpanel identify:[temp objectForKey:@"registrationNumber"]];
        [mixpanel track:@"App Init" properties:@{@"Version": [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] }];
        
        [PFUser logInWithUsernameInBackground:[temp objectForKey:@"registrationNumber"] password:[temp objectForKey:@"dateOfBirth"]
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
                                                NSLog(@"Login Complete");
                                            } else {
                                            }
                                        }];
        
        
    }
    else{
        NSLog(@"Error Found in starting, resetting App.");
        NSUserDefaults *new = [NSUserDefaults standardUserDefaults];
        [new removeObjectForKey:@"registrationNumber"];
        [new removeObjectForKey:@"dateOfBirth"];
    }
    
    
    [Appirater setAppId:@"727796987"];
    [Appirater setDaysUntilPrompt:6];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[Pigeon sharedInstance] openInAppStore];
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"VITacademics" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"VITacademics.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (void) clearCoreData{
    NSError * error;
    // retrieve the store URL
    NSURL * storeURL = [[_managedObjectContext persistentStoreCoordinator] URLForPersistentStore:[[[_managedObjectContext persistentStoreCoordinator] persistentStores] lastObject]];
    // lock the current context
    [_managedObjectContext lock];
    [_managedObjectContext reset];//to drop pending changes
    //delete the store from the current managedObjectContext
    if ([[_managedObjectContext persistentStoreCoordinator] removePersistentStore:[[[_managedObjectContext persistentStoreCoordinator] persistentStores] lastObject] error:&error])
    {
        // remove the file containing the data
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
        //recreate the store like in the  appDelegate method
        [[_managedObjectContext persistentStoreCoordinator] addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];//recreates the persistent store
    }
    [_managedObjectContext unlock];
    
    NSLog(@"Core Data Reset: New DB is active.");
    
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Parse Push Notifications

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current Installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

@end
