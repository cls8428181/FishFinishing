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
 * 报货基本配置字典
 */
@property (nonatomic, strong) NSMutableDictionary *baseMuDicWithCargo;

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
 *  文章内容完整url
 *
 *  @param arcId 文章Id
 */
+ (NSString *)requestArticleId:(NSString *)articleId;

/**
 *  拼接加密秘钥 (妃子校)
 */
- (NSDictionary *)appendSecretDic;

/**
 *  拼接加密秘钥（美货）
 */
- (NSDictionary *)appendSecretDicWithCargo;

/**
 *  拼接加密秘钥（文章）
 */
- (NSDictionary *)appendSecretDicWithArticle;

/*
 * 获取缓存路径
 */
- (NSString *)cacheFilePath;

- (NSDictionary *)requestArgumentDicWithSecretKey:(NSString *)secretKey moreArgument:(NSDictionary *)moreDic;
/**字典转字符串*/
+ (NSString *)changeJsonStr:(NSDictionary *)dic;
@end
