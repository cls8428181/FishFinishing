//
//  KNBLoginLoginApi.h
//  FishFinishing
//
//  Created by apple on 2019/4/11.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBLoginLoginApi : KNBBaseRequest

/**
 登录

 @param mobile 手机号码
 @param password 密码
 */
- (instancetype)initWithMobile:(NSString *)mobile password:(NSString *)password;

@end

NS_ASSUME_NONNULL_END
