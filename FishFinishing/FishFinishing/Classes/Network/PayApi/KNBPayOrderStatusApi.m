//
//  KNBPayOrderStatusApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/17.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBPayOrderStatusApi.h"

@implementation KNBPayOrderStatusApi {
    NSString *_orderid;
}
- (instancetype)initWithOrderid:(NSString *)orderid {
    if (self = [super init]) {
        _orderid = orderid;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBOrder_OrderStatus];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"orderid" : _orderid
                          }; //字典
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}

@end
