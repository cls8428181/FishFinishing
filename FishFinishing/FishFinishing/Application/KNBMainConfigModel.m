//
//  KNBMainConfigModel.m
//  KenuoTraining
//
//  Created by Robert on 16/2/29.
//  Copyright © 2016年 Robert. All rights reserved.
//

NSString *const KNB_MainConfigKey = @"mainConfig";            //主配置
NSString *const KNB_InterfaceList = @"data";                  //接口列表
NSString *const KNB_ADvertising = @"advertising";             // 启动广告信息
NSString *const KNB_ADname = @"ads_name";                     //启动广告名称
NSString *const KNB_ADPhotoUrl = @"ad_pic";                   //启动广告图url
NSString *const KNB_ADJumpUrl = @"ad_url";                    //启动广告跳转url
NSString *const KNB_BaseUrlKey = @"base_url";                 //基本Url
NSString *const KN_Version = @"version";                              // 版本号
#pragma mark - 登录
NSString *const KNB_Login_Register = @"/Api/Index/register"; //注册
NSString *const KNB_Login_SendCode = @"/Api/Index/sendcode"; //发送验证码
NSString *const KNB_Login_ThirdParty = @"/Api/Index/thirdlogin"; //第三方登录



#import "KNBMainConfigModel.h"

@interface KNBMainConfigModel ()

@property (nonatomic, strong) NSDictionary *mainConfigDic;
//主配置接口dict
@property (nonatomic, strong) NSDictionary *interfaceListDic;
//主配置启动广告dict
@property (nonatomic, strong) NSDictionary *launchAdDict;

@end


@implementation KNBMainConfigModel

KNB_DEFINE_SINGLETON_FOR_CLASS(KNBMainConfigModel);

- (NSString *)getRequestUrlWithKey:(NSString *)key {
    NSString *url = [NSString stringWithFormat:@"%@%@",KNB_MAINCONFIGURL,key];;
    if (!isNullStr(url)) {
        //除去地址两端的空格
        return [url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    return @"";
}

- (NSDictionary *)interfaceListDic {
    return [[self mainConfigDic] objectForKey:KNB_InterfaceList];
}

- (NSDictionary *)launchAdDict {
    return [[self mainConfigDic] objectForKey:KNB_ADvertising];
}

- (NSString *)launch_adPhotoUrl {
    return [self.launchAdDict objectForKey:KNB_ADPhotoUrl] ?: @"";
}

- (NSString *)launch_adJumpUrl {
    return [self.launchAdDict objectForKey:KNB_ADJumpUrl] ?: @"";
}

- (NSString *)launch_adName {
    return [self.launchAdDict objectForKey:KNB_ADname] ?: @"";
}

- (NSDictionary *)mainConfigDic {
    return [[NSUserDefaults standardUserDefaults] objectForKey:KNB_MainConfigKey];
}

- (void)regestMainConfig:(id)request {
    if ([request[KNB_InterfaceList] isKindOfClass:[NSString class]] ||
        [request[KNB_InterfaceList] isKindOfClass:[NSNull class]]) {
        return;
    }
    NSLog(@"-------------主配置:%@",request);
    [[NSUserDefaults standardUserDefaults] setObject:request forKey:KNB_MainConfigKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


// 是否需要提示更新版本
- (NSString *)newVersion {
    NSString *envelope = [self getRequestUrlWithKey:KN_Version];
    if (isNullStr(envelope)) {
        return KNB_APP_VERSION;
    }
    return envelope;
}


@end
