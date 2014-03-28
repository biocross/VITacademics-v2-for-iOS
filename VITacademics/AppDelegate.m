//
//  AppDelegate.m
//  VITacademics
//
//  Created by Siddharth on 08/12/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "GAI.h"
#import "Appirater.h"
#import "Pigeon.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    UIFont *newFont = [UIFont fontWithName:@"MuseoSans-300" size:14];
    [[UILabel appearance] setFont:newFont];
    //self.window.tintColor = [UIColor colorWithRed:0.905 green:0.298 blue:0.133 alpha:1];
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:                                                        [UIFont fontWithName:@"MuseoSans-300" size:18], NSFontAttributeName, nil]];
    
    
    [Parse setApplicationId:@"vtpDFHGacMwZIpMtpDaFuu0ToBol9b9nQM9VD57N"
                  clientKey:@"OCKn8dB6wqeGqvSdYbXHgYe9mDGFb2yukyDHT3Fs"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    //[PFFacebookUtils initializeFacebook];
    
    
    [Crittercism enableWithAppID:@"526e47368b2e337b2700000a" andDelegate:self andURLFilters:nil disableInstrumentation:NO];
    [Crittercism setAsyncBreadcrumbMode:YES];
    [Crittercism leaveBreadcrumb:@"<breadcrumb>"];
    
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 30;
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-38195928-4"];
    NSLog(@"%@", [tracker debugDescription]);
    
    
    //Failsafe:
    NSUserDefaults *temp = [NSUserDefaults standardUserDefaults];
    
    [[Pigeon sharedInstance] enableLocalNotification];
    [[Pigeon sharedInstance] startWithAppleId:@"727796987"];

    
    /*
    if([temp objectForKey:@"firstRun"]){
        NSLog(@"This is not the first Run");
    }
    else{
        NSLog(@"firstRun Detected: Resetting Old Data");
        NSUserDefaults *new = [NSUserDefaults standardUserDefaults];
        [new removeObjectForKey:[new stringForKey:@"registrationNumber"]];
        [new removeObjectForKey:@"registrationNumber"];
        [new removeObjectForKey:@"dateOfBirth"];
    }*/
    
    NSString *ttKey = [NSString stringWithFormat:@"TTOf%@", [temp objectForKey:@"registrationNumber"]];
    
    
    if([temp objectForKey:@"registrationNumber"] && [temp objectForKey:[temp objectForKey:@"registrationNumber"]] && [temp objectForKey:@"dateOfBirth"] && [temp objectForKey:ttKey]){
        NSLog(@"All Systems OK");
        [[DataManager sharedManager] initializeDataSources];
    }
    else{
        NSLog(@"Error Found in starting, resetting App.");
        NSUserDefaults *new = [NSUserDefaults standardUserDefaults];
        [new removeObjectForKey:@"registrationNumber"];
        [new removeObjectForKey:@"dateOfBirth"];
    }
    
    /*
    @try {
        if([self isValidJSON:[temp objectForKey:ttKey]]){
            NSLog(@"TimeTable looks good.");
        }
        else{
            NSLog(@"Error Found in TimeTable, resetting App.");
            NSUserDefaults *new = [NSUserDefaults standardUserDefaults];
            [new removeObjectForKey:@"registrationNumber"];
            [new removeObjectForKey:@"dateOfBirth"];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Error is TT Check");
    }
    */
    
    
    [Appirater setAppId:@"727796987"];
    [Appirater setDaysUntilPrompt:6];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
    
    return YES;
}

/*
-(BOOL)isValidJSON:(NSString *)jsonThingy{
    NSError *e = nil;
    NSData *ttDataFromString = [jsonThingy dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData: ttDataFromString options: NSJSONReadingMutableContainers error: &e];
    
    if (!jsonArray) {
        return NO;
    }
    else{
        return YES;
    }
}
 */

							
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

@end
