//
//  KNBPayWechatApi.h
//  FishFinishing
//
//  Created by apple on 2019/4/17.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBPayWechatApi : KNBBaseRequest

/**
 手机登录的 ip
 */
@property (nonatomic, copy) NSString *ip;

- (instancetype)initWithToken:(NSString *)token payment:(double)payment type:(NSString *)type;
@end

NS_ASSUME_NONNULL_END
