//
//  AppDelegate.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/26.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "AppDelegate.h"
#import "KNBAppManager.h"
#import "KNBWelcomeViewController.h"
#import "XHLaunchAdManager.h"
#import "CALayer+Transition.h"
#import "KNBLoginViewController.h"
#import "KNPaypp.h"
#import <JPUSHService.h>
#import <UserNotifications/UserNotifications.h>
#import "KNBPushManager.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()<KNBWelcomeVCDelegate,JPUSHRegisterDelegate,UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //配置极光推送
    [[KNBPushManager shareInstance] configureJPush:launchOptions];
    // 配置文件
    [[KNBAppManager shareInstance] configureThird];
    //引导页
    [self showPageGuideView];

    return YES;
}

/**
 *  引导页
 */
- (void)showPageGuideView {
    if ([KNBWelcomeViewController isShowGuideView]) {
        KNBWelcomeViewController *welcomeVC = [[KNBWelcomeViewController alloc] init];
        welcomeVC.delegate = self;
        self.window.rootViewController = welcomeVC;
    } else {
        [self isShowGuidePageViewComplete];
        //配置广告图
        [XHLaunchAdManager shareManager];
    }
}

/**
 *  登陆页面
 */
- (void)presentLoginViewController {
    UIViewController *visibleVC = self.navController.visibleViewController;
    if ([visibleVC isKindOfClass:[KNBLoginViewController class]]) {
        return;
    }
    [KNB_AppDelegate.tabBarController turnToControllerIndex:0]; //跳转到首页
    KNBLoginViewController *loginVC = [[KNBLoginViewController alloc] init];
    loginVC.vcType = KNBLoginTypeLogin;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self.navController presentViewController:nav animated:NO completion:nil];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[KNBPushManager shareInstance] registerDeviceToken:deviceToken];
}
    
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [[KNBPushManager shareInstance] handleRemoteNotification:userInfo];
    // Required, iOS 7 Support
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark-- KNBWelcomeVCDelegate
- (void)isShowGuidePageViewComplete {
    self.tabBarController = [[KNTabBarViewController alloc] init];
    self.navController = [[KNBNavgationController alloc] initWithRootViewController:self.tabBarController];
    self.window.rootViewController = self.navController;
    [self.window.layer transitionWithAnimType:TransitionAnimTypePageCurl subType:TransitionSubtypesFromRight curve:TransitionCurveEaseInEaseOut duration:0.5f];
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
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    BOOL payResult = [KNPaypp handleOpenURL:url withCompletion:^(NSString *result, KNPayppError *error) {
        
    }];
    BOOL umResult = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (payResult || umResult) {
        return YES;
    }
    return NO;
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL payResult = [KNPaypp handleOpenURL:url withCompletion:nil];
    BOOL umResult = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (payResult || umResult) {
        return YES;
    }
    return NO;
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"FishFinishing"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
