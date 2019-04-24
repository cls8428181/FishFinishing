//
//  KNBPayWechatApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/17.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBPayWechatApi.h"

@implementation KNBPayWechatApi {
    double _payment;
    NSString *_type;
}
- (instancetype)initWithPayment:(double)payment type:(NSString *)type {
    if (self = [super init]) {
        _payment = payment;
        _type = type;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBOrder_WechatPay];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"payment" : @(_payment),
                          @"type" : _type,
                          @"ip" : _ip
                          }; //字典
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}
@end
