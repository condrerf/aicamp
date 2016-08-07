//
//  MichiNoEkiAppDelegate.m
//  MichiNoEki
//
//  Created by 福島　良 on 11/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MichiNoEkiAppDelegate.h"
#import "Constants.h"
#import "FBNetworkReachability.h"

@implementation MichiNoEkiAppDelegate


@synthesize window=_window;

@synthesize tabBarController=_tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // ネットワークの通信状況の監視を開始
    [[FBNetworkReachability sharedInstance] startNotifier];
    
    // 使用されている機種にカメラ機能が搭載されていない場合は、タブバーの写真画面のアイコンを削除
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.tabBarController.viewControllers = [NSArray arrayWithObjects:
                                                 [self.tabBarController.viewControllers objectAtIndex:Map],
                                                 [self.tabBarController.viewControllers objectAtIndex:StationInfo],
                                                 [self.tabBarController.viewControllers objectAtIndex:Configuration],
                                                 nil];
    }
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // 通知を送信
    [[NSNotificationCenter defaultCenter] postNotificationName:APPLICATION_WILL_RESIGN_ACTIVE_NOTIFICATION object:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // 通知を送信
    [[NSNotificationCenter defaultCenter] postNotificationName:APPLICATION_DID_BECOME_ACTIVE_NOTIFICATION object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

@end
