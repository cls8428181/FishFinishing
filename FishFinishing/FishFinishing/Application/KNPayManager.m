//
//  KNGoodsPayManager.m
//  Concubine
//
//  Created by ... on 16/7/2.
//  Copyright © 2016年 dengyun. All rights reserved.
//

#import "KNPayManager.h"
#import "LCProgressHUD.h"
#import "KNPaypp.h"
#import "KNBPayWechatApi.h"
#import "KNBPayAlipyApi.h"
#import "KNBPayOrderStatusApi.h"

@implementation KNPayManager

+ (void)payWithOrderId:(NSString *)orderId
              payPrice:(double)payPrice
             payMethod:(NSString *)payMethod
            chargeType:(KNBGetChargeType)type
         completeBlock:(void (^)(BOOL success, id errorMsg, NSInteger errorCode))complete {
    
    if ([payMethod isEqualToString:KN_PayCodeWX]) {
        KNBPayWechatApi *api = [[KNBPayWechatApi alloc] initWithPayment:payPrice type:type == KNBGetChargeTypeRecruitment ? @"1" : @"2"];
        api.costId = [orderId integerValue];
        api.hudString = @"";
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
            if (api.requestSuccess) {
                NSDictionary *dic = request.responseJSONObject[@"list"];
                [[NSUserDefaults standardUserDefaults] setObject:dic[@"orderid"] forKey:@"orderid"];
                if ([request.responseJSONObject[@"status"] isEqualToString:@"1"]) {
                    if (complete) {
                        complete(YES, api.errMessage, api.getRequestStatuCode);
                    }
                } else {
                    [self startPay:dic payMethod:payMethod orderId:dic[@"orderid"] completeBlock:complete];
                }

            } else {
                if (complete) {
                    complete(NO, api.errMessage, api.getRequestStatuCode);
                }
            }
        } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
            if (complete) {
                complete(NO, @"出错啦!", 0);
            }
        }];
    } else {
        KNBPayAlipyApi *api = [[KNBPayAlipyApi alloc] initWithPayment:payPrice type:type == KNBGetChargeTypeRecruitment ? @"1" : @"2"];
        api.costId = [orderId integerValue];
        api.hudString = @"";
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
            if (api.requestSuccess) {
                NSDictionary *dic = request.responseJSONObject[@"list"];
                [[NSUserDefaults standardUserDefaults] setObject:dic[@"orderid"] forKey:@"orderid"];

                if ([request.responseJSONObject[@"status"] isEqualToString:@"1"]) {
                    if (complete) {
                        complete(YES, api.errMessage, api.getRequestStatuCode);
                    }
                } else {
                    NSString *sign = dic[@"sign"];
                    [self startPay:sign payMethod:payMethod orderId:dic[@"orderid"] completeBlock:complete];
                }

            } else {
                if (complete) {
                    complete(NO, api.errMessage, api.getRequestStatuCode);
                }
            }
        } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
            if (complete) {
                complete(NO, @"出错啦!", 0);
            }
        }];
    }
}


+ (void)startPay:(NSObject *)charge
       payMethod:(NSString *)payMethod
         orderId:(NSString *)orderId
   completeBlock:(void (^)(BOOL success, id errorMsg, NSInteger errorCode))complete {
    NSString *urlScheme;
    if ([payMethod isEqualToString:KN_PayCodeWX]) {
        urlScheme = KN_WXUrlScheme;
    }else{
        urlScheme = KN_AlipyUrlScheme;
    }
    [KNPaypp createPayment:charge
              appURLScheme:urlScheme
            withCompletion:^(NSString *result, KNPayppError *error) {
                NSLog(@"completion block: %@ ", result);
                NSLog(@"KNPayppError: code=%lu msg=%@", (unsigned long)error.code, [error errMsg]);

                if (error == nil) {
                    [self queryOrderStatus:orderId completeBlock:complete];
                } else if (error.code == KNPayppErrCancelled) {
                    if (complete) {
                        complete(NO, [error errMsg], KNPayppErrCancelled);
                    }
                } else {
                    if (complete) {
                        complete(NO, [error errMsg], 0);
                    }
                }
            }];
}

+ (void)queryOrderStatus:(NSString *)orderId completeBlock:(void (^)(BOOL success, id errorMsg, NSInteger errorCode))complete {
    KNBPayOrderStatusApi *api = [[KNBPayOrderStatusApi alloc] initWithOrderid:orderId];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            NSDictionary *dic = request.responseObject[@"list"];
            NSString *status = dic[@"order_status"];
            if ([status isEqualToString:@"1"]) {
                if (complete) {
                    complete(YES, nil, 0);
                }
            }

        } else {
            [LCProgressHUD showMessage:api.errMessage];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [LCProgressHUD showMessage:api.errMessage];
    }];

}


@end
