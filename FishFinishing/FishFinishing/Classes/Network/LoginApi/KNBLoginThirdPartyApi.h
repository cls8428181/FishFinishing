//
//  KNBLoginThirdPartyApi.h
//  FishFinishing
//
//  Created by apple on 2019/4/10.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseRequest.h"

typedef NS_ENUM(NSInteger, KNBLoginThirdPartyType) {
    KNBLoginThirdPartyTypeWechat = 0,      //微信
    KNBLoginThirdPartyTypeBlog,                //新浪微博
    KNBLoginThirdPartyTypeQQ                  //QQ
};

NS_ASSUME_NONNULL_BEGIN

@interface KNBLoginThirdPartyApi : KNBBaseRequest

/**
 第三方登录

 @param openid 唯一标识
 @param loginType 第三方登录类型 weixin微信 weibo微博 qq
 */
- (instancetype)initWithOpenid:(NSString *)openid loginType:(KNBLoginThirdPartyType)loginType;
@end

NS_ASSUME_NONNULL_END
