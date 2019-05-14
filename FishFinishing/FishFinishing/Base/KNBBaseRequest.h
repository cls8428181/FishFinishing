//
//  KNBBaseRequest.h
//  KenuoTraining
//
//  Created by Robert on 16/3/12.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import <YTKRequest.h>
#import "KNBMainConfigModel.h"


@interface KNBBaseRequest : YTKRequest


/**
 *  请求时是否显示HUD
 */
@property (nonatomic, assign) BOOL needHud;

/**
 *  hud显示内容
 */
@property (nonatomic, copy) NSString *hudString;

/**
 *  基本配置字典 配置 ver_num
 */
@property (nonatomic, strong) NSMutableDictionary *baseMuDic;

/**
 *  获取请求返回状态
 *
 *  @return 状态码
 */
- (NSInteger)getRequestStatuCode;


/**
 *  状态码是否是 200
 */
- (BOOL)requestSuccess;

/**
 *  错误提示
 *
 *  @return 错误信息
 */
- (NSString *)errMessage;

/**
 *  拼接加密秘钥
 */
//- (NSDictionary *)appendSecretDic;

/*
 * 获取缓存路径
 */
- (NSString *)cacheFilePath;

- (NSDictionary *)requestArgumentDicWithSecretKey:(NSString *)secretKey moreArgument:(NSDictionary *)moreDic;
/**字典转字符串*/
+ (NSString *)changeJsonStr:(NSDictionary *)dic;

@end
