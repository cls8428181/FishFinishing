//
//  KNBPayOrderStatusApi.h
//  FishFinishing
//
//  Created by apple on 2019/4/17.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBPayOrderStatusApi : KNBBaseRequest

- (instancetype)initWithToken:(NSString *)token orderid:(NSString *)orderid;

@end

NS_ASSUME_NONNULL_END
