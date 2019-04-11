//
//  KNBLoginRegisterApi.h
//  FishFinishing
//
//  Created by apple on 2019/4/10.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBLoginRegisterApi : KNBBaseRequest

/**
 注册

 @param mobile 手机号码
 @param code 验证码
 @param password 密码
 @param repassword 确认密码
 */
- (instancetype)initWithMobile:(NSString *)mobile code:(NSString *)code password:(NSString *)password repassword:(NSString *)repassword;

@end

NS_ASSUME_NONNULL_END
