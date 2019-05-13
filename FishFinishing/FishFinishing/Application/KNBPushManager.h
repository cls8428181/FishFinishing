//
//  KNBPushManager.h
//  FishFinishing
//
//  Created by apple on 2019/4/30.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KNBPushManager : NSObject
+ (instancetype)shareInstance;

- (void)configureJPush:(NSDictionary *)launchOptions;
- (void)registerDeviceToken:(NSData *)deviceToken;
- (void)settingRegistrationID;
- (void)handleRemoteNotification:(NSDictionary *)userInfo;
@end

NS_ASSUME_NONNULL_END
