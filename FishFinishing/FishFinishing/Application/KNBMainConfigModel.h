//
//  KNBMainConfigModel.h
//  KenuoTraining
//
//  Created by Robert on 16/2/29.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "KNBBaseModel.h"

//主配置字典
extern NSString *const KNB_BaseUrlKey;
/**
 * 上传图片
 */
extern NSString *const KNB_UploadFile;
/**
 * 注册
 */
extern NSString *const KNBLogin_Register;
/**
 * 发送验证码
 */
extern NSString *const KNBLogin_SendCode;
/**
 * 第三方登录
 */
extern NSString *const KNBLogin_ThirdParty;
/**
 * 绑定手机号
 */
extern NSString *const KNBLogin_Binding;
/**
 * 修改密码
 */
extern NSString *const KNBLogin_Modify;
/**
 * 登录
 */
extern NSString *const KNBLogin_Login;

#pragma mark - 首页
/**
 * 获取 banner 图
 */
extern NSString *const KNBHome_Banner;
/**
 * 获取全部省市区信息
 */
extern NSString *const KNBHome_AllArea;
/**
 * 获取单独的省市区信息
 */
extern NSString *const KNBHome_SingleArea;

#pragma mark - 入驻商家
/**
 * 入驻商家类型
 */
extern NSString *const KNBRecruitment_Type;
/**
 * 展示费用
 */
extern NSString *const KNBRecruitment_Cost;
/**
 * 擅长领域
 */
extern NSString *const KNBRecruitment_Domain;
/**
 * 添加商家
 */
extern NSString *const KNBRecruitment_Add;
/**
 * 商家详情
 */
extern NSString *const KNBRecruitment_Detail;
/**
 * 添加案例
 */
extern NSString *const KNBRecruitment_AddCase;
/**
 * 删除案例
 */
extern NSString *const KNBRecruitment_DelCase;
/**
 * 装修案例详情
 */
extern NSString *const KNBRecruitment_GetCase;

#pragma mark - 免费预约
/**
 * 免费预约服务类型
 */
extern NSString *const KNBOrder_ServerType;
/**
 * 装修风格
 */
extern NSString *const KNBOrder_Style;

@interface KNBMainConfigModel : NSObject

// 启动广告图url
@property (nonatomic, copy) NSString *launch_adPhotoUrl;
// 启动广告跳转url
@property (nonatomic, copy) NSString *launch_adJumpUrl;
// 启动广告标题
@property (nonatomic, copy) NSString *launch_adName;

+ (instancetype)shareInstance;

- (void)regestMainConfig:(id)request;

- (NSString *)getRequestUrlWithKey:(NSString *)key;

- (NSString *)newVersion;

@end
