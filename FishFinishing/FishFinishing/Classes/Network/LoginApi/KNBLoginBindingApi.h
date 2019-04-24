//
//  KNBLoginBindingApi.h
//  FishFinishing
//
//  Created by apple on 2019/4/11.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBLoginBindingApi : KNBBaseRequest

/**
 手机号绑定

 @param mobile 手机号码
 @param code 验证码
 */
- (instancetype)initWithMobile:(NSString *)mobile code:(NSString *)code;

@end

NS_ASSUME_NONNULL_END
