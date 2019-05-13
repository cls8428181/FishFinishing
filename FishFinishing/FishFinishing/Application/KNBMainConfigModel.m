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
NSString *const KNB_GetCollocation = @"/Api/Default/getCollocation";   // 获取配置信息
NSString *const KNB_RegistrationId = @"/Api/Index/setRegistrationId";   // 设置极光推送 token

#pragma mark - 登录
NSString *const KNBLogin_Register = @"/Api/Index/register";       //注册
NSString *const KNBLogin_SendCode = @"/Api/Index/sendcode"; //发送验证码
NSString *const KNBLogin_ThirdParty = @"/Api/Index/thirdlogin"; //第三方登录
NSString *const KNBLogin_Binding = @"/Api/Index/binding";        //绑定手机号
NSString *const KNBLogin_Modify = @"/Api/Index/changepwd";   //修改密码
NSString *const KNBLogin_ModifyUserInfo = @"/Api/Index/modify";//修改用户信息
NSString *const KNBLogin_Login = @"/Api/Index/login";              //登录
NSString *const KNBLogin_UserInfo = @"/Api/Index/getUserInfo";        //返回用户信息

#pragma mark - 首页
NSString *const KNBHome_Banner = @"/Api/Default/getbanner";      //获取 banner 图
NSString *const KNBHome_AllArea = @"/Api/Default/getarea";         //获取全部省市区信息
NSString *const KNBHome_SingleArea = @"/Api/Default/getregion"; //获取单独的省市区信息
NSString *const KNBHome_MassageList = @"/Api/Default/getMassageList"; //获取消息列表
NSString *const KNBHome_MassageDetail = @"/Api/Default/getMassage"; //获取消息详情
NSString *const KNBHome_MassageNum = @"/Api/Default/getMassageNum"; //获取消息数量
NSString *const KNBHome_RecommendCase = @"/Api/Facilitator/getRecommendCase"; //获取装修案例推荐列表
NSString *const KNBHome_DispatchList = @"/Api/Default/getDispatchList"; //获取预约订单列表
NSString *const KNBHome_DispatchStatus = @"/Api/Default/setDispatch";   //设置预约订单状态


#pragma mark - 入驻商家
NSString *const KNBRecruitment_Type = @"/Api/Facilitator/getcat";          //入驻商家类型
NSString *const KNBRecruitment_Cost = @"/Api/Facilitator/getcost";         //展示费用
NSString *const KNBRecruitment_Domain = @"/Api/Facilitator/gettag";      //擅长领域
NSString *const KNBRecruitment_Add = @"/Api/Facilitator/addFacilitator"; //添加商家
NSString *const KNBRecruitment_Detail = @"/Api/Facilitator/getDetail";     //商家详情
NSString *const KNBRecruitment_AddCase = @"/Api/Facilitator/addCase"; //添加案例
NSString *const KNBRecruitment_DelCase = @"/Api/Facilitator/delCase";   //删除案例
NSString *const KNBRecruitment_GetCase = @"/Api/Facilitator/getCase";   //装修案例详情
NSString *const KNBRecruitment_GetCatChild = @"/Api/Facilitator/getCatChild";   //获取服务商二级入驻类型
NSString *const KNBRecruitment_GetCaseList = @"/Api/Facilitator/getCaseList";   //根据条件获取案例列表
NSString *const KNBRecruitment_GetModify = @"/Api/Facilitator/getModify";   //获取修改服务商详情
NSString *const KNBRecruitment_ModifyFacilitator = @"/Api/Facilitator/modifyFacilitator";   //修改服务商信息
NSString *const KNBRecruitment_IncreaseBrowse = @"/Api/Facilitator/increaseBrowse";   //增加装修案列浏览量
NSString *const KNBRecruitment_Getlist = @"/Api/Facilitator/getlist";   //获取服务商列表
NSString *const KNBRecruitment_StickTime = @"/Api/Facilitator/getStickTime";   //获取置顶剩余时间
NSString *const KNBRecruitment_DefaultShow = @"/Api/Facilitator/setDefaultShow";   //推荐


#pragma mark - 免费预约
NSString *const KNBOrder_ServerType = @"/Api/Facilitator/getservice";            //免费预约服务类型
NSString *const KNBOrder_Style = @"/Api/Facilitator/getStyle";                   //装修风格
NSString *const KNBOrder_Area = @"/Api/Default/getarea";                         //获取所有省市区
NSString *const KNBOrder_Unit = @"/Api/Facilitator/getApartment";                //获取户型
NSString *const KNBOrder_AreaRange = @"/Api/Facilitator/getAreaRange";           //获取面积
NSString *const KNBOrder_ModifyPower = @"/Api/Facilitator/judgeModifyPower";     //检查是否有修改权限
NSString *const KNBOrder_CheckCaseNum = @"/Api/Facilitator/checkCaseNum";        //检查能否上传案例或产品
NSString *const KNBOrder_Bespoke = @"/Api/Default/bespoke";                      //免费预约
NSString *const KNBOrder_CheckBespoke = @"/Api/Default/checkBespoke";            //免费预约

#pragma mark - 支付相关
NSString *const KNBOrder_WechatPay = @"/Api/Payment/createOrderByWeiXin";        //微信支付统一下单接口
NSString *const KNBOrder_OrderStatus = @"/Api/Payment/getOrderStatus";        //查询订单状态
NSString *const KNBOrder_AlipayPay = @"/Api/Payment/createOrderByAlipay";        //支付宝支付统一下单接口




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
