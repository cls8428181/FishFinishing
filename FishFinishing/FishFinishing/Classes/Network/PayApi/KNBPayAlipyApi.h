//
//  KNBPayAlipyApi.h
//  FishFinishing
//
//  Created by apple on 2019/4/17.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBPayAlipyApi : KNBBaseRequest

/**
 费用 id
 */
@property (nonatomic, assign) NSInteger costId;

- (instancetype)initWithPayment:(double)payment type:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
