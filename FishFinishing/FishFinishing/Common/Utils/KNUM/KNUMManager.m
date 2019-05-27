//
//  KNUMManager.m
//  Concubine
//
//  Created by 吴申超 on 16/8/30.
//  Copyright © 2016年 dengyun. All rights reserved.
//

#import "KNUMManager.h"
#import "KNBMainConfigModel.h"
#import <UMCommon/UMConfigure.h>
#import <UMAnalytics/MobClick.h>
#import <UShareUI/UShareUI.h>
#import "LCProgressHUD.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"
#import "ShareView.h"
// 友盟AppKey
#define KN_UMAppKey @"5cc29b4e570df3c1d2000860"

#define KN_WeixinAppId @"wx59d8ae90819ba21f"
#define KN_WeixinAppSecret @"314f7e172448d2e4c43fae1644eecc05"
#define KN_WeiboAppId @"2319923337"
#define KN_WeiboAppSecret @"609e2e4c0801e6233f85056059f3b4c2"
#define KN_QQAppId @"101564573"
#define KN_QQAppSecret @"tV0Fmd0yOwvHt3fr"


@interface KNUMManager ()

@end


@implementation KNUMManager

+ (instancetype)shareInstance {
    static KNUMManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[KNUMManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self configuraUM];
    }
    return self;
}

/**
 *  友盟配置
 */
- (void)configuraUM {
    //友盟平台统一配置AppKey
    [UMConfigure initWithAppkey:KN_UMAppKey channel:@"App Store"];

    //友盟统计
    // 开启Crash收集
    [MobClick setCrashReportEnabled:YES];
    //统计场景
    [MobClick setScenarioType:E_UM_NORMAL];

    // 友盟分享
    //打开图片水印
    [UMSocialGlobal shareInstance].isUsingWaterMark = NO;

    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:KN_WeixinAppId appSecret:KN_WeixinAppSecret redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:KN_QQAppId appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];

    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:KN_WeiboAppId appSecret:nil redirectURL:@"http://sns.whalecloud.com/sina2/callback"];

    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[ @(UMSocialPlatformType_WechatFavorite)]];

    [UMSocialUIManager setPreDefinePlatforms:@[ @(UMSocialPlatformType_WechatSession), @(UMSocialPlatformType_WechatTimeLine), @(UMSocialPlatformType_QQ) , @(UMSocialPlatformType_Qzone) ,@(UMSocialPlatformType_Sina)]];
}


/**
 * 友盟网页分享
 */
- (void)showShareViewWithShareInfoTitle:(NSString *)title
                         shareImageName:(NSString *)shareImageName
                                   desc:(NSString *)desc
                               shareUrl:(NSString *)shareUrl
                  currentViewController:(UIViewController *)currentViewController {
    KNB_WS(weakSelf);
    //更改成对应的跳转方式
    BOOL hadInstalledWeixin = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
    BOOL hadInstalledQQ = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
    
    NSMutableArray *titlearr     = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *imageArr     = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *typeArr     = [NSMutableArray arrayWithCapacity:5];
    
    if (hadInstalledWeixin) {
        [titlearr addObjectsFromArray:@[@"微信", @"微信朋友圈"]];
        [imageArr addObjectsFromArray:@[@"knb_share_wechat",@"knb_share_wechattimeline"]];
        [typeArr addObjectsFromArray:@[@(KNUMManagerShareWeChat), @(KNUMManagerShareWeChatTimeline)]];
    }
    if (hadInstalledQQ) {
        [titlearr addObjectsFromArray:@[@"QQ", @"QQ空间"]];
        [imageArr addObjectsFromArray:@[@"knb_share_qq",@"knb_share_qzone"]];
        [typeArr addObjectsFromArray:@[@(KNUMManagerShareQQ), @(KNUMManagerShareQZone)]];
    }
    [titlearr addObjectsFromArray:@[@"微博"]];
    [imageArr addObjectsFromArray:@[@"knb_share_sina"]];
    [typeArr addObject:@(KNUMManagerShareWeibo)];
    
    ShareView *shareView = [[ShareView alloc] initWithShareHeadOprationWith:titlearr andImageArry:imageArr andProTitle:nil];
    [shareView setBtnClick:^(NSInteger btnTag) {
        NSLog(@"\n点击第几个====%d\n当前选中的按钮title====%@",(int)btnTag,titlearr[btnTag]);
        [weakSelf shareToPlatform:[typeArr[btnTag] integerValue] title:title url:shareUrl descr:desc shareImageName:shareImageName currentVC:currentViewController];
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
}

- (void)shareToPlatform:(UShareWXMiniProgramType)type title:(NSString *)title url:(NSString *)shareUrl descr:(NSString *)desc shareImageName:(NSString *)shareImageName currentVC:(UIViewController *)currentVC {
    
    switch (type) {
        case KNUMManagerShareWeChat:
            NSLog(@"分享至微信");
            [self shareWebPage:currentVC toPlatformType:UMSocialPlatformType_WechatSession withTitle:title url:shareUrl descr:desc shareImageName:shareImageName withTransmit:NO];
            break;
        case KNUMManagerShareWeChatTimeline:
            NSLog(@"分享至朋友圈");
            [self shareWebPage:currentVC toPlatformType:UMSocialPlatformType_WechatTimeLine withTitle:title url:shareUrl descr:desc shareImageName:shareImageName withTransmit:NO];
            break;
        case KNUMManagerShareQQ:
            NSLog(@"分享至QQ");
            [self shareWebPage:currentVC toPlatformType:UMSocialPlatformType_QQ withTitle:title url:shareUrl descr:desc shareImageName:shareImageName withTransmit:NO];
            break;
        case KNUMManagerShareQZone:
            NSLog(@"分享至QQ空间");
            [self shareWebPage:currentVC toPlatformType:UMSocialPlatformType_Qzone withTitle:title url:shareUrl descr:desc shareImageName:shareImageName withTransmit:NO];
            break;
        case KNUMManagerShareWeibo:
            NSLog(@"分享至微博");
            [self shareWebPage:currentVC toPlatformType:UMSocialPlatformType_Sina withTitle:title url:shareUrl descr:desc shareImageName:shareImageName withTransmit:NO];
            break;
        default:
            break;
    }
}

/**
 * 友盟图片分享
 */
- (void)showShareViewWithShareInfoTitle:(NSString *)title
                             shareImage:(UIImage *)shareImage
                                   desc:(NSString *)desc
                  currentViewController:(UIViewController *)currentViewController {
    KNB_WS(weakSelf);
    //更改成对应的跳转方式
    BOOL hadInstalledWeixin = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
    BOOL hadInstalledQQ = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
    
    NSMutableArray *titlearr     = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *imageArr     = [NSMutableArray arrayWithCapacity:5];
    NSMutableArray *typeArr     = [NSMutableArray arrayWithCapacity:5];
    
    if (hadInstalledWeixin) {
        [titlearr addObjectsFromArray:@[@"微信", @"微信朋友圈"]];
        [imageArr addObjectsFromArray:@[@"knb_share_wechat",@"knb_share_wechattimeline"]];
        [typeArr addObjectsFromArray:@[@(KNUMManagerShareWeChat), @(KNUMManagerShareWeChatTimeline)]];
    }
    if (hadInstalledQQ) {
        [titlearr addObjectsFromArray:@[@"QQ", @"QQ空间"]];
        [imageArr addObjectsFromArray:@[@"knb_share_qq",@"knb_share_qzone"]];
        [typeArr addObjectsFromArray:@[@(KNUMManagerShareQQ), @(KNUMManagerShareQZone)]];
    }
    [titlearr addObjectsFromArray:@[@"微博"]];
    [imageArr addObjectsFromArray:@[@"knb_share_sina"]];
    [typeArr addObject:@(KNUMManagerShareWeibo)];
    
    ShareView *shareView = [[ShareView alloc] initWithShareHeadOprationWith:titlearr andImageArry:imageArr andProTitle:nil];
    [shareView setBtnClick:^(NSInteger btnTag) {
        NSLog(@"\n点击第几个====%d\n当前选中的按钮title====%@",(int)btnTag,titlearr[btnTag]);
        [weakSelf shareToPlatform:[typeArr[btnTag] integerValue] title:title descr:desc shareImage:shareImage currentVC:currentViewController];
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
}

- (void)shareToPlatform:(UShareWXMiniProgramType)type title:(NSString *)title descr:(NSString *)desc shareImage:(UIImage *)shareImage currentVC:(UIViewController *)currentVC {
    
    switch (type) {
        case KNUMManagerShareWeChat:
            NSLog(@"分享至微信");
            [self shareImagePage:currentVC toPlatformType:UMSocialPlatformType_WechatSession withTitle:title descr:desc shareImage:shareImage];
            break;
        case KNUMManagerShareWeChatTimeline:
            NSLog(@"分享至朋友圈");
            [self shareImagePage:currentVC toPlatformType:UMSocialPlatformType_WechatTimeLine withTitle:title descr:desc shareImage:shareImage];
            break;
        case KNUMManagerShareQQ:
            NSLog(@"分享至QQ");
            [self shareImagePage:currentVC toPlatformType:UMSocialPlatformType_QQ withTitle:title descr:desc shareImage:shareImage];
            break;
        case KNUMManagerShareQZone:
            NSLog(@"分享至QQ空间");
            [self shareImagePage:currentVC toPlatformType:UMSocialPlatformType_Qzone withTitle:title descr:desc shareImage:shareImage];
            break;
        case KNUMManagerShareWeibo:
            NSLog(@"分享至微博");
            [self shareImagePage:currentVC toPlatformType:UMSocialPlatformType_Sina withTitle:title descr:desc shareImage:shareImage];
            break;
        default:
            break;
    }
}



- (void)showShareViewWithShareInfoTitle:(NSString *)title
                             shareImage:(UIImage *)shareImage
                                   desc:(NSString *)desc
                               shareUrl:(NSString *)shareUrl
                  currentViewController:(UIViewController *)currentViewController {
    KNB_WS(weakSelf)
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            [weakSelf shareWebPage:currentViewController toPlatformType:platformType withTitle:title url:shareUrl descr:desc shareImage:shareImage];
        }];
}

//网页分享
- (void)shareWebPage:(UIViewController *)controller toPlatformType:(UMSocialPlatformType)platformType withTitle:(NSString *)title url:(NSString *)url descr:(NSString *)desc shareImageName:(NSString *)shareImageName withTransmit:(BOOL)transmit {
    UIImage *shareImage;
    if (isNullStr(shareImageName)) {
        shareImage = [UIImage imageNamed:@"knb_icon_logo"];
    } else {
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:shareImageName]];
        shareImage = [UIImage imageWithData:imageData];
    }
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:shareImage];
    //设置网页地址
    shareObject.webpageUrl = url;

    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;

    //调用分享接口
    KNB_WS(weakSelf);
    [[UMSocialManager defaultManager] shareToPlatform:platformType
                                        messageObject:messageObject
                                currentViewController:controller
                                           completion:^(id data, NSError *error) {
                                               if (error) {
                                                   if (transmit) {
                                                       [LCProgressHUD showMessage:@"转发取消!"];
                                                   } else {
                                                       [LCProgressHUD showMessage:@"分享取消!"];
                                                   }
                                               } else {
                                                   if (transmit) {
                                                       [LCProgressHUD showMessage:@"转发成功!"];
                                                   } else {
                                                       [LCProgressHUD showMessage:@"分享成功!"];
                                                   }
                                                   if (weakSelf.completeBlock) {
                                                       weakSelf.completeBlock(YES);
                                                   }
                                                   if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                                                       UMSocialShareResponse *resp = data;
                                                       //分享结果消息
                                                       NSLog(@"response message is %@", resp.message);
                                                       //第三方原始返回的数据
                                                       NSLog(@"response originalResponse data is %@", resp.originalResponse);

                                                   } else {
                                                       NSLog(@"response data is %@", data);
                                                   }
                                               }
                                           }];
}

//网页分享
- (void)shareWebPage:(UIViewController *)controller toPlatformType:(UMSocialPlatformType)platformType withTitle:(NSString *)title url:(NSString *)url descr:(NSString *)desc shareImage:(UIImage *)shareImage {
    if (!shareImage) {
        shareImage = [UIImage imageNamed:@"shareIcon"];
    }
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:desc thumImage:shareImage];
    //设置网页地址
    shareObject.webpageUrl = url;

    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;

    //调用分享接口
    KNB_WS(weakSelf);
    [[UMSocialManager defaultManager] shareToPlatform:platformType
                                        messageObject:messageObject
                                currentViewController:controller
                                           completion:^(id data, NSError *error) {
                                               if (error) {
                                                   NSLog(@"---------失败原因--%@", error.userInfo);
                                                   [LCProgressHUD showMessage:@"分享取消!"];
                                               } else {
                                                   [LCProgressHUD showMessage:@"分享成功!"];
                                                   if (weakSelf.completeBlock) {
                                                       weakSelf.completeBlock(YES);
                                                   }
                                                   if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                                                       UMSocialShareResponse *resp = data;
                                                       //分享结果消息
                                                       NSLog(@"response message is %@", resp.message);
                                                       //第三方原始返回的数据
                                                       NSLog(@"response originalResponse data is %@", resp.originalResponse);

                                                   } else {
                                                       NSLog(@"response data is %@", data);
                                                   }
                                               }
                                           }];
}

//图片分享
- (void)shareImagePage:(UIViewController *)controller toPlatformType:(UMSocialPlatformType)platformType withTitle:(NSString *)title descr:(NSString *)desc shareImage:(UIImage *)shareImage {
    if (!shareImage) {
        shareImage = [UIImage imageNamed:@"shareIcon"];
    }
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:title descr:desc thumImage:shareImage];
    //设置网页地址
    shareObject.shareImage = shareImage;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    KNB_WS(weakSelf);
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:controller completion:^(id data, NSError *error) {
        
        if (error) {
            NSLog(@"---------失败原因--%@", error.userInfo);
            [LCProgressHUD showMessage:@"分享取消!"];
        } else {
            [LCProgressHUD showMessage:@"分享成功!"];
            if (weakSelf.completeBlock) {
                weakSelf.completeBlock(YES);
            }
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                NSLog(@"response message is %@", resp.message);
                //第三方原始返回的数据
                NSLog(@"response originalResponse data is %@", resp.originalResponse);
                
            } else {
                NSLog(@"response data is %@", data);
            }
        }
    }];
}


/**
 分享类型转换
 */
- (NSString *)shareMethod:(UMSocialPlatformType)platformType {
    switch (platformType) {
        case UMSocialPlatformType_Sina:
            return @"新浪";
        case UMSocialPlatformType_WechatSession:
            return @"微信";
        case UMSocialPlatformType_WechatTimeLine:
            return @"朋友圈";
        case UMSocialPlatformType_QQ:
            return @"QQ";
        case UMSocialPlatformType_Sms:
            return @"短信";
        default:
            break;
    }
    return @"";
}


+ (BOOL)isQQInstalled {
    return [[UMSocialQQHandler defaultManager] umSocial_isInstall];
}

+ (BOOL)isWeChatInstalled {
    return [[UMSocialWechatHandler defaultManager] umSocial_isInstall];
}

- (BOOL)isUrlString {
    NSString *emailRegex = @"[a-zA-z]+://.*";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

@end
