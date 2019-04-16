//
//  KNBMainConfigModel.m
//  KenuoTraining
//
//  Created by Robert on 16/2/29.
//  Copyright © 2016年 Robert. All rights reserved.
//

NSString *const KNB_MainConfigKey = @"mainConfig";     //主配置
NSString *const KNB_InterfaceList = @"data";                  //接口列表
NSString *const KNB_ADvertising = @"advertising";          // 启动广告信息
NSString *const KNB_ADname = @"ads_name";               //启动广告名称256
NSString *const KNB_ADPhotoUrl = @"ad_pic";               //启动广告图url
NSString *const KNB_ADJumpUrl = @"ad_url";                //启动广告跳转url
NSString *const KNB_BaseUrlKey = @"base_url";            //基本Url
NSString *const KN_Version = @"version";                     // 版本号
NSString *const KNB_UploadFile = @"/Api/Facilitator/uploadImage";   // 上传图片

#pragma mark - 登录
NSString *const KNBLogin_Register = @"/Api/Index/register";       //注册
NSString *const KNBLogin_SendCode = @"/Api/Index/sendcode"; //发送验证码
NSString *const KNBLogin_ThirdParty = @"/Api/Index/thirdlogin"; //第三方登录
NSString *const KNBLogin_Binding = @"/Api/Index/binding";        //绑定手机号
NSString *const KNBLogin_Modify = @"/Api/Index/changepwd";   //修改密码
NSString *const KNBLogin_Login = @"/Api/Index/login";              //登录

#pragma mark - 首页
NSString *const KNBHome_Banner = @"/Api/Default/getbanner";      //获取 banner 图
NSString *const KNBHome_AllArea = @"/Api/Default/getarea";         //获取全部省市区信息
NSString *const KNBHome_SingleArea = @"/Api/Default/getregion"; //获取单独的省市区信息

#pragma mark - 入驻商家
NSString *const KNBRecruitment_Type = @"/Api/Facilitator/getcat";          //入驻商家类型
NSString *const KNBRecruitment_Cost = @"/Api/Facilitator/getcost";         //展示费用
NSString *const KNBRecruitment_Domain = @"/Api/Facilitator/gettag";      //擅长领域
NSString *const KNBRecruitment_Add = @"/Api/Facilitator/addFacilitator"; //添加商家
NSString *const KNBRecruitment_Detail = @"/Api/Facilitator/getDetail";     //商家详情
NSString *const KNBRecruitment_AddCase = @"/Api/Facilitator/addCase"; //添加案例
NSString *const KNBRecruitment_DelCase = @"/Api/Facilitator/delCase";   //删除案例
NSString *const KNBRecruitment_GetCase = @"/Api/Facilitator/getCase";   //装修案例详情

#pragma mark - 免费预约
NSString *const KNBOrder_ServerType = @"/Api/Facilitator/getservice";   //免费预约服务类型
NSString *const KNBOrder_Style = @"/Api/Facilitator/getStyle";               //装修风格
NSString *const KNBOrder_Area = @"/Api/Default/getarea";                    //获取所有省市区

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
