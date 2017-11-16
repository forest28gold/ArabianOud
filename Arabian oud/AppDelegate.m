//
//  AppDelegate.m
//  Arabian oud
//
//  Created by AppsCreationTech on 12/21/16.
//  Copyright © 2016 AppsCreationTech. All rights reserved.
//

#import "AppDelegate.h"
#import "AOSelectRegionViewController.h"
#import "AOMainViewController.h"

#import "PayPalMobile.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction:PAYPAL_CLIENT_ID_FOR_PRODUCTION, PayPalEnvironmentSandbox:PAYPAL_CLIENT_ID_FOR_SANDBOX}];
    
    [GlobalData sharedGlobalData].g_autoFormat = [AutoFormatter getInstance];
    
    [GlobalData sharedGlobalData].g_dBHandler = [DBHandler connectDB];
    sqlite3* dbHandler = [[GlobalData sharedGlobalData].g_dBHandler getDbHandler];
    [GlobalData sharedGlobalData].g_dataModel = [[DataModel alloc] initWithDBHandler:dbHandler];
    
    [GlobalData sharedGlobalData].g_arrayStores = [[NSMutableArray alloc] init];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *controller = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"RootNavigationController"];
    

    if ([[GlobalData sharedGlobalData].g_userInfo.signup isEqualToString:@""] || [GlobalData sharedGlobalData].g_userInfo.signup == nil) {

        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
        
        if ([language containsString:LANGUAGE_ARABIAN]) {
            storyboard = [UIStoryboard storyboardWithName:@"Main_ar" bundle:nil];
            [NSBundle setLanguage:LANGUAGE_ARABIAN];
            [GlobalData sharedGlobalData].g_userInfo.language = LANGUAGE_ARABIAN;
        } else {
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [NSBundle setLanguage:LANGUAGE_ENGLISH];
            [GlobalData sharedGlobalData].g_userInfo.language = LANGUAGE_ENGLISH;
        }
        
        controller = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"RootNavigationController"];
        
        AOSelectRegionViewController *selectRegionController = [storyboard instantiateViewControllerWithIdentifier:VIEW_SELECT_REGION];
        [controller setViewControllers:[NSArray arrayWithObject:selectRegionController] animated:YES];

    } else {
    
        if ([[GlobalData sharedGlobalData].g_userInfo.language isEqualToString:LANGUAGE_ARABIAN]) {
            storyboard = [UIStoryboard storyboardWithName:@"Main_ar" bundle:nil];
            [NSBundle setLanguage:LANGUAGE_ARABIAN];
        } else {
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [NSBundle setLanguage:LANGUAGE_ENGLISH];
        }
        
        controller = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"RootNavigationController"];
        
        AOMainViewController *mainController = [storyboard instantiateViewControllerWithIdentifier:VIEW_MAIN];
        [controller setViewControllers:[NSArray arrayWithObject:mainController] animated:YES];
    }
    
    self.window.rootViewController = controller;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
