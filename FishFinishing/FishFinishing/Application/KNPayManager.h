//
//  KNGoodsPayManager.h
//  Concubine
//
//  Created by ... on 16/7/2.
//  Copyright © 2016年 dengyun. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KNPayManager : NSObject

#pragma mark - 通过订单id去支付

/**
 *  通过订单id去支付
 *
 *  @param orderId    订单id
 *  @param payMethod  支付方式
 *  @param complete   回调
 */
+ (void)payWithOrderId:(NSString *)orderId
              payPrice:(double)payPrice
             payMethod:(NSString *)payMethod
            chargeType:(KNBGetChargeType)type
         completeBlock:(void (^)(BOOL success, id errorMsg, NSInteger errorCode))complete;


@end
