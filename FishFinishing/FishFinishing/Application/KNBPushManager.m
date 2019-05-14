//
//  KNBPushManager.m
//  FishFinishing
//
//  Created by apple on 2019/4/30.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBPushManager.h"
#import <JPUSHService.h>
#import "KNBJPushApi.h"
#import <EBBannerView.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "KNBLoginUserInfoApi.h"

//极光推送 Appkey
static NSString *JPUSHAPPKEY = @"203c53dd36ec2d2716584fbb";

@interface KNBPushManager ()<JPUSHRegisterDelegate,UNUserNotificationCenterDelegate>

@property (nonatomic, strong) NSDictionary *remoteNotificationUserInfo;

@end

@implementation KNBPushManager

KNB_DEFINE_SINGLETON_FOR_CLASS(KNBPushManager);

- (void)configureJPush:(NSDictionary *)launchOptions {
    
    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self; // 检查这个代理是否设置
    }
    // Override point for customization after application launch.
    //  NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //添加APNs代码 JPush的初始化操作
//    self.messageNum = 0;
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    //        //可以添加自定义categories
    //        //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
    //        //      NSSet<UNNotificationCategory *> *categories;
    //        //      entity.categories = categories;
    //        //    }
    //        //    else {
    //        //      NSSet<UIUserNotificationCategory *> *categories;
    //        //      entity.categories = categories;
    //        //    }
    //    }
    //注册极光
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    // isProduction NO为开发环境，YES为生产环境
    [JPUSHService setupWithOption:launchOptions appKey:JPUSHAPPKEY
                          channel:@"App Store" apsForProduction:NO];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    //☆☆☆ 添加一个notification来捕捉极光的自定义消息 只能在前台展示
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    //极光推送的角标问题
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
}

- (void)settingRegistrationID {
    NSLog(@"已登录");
    NSString *registrationIDStr = [JPUSHService registrationID];
    if ([registrationIDStr isEqualToString:[KNBUserInfo shareInstance].registrationID]) {
        return;
    }
    if (!isNullStr(registrationIDStr)) {
        [[NSUserDefaults standardUserDefaults] setObject:registrationIDStr forKey:@"registrationID"];
        KNBJPushApi *api = [[KNBJPushApi alloc] initWithRegistrationId:registrationIDStr];
        api.hudString = @"";
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
            if (api.requestSuccess) {
                NSLog(@"注册成功");
            } else {
                NSLog(@"注册失败 = %@",api.errMessage);
            }
        } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
            NSLog(@"连接失败 = %@",api.errMessage);
        }];
    }
}

#pragma mark ----- 获取消息数据的处理
//handle JPush customize remote message 处理从服务器端发送来的极光通知
- (void)networkDidReceiveMessage:(NSNotification *)notification{
    
//    self.messageSum++;
    NSDictionary * userInfo = [notification userInfo];
    NSString *title = [userInfo valueForKey:@"title"];

//    //先将jsonStr转换为字典
//    NSDictionary *content = [self dictionaryWithJsonString:[userInfo valueForKey:@"content"]];
//
//    //来一个url的参数
//    self.messageUrl = [content valueForKey:@"messageLink"];
//    self.messageNavTitle = [content valueForKey:@"messageName"];
//
//    NSString * messageTitle = [content valueForKey:@"messageTitle"];
//    NSString * messageContent = [content valueForKey:@"messageContent"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSString *messageID = [userInfo valueForKey:@"_j_msgid"];
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];

//    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//    self.messageTime =  [NSDateFormatter localizedStringFromDate:[NSDate date]
//                                                       dateStyle:NSDateFormatterNoStyle
//                                                       timeStyle:NSDateFormatterMediumStyle];

//    NSString *currentContent = [NSString
//                                stringWithFormat:
//                                @"APP代理中收到自定义消息:%@\ntitle:%@\ncontent:%@\nextra:%@\nmessage:%ld\n,messageCount:%d\n",
//                                [NSDateFormatter localizedStringFromDate:[NSDate date]
//                                                               dateStyle:NSDateFormatterNoStyle
//                                                               timeStyle:NSDateFormatterMediumStyle],
//                                title, content, [self logDic:extras],(unsigned long)messageID,self.messageSum];
//    NSLog(@"代理中获取到数据参数为:%@", currentContent);
    
//    跳转啊 啊啊
//     [self goToMssageViewControllerWith:userInfo];
    
    //更新用户信息
    KNBLoginUserInfoApi *api = [[KNBLoginUserInfoApi alloc] init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            NSDictionary *dic = request.responseObject[@"list"];
            [[KNBUserInfo shareInstance] updateUserInfo:dic];
            //1.create a banner, custom all values
//            EBBannerView *banner = [EBBannerView bannerWithBlock:^(EBBannerViewMaker *make) {
//                make.style = EBBannerViewStyleiOS12;//custom system, default is current
//                //make.style = 9;
//                make.content = content;
//                //make.object = ...
//                //make.icon = ...
//                make.title = title;
//                //make.soundID = ...
//            }];
//
//            //2.show
//            [banner show];
            self.remoteNotificationUserInfo = userInfo;
            //UIApplicationStateActive = 在app界面; UIApplicationStateInactive = 未在app界面;
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
            {
                [self showLocalNotification];
                //[self showRemoteNotification];
            }
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
    }];
    /**
     * 通过 UNUserNotificationCenter 将自定义的消息推送到前台显示
     */
    
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];

//    建立本地通知，如果程序在后台的时候也会收到推送通知一样的消息。也可以判断在程序在前台的时候做一些特别的操作。
//     [JPUSHService setLocalNotification:[NSDate dateWithTimeIntervalSinceNow:3] alertBody:content badge:1 alertAction:title identifierKey:nil userInfo:userInfo soundName:nil];
    JPushNotificationContent * pushcontent = [[JPushNotificationContent alloc] init];
    pushcontent.title = title;
    pushcontent.body = content;
    pushcontent.badge = @(1);//@(+1);
    NSString *requestIdentifier = [NSString stringWithFormat:@"%@%@",dateString,messageID];
    JPushNotificationRequest *pushrequest = [[JPushNotificationRequest alloc] init];
    pushrequest.content = pushcontent;
    pushrequest.requestIdentifier = requestIdentifier;
    [JPUSHService addNotification:pushrequest];
    
    UNMutableNotificationContent * uucontent = [[UNMutableNotificationContent alloc] init];
    uucontent.title = title;
    uucontent.body = content;
    uucontent.badge = @(1);//@(+1);
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:uucontent trigger:nil];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        //界面的跳转 啊
        // [self goToMssageViewControllerWith:userInfo];
    }];
}

- (void)registerDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)handleRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
-(void)showLocalNotification
{
    if (@available(iOS 10.0, *)) {
        //必须写代理，不然无法监听通知的接收与点击事件
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.body = self.remoteNotificationUserInfo[@"data"][@"content"];
        content.userInfo = self.remoteNotificationUserInfo;
        content.sound = [UNNotificationSound defaultSound];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Notif" content:content trigger:nil];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        }];
    } else {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0.1];
        notification.repeatInterval = NSCalendarUnitDay;
        notification.alertBody = self.remoteNotificationUserInfo[@"data"][@"content"];
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}
#pragma clang diagnostic pop
//iOS 10以上接收消息处理消息
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    NSLog(@"iOS10122 点击通知栏收到远程通知:%@", userInfo);
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        //[self logDic:userInfo]
        NSLog(@"iOS10 点击通知栏收到远程通知:%@", userInfo);
        
        //点击通知栏进行消息界面的跳转 0
        [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
        [JPUSHService setBadge:0];//清空Jpush中存储的badge值
        
        //点击消息进行跳转到消息的详情界面中
//        [self goToMssageViewControllerWith:userInfo];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
        //处理自定义参数的数据
        //点击通知栏进行消息界面的跳转
        [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
        [JPUSHService setBadge:0];//清空Jpush中存储的badge值
        //点击消息进行跳转到消息的详情界面中
//        [self goToMssageViewControllerWith:content];
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    completionHandler();  // 系统要求执行这个方法 UIBackgroundFetchResultNewData
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)){
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
    } else {
        // Fallback on earlier versions
    }
}

@end
