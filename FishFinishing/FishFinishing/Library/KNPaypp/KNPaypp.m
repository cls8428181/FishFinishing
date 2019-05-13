//
//  KNPaypp.m
//  KNPayppExample
//
//  Created by 吴申超 on 2017/4/5.
//  Copyright © 2017年 DengYun. All rights reserved.
//

#import "KNPaypp.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import <AlipaySDK/AlipaySDK.h>

#define KNPayppAlipayKey @"safepay"


@interface KNPayppError ()

@property (nonatomic, readwrite) KNPayppErrorOption code;

@end


@implementation KNPayppError

- (NSString *)errMsg {
    switch (self.code) {
        case KNPayppErrInvalidCharge:
            return @"不合法的支付信息";
            break;
        case KNPayppErrInvalidCredential:
            return @"未验证的证书";
            break;
        case KNPayppErrInvalidChannel:
            return @"未验证的支付渠道";
            break;
        case KNPayppErrWxNotInstalled:
            return @"当前未安装微信";
            break;
        case KNPayppErrWxAppNotSupported:
            return @"当前版本不支持OpenApi";
            break;
        case KNPayppErrCancelled:
            return @"取消支付";
            break;
        case KNPayppErrUnknownCancel:
            return @"未知原因取消支付";
            break;
        case KNPayppErrViewControllerIsNil:
            return @"当前界面的控制器不能为空";
            break;
        case KNPayppErrUnknownResult:
            return @"支付结果未知";
            break;
        case KNPayppErrRequestTimeOut:
            return @"支付请求超时";
            break;
        case KNPayppErrConnectionError:
            return @"链接错误";
            break;
        default:
            return @"未知原因错误";
            break;
    }
}

@end


@protocol KNPayWxResDelegate <NSObject>

- (void)knPayWxResError:(KNPayppError *)error;

@end


@interface KNPayWxRes : NSObject <WXApiDelegate>

@property (nonatomic, assign) id<KNPayWxResDelegate> delegate;
+ (instancetype)shareInstance;

@end


@implementation KNPayWxRes

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static KNPayWxRes *instance;
    dispatch_once(&onceToken, ^{
        instance = [[KNPayWxRes alloc] init];
    });
    return instance;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        //支付返回结果，实际支付结果需要去微信服务器端查询
        KNPayppError *payError = [[KNPayppError alloc] init];
        switch (resp.errCode) {
            case WXSuccess:
                payError = nil;
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
            case WXErrCodeCommon:
                payError.code = KNPayppErrUnknownError;
                break;
            case WXErrCodeUserCancel:
                payError.code = KNPayppErrCancelled;
                break;
            case WXErrCodeSentFail:
                payError.code = KNPayppErrRequestTimeOut;
                break;
            case WXErrCodeAuthDeny:
                payError.code = KNPayppErrConnectionError;
                break;
            case WXErrCodeUnsupport:
                payError.code = KNPayppErrWxAppNotSupported;
                break;
            default:
                payError.code = KNPayppErrUnknownError;
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode, resp.errStr);
                break;
        }
        if (_delegate && [_delegate respondsToSelector:@selector(knPayWxResError:)]) {
            [_delegate knPayWxResError:payError];
        }
    }
}

@end


@interface KNPaypp () <KNPayWxResDelegate>

@property (nonatomic, copy) KNPayppCompletion completion;

@end


@implementation KNPaypp

+ (instancetype)shareInstance {
    static KNPaypp *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[KNPaypp alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        __weak __typeof(self) weakSelf = self;
        [KNPayWxRes shareInstance].delegate = weakSelf;
    }
    return self;
}

+ (BOOL)registerWxApp:(NSString *)appId {
    return [WXApi registerApp:appId];
}

#pragma mark - KNPayWxResDelegate
- (void)knPayWxResError:(KNPayppError *)error {
    if (self.completion) {
        self.completion(error.errMsg, error);
    }
}


/**
 支付宝支付错误处理
 @param resultDic 回掉结果
 */
- (KNPayppError *)aliPayError:(NSDictionary *)resultDic {
    NSLog(@"reslut = %@", resultDic);
    NSInteger statusCode = [resultDic[@"resultStatus"] integerValue];
    if (statusCode == 9000) { // 支付成功
        if (self.completion) {
            self.completion(nil, nil);
        }
        return nil;
    } else {
        KNPayppError *payError = [[KNPayppError alloc] init];
        if (statusCode == 8000 || statusCode == 6004) {
            //支付结果未知，请查询商户订单列表中订单的支付状态
            payError.code = KNPayppErrUnknownResult;
        } else if (statusCode == 6001) {
            //用户中途取消
            payError.code = KNPayppErrCancelled;
        } else if (statusCode == 6002) {
            //网络连接出错
            payError.code = KNPayppErrConnectionError;
        } else { //其他错误
            payError.code = KNPayppErrUnknownError;
        }
        if (self.completion) {
            self.completion(nil, payError);
        }
        return payError;
    }
}


/**
 支付调用接口(支付宝／微信)
 
 @param charge 支付charge
 @param scheme URL Scheme，支付宝渠道回调需要
 @param completion 支付结果回调
 */
+ (void)createPayment:(id)charge
         appURLScheme:(NSString *)scheme
       withCompletion:(KNPayppCompletion)completion {
    [self createPayment:charge appURLScheme:scheme controller:nil withCompletion:completion];
}

+ (void)createPayment:(id)charge
         appURLScheme:(NSString *)scheme
           controller:(UIViewController *)controller
       withCompletion:(KNPayppCompletion)completion {
    KNPayppError *payError = [[KNPayppError alloc] init];
    if (!charge || [charge isKindOfClass:[NSNull class]]) {
        if (completion) {
            payError.code = KNPayppErrInvalidCharge;
            completion(payError.errMsg, payError);
        }
        return;
    }
    if ([scheme hasPrefix:@"wx"]) { //调起微信支付
        if (![WXApi isWXAppInstalled]) {
            payError.code = KNPayppErrWxNotInstalled;
            if (completion) {
                completion(payError.errMsg, payError);
            }
        } else if (![WXApi isWXAppSupportApi]) {
            payError.code = KNPayppErrWxAppNotSupported;
            if (completion) {
                completion(payError.errMsg, payError);
            }
        } else {
            NSDictionary *dict = [NSDictionary dictionaryWithDictionary:charge];
            if (dict) {
                PayReq *req = [[PayReq alloc] init];
                req.partnerId = dict[@"partnerid"];
                req.prepayId = dict[@"prepayid"];
                req.nonceStr = dict[@"noncestr"];
                req.package = dict[@"package"];
                req.sign = dict[@"sign"];
                NSString *stamp = dict[@"timestamp"];
                req.timeStamp = stamp.intValue;
                [WXApi sendReq:req];
                if (completion) {
                    [KNPaypp shareInstance].completion = completion;
                }
            } else {
                payError.code = KNPayppErrInvalidCharge;
                if (completion) {
                    completion(payError.errMsg, payError);
                }
            }
        }
    } else {
        [KNPaypp shareInstance].completion = completion;
        [[AlipaySDK defaultService] payOrder:charge fromScheme:scheme callback:^(NSDictionary *resultDic) {
            [[KNPaypp shareInstance] aliPayError:resultDic];
        }];
    }
}


/**
 回调结果接口
 
 @param url 结果url
 @param completion 支付结果回掉
 @return 当无法处理 URL 或者 URL 格式不正确时，会返回 NO
 */
+ (BOOL)handleOpenURL:(NSURL *)url withCompletion:(KNPayppCompletion)completion {
    NSString *urlHost = url.host;
    if ([urlHost isEqualToString:KNPayppAlipayKey]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            KNPayppError *error = [[KNPaypp shareInstance] aliPayError:resultDic];
            if (completion) {
                completion(nil, error);
            }
        }];

        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@", resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length > 0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode ?: @"");
        }];
    } else {
        return [WXApi handleOpenURL:url delegate:[KNPayWxRes shareInstance]];
    }
    return NO;
}


@end
