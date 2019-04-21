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

@implementation KNPayManager

+ (void)payWithOrderId:(NSString *)orderId
              payPrice:(double)payPrice
             payMethod:(NSString *)payMethod
            controller:(UIViewController *)controller
            chargeType:(KNBGetChargeType)type
         completeBlock:(void (^)(BOOL success, id errorMsg, NSInteger errorCode))complete {
    
    if ([payMethod isEqualToString:KN_PayCodeWX]) {
        KNBPayWechatApi *api = [[KNBPayWechatApi alloc] initWithToken:[KNBUserInfo shareInstance].token payment:payPrice type:type == KNBGetChargeTypeRecruitment ? @"1" : @"2"];
        api.hudString = @"";
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
            if (api.requestSuccess) {
                id charge = request.responseJSONObject[@"list"];
                [self startPay:charge payMethod:payMethod controller:controller completeBlock:complete];
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
        KNBPayAlipyApi *api = [[KNBPayAlipyApi alloc] initWithToken:[KNBUserInfo shareInstance].token payment:payPrice type:type == KNBGetChargeTypeRecruitment ? @"1" : @"2"];
        api.hudString = @"";
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
            if (api.requestSuccess) {
                id charge = request.responseJSONObject[@"list"];
                [self startPay:charge payMethod:payMethod controller:controller completeBlock:complete];
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
      controller:(UIViewController *)controller
   completeBlock:(void (^)(BOOL success, id errorMsg, NSInteger errorCode))complete {
    NSString *urlScheme;
    if ([payMethod isEqualToString:KN_PayCodeWX]) {
        urlScheme = KN_WXUrlScheme;
    }else{
        urlScheme = KN_AlpiyUrlScheme;
    }
    [KNPaypp createPayment:charge
              appURLScheme:urlScheme
            withCompletion:^(NSString *result, KNPayppError *error) {
                NSLog(@"completion block: %@ ", result);
                NSLog(@"KNPayppError: code=%lu msg=%@", (unsigned long)error.code, [error errMsg]);

                if (error == nil) {
                    if (complete) {
                        complete(YES, nil, 0);
                    }
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


@end
