//
//  KNBPayAlipyApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/17.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBPayAlipyApi.h"

@implementation KNBPayAlipyApi {
    NSString *_token;
    NSInteger _user_id;
    double _payment;
    NSString *_type;
}
- (instancetype)initWithToken:(NSString *)token payment:(double)payment type:(NSString *)type {
    if (self = [super init]) {
        _token = token;
        _user_id = [[KNBUserInfo shareInstance].userId integerValue];
        _payment = payment;
        _type = type;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBOrder_AlipayPay];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"token" : _token,
                          @"user_id" : @(_user_id),
                          @"payment" : @(_payment),
                          @"type" : _type
                          }; //字典
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.appendSecretDic;
}

@end
