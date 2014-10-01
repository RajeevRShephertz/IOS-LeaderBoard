//
//  LDAppDelegate.m
//  LeaderBoardSample
//
//  Created by Nitin Gupta on 14/03/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

#import "LDAppDelegate.h"

#import <FacebookSDK/FacebookSDK.h>
#import "AppHypeHelper.h"

@implementation LDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[AppHypeHelper sharedAppHypeHelper] initializeAppHype];
    if ([[AppHypeHelper sharedAppHypeHelper] adcounter] == 1)
    {
        [[AppHypeHelper sharedAppHypeHelper] loadInterstitialAd];
    }
    else
    {
        [[AppHypeHelper sharedAppHypeHelper] loadVideoAd];
    }
    
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
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return YES;
}

/*
 * If we have a valid session at the time of openURL call, we handle
 * Facebook transitions by passing the url argument to handleOpenURL
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

-(void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        // do stuff when app is active
        
    }else{
        // do stuff when app is in background
        [UIApplication sharedApplication].applicationIconBadgeNumber =
        [UIApplication sharedApplication].applicationIconBadgeNumber+1;
        /* to increment icon badge number */
    }
}

@end
