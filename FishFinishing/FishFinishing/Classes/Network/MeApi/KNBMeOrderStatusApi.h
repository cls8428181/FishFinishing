//
//  KNBMeOrderStatusApi.h
//  FishFinishing
//
//  Created by apple on 2019/4/24.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBMeOrderStatusApi : KNBBaseRequest

- (instancetype)initDispatchId:(NSInteger)dispatchId sign:(NSInteger)sign;

@end

NS_ASSUME_NONNULL_END
