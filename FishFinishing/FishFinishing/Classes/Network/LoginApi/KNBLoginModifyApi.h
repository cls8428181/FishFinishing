//
//  KNBLoginModifyApi.h
//  FishFinishing
//
//  Created by apple on 2019/4/11.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBLoginModifyApi : KNBBaseRequest

/**
 修改密码

 @param mobile 手机号码
 @param code 验证码
 @param token 用户登录标识
 @param password 密码
 @param repassword 确认密码
 */
- (instancetype)initWithMobile:(NSString *)mobile code:(NSString *)code token:(NSString *)token password:(NSString *)password repassword:(NSString *)repassword;

@end

NS_ASSUME_NONNULL_END
