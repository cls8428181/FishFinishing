//
//  KNBThirdManager.m
//  KenuoTraining
//
//  Created by 吴申超 on 16/3/14.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "KNBAppManager.h"
#import <AFNetworkReachabilityManager.h>
#import <MagicalRecord/MagicalRecord.h>
#import "AppDelegate.h"
#import "KNBMainConfigModel.h"
#import <AFNetworking.h>
#import <JPUSHService.h>
#import "KNGetUserLoaction.h"
#import "NSString+MD5.h"
#import "KNPaypp.h"
#import "YTKNetworkConfig.h"
#import <YTKNetworkAgent.h>
#import "KNBGetCollocationApi.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

// dis
#define kGtAppId @"hiTFn7zSlO7wz9LDRklFy4"
#define kGtAppKey @"TO4lMW1FGT6b25knkS5vj6"
#define kGtAppSecret @"uyrjpF2LmT7R8pBg9UK7w9"
#define AMapKey @"de394abc7320a2062737a4897a209cfc"


@interface KNBAppManager () <UNUserNotificationCenterDelegate,JPUSHRegisterDelegate>

@end


@implementation KNBAppManager

KNB_DEFINE_SINGLETON_FOR_CLASS(KNBAppManager);

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureThird];
    }
    return self;
}

- (void)configureThird {
    // 配置微信支付
    [KNPaypp registerWxApp:KN_WeixinAppId];
    // 网络请求配置
    [self configureRequestFilters];
    [self configureMainConfig];
    // 定位
    [[KNGetUserLoaction shareInstance] startLocation];
    //配置友盟分享
    [KNUMManager shareInstance];
    
    [self configureMapKit];
    //开启键盘控制
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)configureRequestFilters {
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = KNB_MAINCONFIGURL;
    //https 公匙
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
    NSData * certData =[NSData dataWithContentsOfFile:cerPath];
    NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    [securityPolicy setAllowInvalidCertificates:YES];
    [securityPolicy setValidatesDomainName:NO];
    [securityPolicy setPinnedCertificates:certSet];
    config.securityPolicy = securityPolicy;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = securityPolicy;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];    
    //服务端返回格式问题，后端返回的结果不是"application/json"，afn 的 jsonResponseSerializer 是不认的。这里做临时处理
    YTKNetworkAgent *agent = [YTKNetworkAgent sharedAgent];
    [agent setValue:[NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json",@"text/html", nil]
         forKeyPath:@"jsonResponseSerializer.acceptableContentTypes"];
}

- (void)configureMainConfig {
    KNBGetCollocationApi *api = [[KNBGetCollocationApi alloc] initWithKey:@"System_setup"];
    api.hudString = @"";
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            NSDictionary *dic = request.responseObject[@"list"];
            NSString *openString = dic[@"is_open_payment"];
            [[NSUserDefaults standardUserDefaults] setObject:openString forKey:@"OpenPayment"];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
    }];
}

- (void)configureMapKit {
    [AMapServices sharedServices].apiKey = AMapKey;
}

#pragma mark - 用户通知(推送) _自定义方法
/** 注册用户通知 */
- (void)registerUserNotification {
    /*
     注册通知(推送)
     申请App需要接受来自服务商提供推送消息
     */
    // 判读系统版本是否是“iOS 8.0”以上

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay)
                              completionHandler:^(BOOL granted, NSError *_Nullable error) {
                                  if (!error) {
                                      NSLog(@"request authorization succeeded!");
                                  }
                              }];

        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ||
               [UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        // 定义用户通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;

        // 定义用户通知设置
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];

        // 注册用户通知 - 根据用户通知设置
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else { // iOS8.0 以前远程推送设置方式
        // 定义远程通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        // UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;

        // 注册远程通知 -根据远程通知类型
        // [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
#pragma clang diagnostic pop
}


#pragma mark - UNUserNotificationCenterDelegate iOS 10中收到推送消息

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSLog(@"willPresentNotification：%@", notification.request.content.userInfo);

    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}
//  iOS 10: 点击通知进入App时触发
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
//    // [ GTSdk ]：将收到的APNs信息传给个推统计
//    NSDictionary *userInfo = response.notification.request.content.userInfo;
//    [GeTuiSdk handleRemoteNotification:userInfo];
//
//    if ([KNBUserInfo shareInstance].userInfo) {
//        NSArray *allKeys = [userInfo allKeys];
//        if ([allKeys containsObject:@"rc"]) {
//            [self rcTurnViewController];
//            return;
//        }
//        KNBPushNoticeModel *model = [KNBPushNoticeModel changeResponseJSONObject:userInfo];
//        if (isNullStr(model.notify_type) || isNullStr(model.notify_id) || isNullStr(model.push_time)) {
//            // 存入数据库
//            [[KNBPushManager shareInstance] didReceiveRemoteNotification:userInfo];
//            // 跳转到控制器
//            [[KNBPushManager shareInstance] launchingOptions:userInfo];
//        } else {
//            NSData *data = [NSJSONSerialization dataWithJSONObject:userInfo options:NSJSONWritingPrettyPrinted error:nil];
//            NSString *dicStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSDictionary *dic = @{ @"content" : dicStr };
//            // 存入数据库
//            [[KNBPushManager shareInstance] didReceiveRemoteNotification:dic];
//            // 跳转到控制器
//            [[KNBPushManager shareInstance] launchingOptions:dic];
//        }
//    }
//
//
//    completionHandler();
//}
#endif

//格式化时间
- (NSString *)formateTime:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:date];
    return dateTime;
}

//设置推送消息样式
//- (void)setupPushMessageStyleNotification:(UILocalNotification *)notification pushModel:(KNBPushNoticeModel *)model{
//    notification.fireDate = [NSDate date]; //触发通知的时间
//    notification.timeZone = [NSTimeZone defaultTimeZone];
//    notification.soundName = UILocalNotificationDefaultSoundName;
//    notification.alertTitle = model.title;
//    KNBPushNoticeType type = [KNBPushNoticeModel getCurrentPushType:model.notify_type];
//    switch (type) {
//        case KNBPushNoticeType_Adress:
//            notification.alertBody = @"精彩活动来袭,赶紧点击查看活动吧";
//            break;
//        case KNBPushNoticeType_Lesson:
//            notification.alertBody = @"专业课程推荐,意想不到的收获";
//            break;
//        case KNBPushNoticeType_Test:
//            notification.alertBody = @"检验学习效果,查漏补缺,点我吧";
//            break;
//        case KNBPushNoticetype_Allocation:
//            notification.alertBody = [self componentStringWithString:model.content];
//            break;
//        case KNBPushNoticetype_Invite:
//        {
//            NSArray *contentArray = [model.content componentsSeparatedByString:@"#"];
//            notification.alertBody = contentArray[0] ?: @"";
//        }
//            break;
//        case KNBPushNoticeType_PayingAgent:
//        {
//            notification.alertTitle = @"签约动态";
//            notification.alertBody = @"您被任命为新的代付人，请查看";
//        }
//            break;
//        default:
//            notification.alertBody = model.content;
//            break;
//    }
//
//}

- (NSString *)componentStringWithString:(NSString *)string {
    NSArray *dataArray = [string componentsSeparatedByString:@"#"];
    NSMutableString *mutableString = [NSMutableString string];
    for (int i = 0; i < dataArray.count; i++) {
        [mutableString appendString:dataArray[i]];
    }
    return mutableString.copy;
}
#pragma mark - PrivateMethod
- (void)rcTurnViewController {
    [KNB_AppDelegate.navController popToRootViewControllerAnimated:NO];
    [KNB_AppDelegate.tabBarController turnToControllerIndex:2];
}

#pragma mark- JPUSHRegisterDelegate
    // iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}
    
    // iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}
    
    // iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

@end
