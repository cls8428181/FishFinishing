//
//  KNBPayOrderStatusApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/17.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBPayOrderStatusApi.h"

@implementation KNBPayOrderStatusApi {
    NSString *_token;
    NSInteger _user_id;
    NSString *_orderid;
}
- (instancetype)initWithToken:(NSString *)token orderid:(NSString *)orderid {
    if (self = [super init]) {
        _token = token;
        _user_id = [[KNBUserInfo shareInstance].userId integerValue];
        _orderid = orderid;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBOrder_OrderStatus];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"token" : _token,
                          @"user_id" : @(_user_id),
                          @"orderid" : _orderid
                          }; //字典
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}

@end
