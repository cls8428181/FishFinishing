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
//#import "KNBRemindUpdate.h"
//#import "KNUMManager.h"
#import "KNGetUserLoaction.h"
#import "NSString+MD5.h"
//#import "KNPaypp.h"
#import "YTKNetworkConfig.h"
//#import "KNBPushNoticeModel.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

// dis
#define kGtAppId @"hiTFn7zSlO7wz9LDRklFy4"
#define kGtAppKey @"TO4lMW1FGT6b25knkS5vj6"
#define kGtAppSecret @"uyrjpF2LmT7R8pBg9UK7w9"


@interface KNBAppManager () <UNUserNotificationCenterDelegate>

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
    //游客登录配置
    [self configVistorRole];
    // 配置数据库路径
//    [self configureCoreDataPath];
    // 判断网络状态
    [self configureNetReachability];
    // 网络请求配置
//    [self configureRequestFilters];
    // 定位
    [[KNGetUserLoaction shareInstance] startLocation];
    
    //开启键盘控制
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

#pragma mark-- VistorConfig
/**
 配置游客角色信息
 */
- (void)configVistorRole {
//    if ([KNBUserInfo shareInstance].isLogin) {
//        return;
//    }
//    NSArray *role = [KNBUserInfo shareInstance].role;
//    NSDictionary *currentRole = role[0];
//    [[KNBUserInfo shareInstance] syncUserRoleInfo:currentRole];
//    [[KNBUserInfo shareInstance] syncUserRoleCurrentOffice:currentRole[@"officeBean"][0]];
}

/**
 数据库重命名方法
 */
- (void)resetCoreDataName {
//    NSString *userId = [KNBUserInfo shareInstance].userId;
//    NSString *officeId = [KNBUserInfo shareInstance].officeId;
//    if (isNullStr(userId) || isNullStr(officeId)) {
//        return;
//    }
//    NSString *path = [KNB_PATH_LIBRARY stringByAppendingPathComponent:@"Application Support/KenuoTraining"];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:NULL];
//    NSEnumerator *e = [contents objectEnumerator];
//    // md5 加密 作为数据库名
//    NSString *dbName = [[NSString stringWithFormat:@"%@%@", userId, officeId] MD5];
//    NSString *filename;
//    while ((filename = [e nextObject])) {
//        if ([filename hasPrefix:userId]) {
//            NSString *newName = [NSString stringWithFormat:@"%@.%@", dbName, filename.pathExtension];
//            [fileManager moveItemAtPath:[NSString stringWithFormat:@"%@/%@", path, filename] toPath:[NSString stringWithFormat:@"%@/%@", path, newName] error:nil];
//        }
//    }
//    [self configureCoreDataPath];
}

//#pragma mark - Configure CoreData
//- (void)configureCoreDataPath {
//    //3.0版本之后 本地数据库改为唯一数据库 md5 加密 作为数据库名称
////    NSString *dbName = [@"KNBDataBase" MD5];
////    [MagicalRecord cleanUp];
////    NSString *sqlitName = [NSString stringWithFormat:@"%@.sqlite", dbName];
////    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:sqlitName];
////    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelOff];
//
//    /*3.1.0版本之后，本地数据库改为多个数据库，KNBDataBase md5加密作为未登录时记录数据库
//      userId, officeId md5加密作为每个用户登录后用数据库
//     */
//    NSString *dbName;
//    NSString *userId = [KNBUserInfo shareInstance].userId;
//    NSString *officeId = [KNBUserInfo shareInstance].officeId;
//    if ([userId isEqualToString:@"-1"] || [officeId isEqualToString:@"-1"]) {
//        dbName = [NSString stringWithFormat:@"%@.sqlite", [@"KNBDataBase" MD5]];
//    }else {
//        dbName = [NSString stringWithFormat:@"%@.sqlite", [[NSString stringWithFormat:@"%@%@", userId, officeId] MD5]];
//    }
//
//    if ([KNB_APP_VERSION isEqualToString:@"3.1.0"]) {
//        NSString *path = [KNB_PATH_LIBRARY stringByAppendingPathComponent:@"Application Support/KenuoTraining"];
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:NULL];
//        NSEnumerator *e = [contents objectEnumerator];
//        NSString *filename;
//        while ((filename = [e nextObject])) {
//            if ([filename hasPrefix:[NSString stringWithFormat:@"%@.sqlite", [@"KNBDataBase" MD5]]]) {
//                NSString *newName = [NSString stringWithFormat:@"%@.%@", [dbName stringByDeletingPathExtension], filename.pathExtension];
//                if (![newName isEqualToString:filename]) {
//                    [fileManager moveItemAtPath:[NSString stringWithFormat:@"%@/%@", path, filename] toPath:[NSString stringWithFormat:@"%@/%@", path, newName] error:nil];
//                }
//            }
//        }
//    }
//
//    [MagicalRecord cleanUp];
//    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:dbName];
//    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelOff];
//}

#pragma mark - Configure NetWork
- (void)configureNetReachability {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"smart未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"smart没有联网");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"smart蜂窝数据");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"smart无线");
                break;
            default:
                break;
        }
    }];
}

//- (void)configureRequestFilters {
//    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
//    config.baseUrl = KNB_MAINCONFIGURL;
//    //https 公匙
//    //    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
//    //    NSData * certData =[NSData dataWithContentsOfFile:cerPath];
//    //    NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
//    //
//    //    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
//    //    [securityPolicy setAllowInvalidCertificates:YES];
//    //    [securityPolicy setValidatesDomainName:NO];
//    //    [securityPolicy setPinnedCertificates:certSet];
//    //    config.securityPolicy = securityPolicy;
//
//    KNBMainConfigApi *mainConfig = [[KNBMainConfigApi alloc] init];
//    // 10014 token失效
//    [mainConfig startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        if (request.responseJSONObject && request.responseStatusCode == 200) {
//            if (mainConfig.requestSuccess ||
//                mainConfig.getRequestStatuCode == KNTraingError_token ||
//                mainConfig.getRequestStatuCode == KNTraingError_update) {
//                NSDictionary *interfaceDict = request.responseJSONObject[@"data"];
//                //校验协议
//                [self judgeProtocolStatus:interfaceDict[@"is_exist"]];
//                //保存主配置接口
//                [[KNBMainConfigModel shareInstance] regestMainConfig:request.responseJSONObject];
//                [[KNBMainConfigModel shareInstance] newVersion];
//            }
//
//            if (mainConfig.requestSuccess) {
//                NSString *version = [[KNBMainConfigModel shareInstance] newVersion];
//                [[KNBRemindUpdate shareInstance] remindUpdateApp:version];
//            } else if (mainConfig.getRequestStatuCode == KNTraingError_update) { // 强制更新
//                NSString *version = [[KNBMainConfigModel shareInstance] newVersion];
//                [[KNBRemindUpdate shareInstance] remindForcedUpdate:version];
//            }
//            [[KNSmartUpDataNetWork shareInstance] getResultProblemList];
//        }
//    } failure:^(__kindof YTKBaseRequest *request) {
//        NSLog(@"mainConfig failed");
//    }];
//}

#pragma mark - 文件加密和解密文件清除
- (void)clearTmpSecretFilePath {
//    [KNBFileEncrpt deleteTmpFile];
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

@end
