//
//  AppDelegate.h
//  FishFinishing
//
//  Created by 常立山 on 2019/3/26.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "KNBNavgationController.h"
#import "KNTabBarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) KNTabBarViewController *tabBarController;
@property (strong, nonatomic) KNBNavgationController *navController;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;
/**
 *  跳转登陆页面
 */
- (void)presentLoginViewController;

@end

