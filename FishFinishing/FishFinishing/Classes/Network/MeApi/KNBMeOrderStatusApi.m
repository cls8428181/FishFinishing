
//
//  KNBMeOrderStatusApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/24.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBMeOrderStatusApi.h"

@implementation KNBMeOrderStatusApi {
    NSInteger _dispatch_id;
    NSInteger _sign;
}
- (instancetype)initDispatchId:(NSInteger)dispatchId sign:(NSInteger)sign {
    if (self = [super init]) {
        _dispatch_id = dispatchId;
        _sign = sign;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBHome_DispatchStatus];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"dispatch_id" : @(_dispatch_id),
                          @"sign" : @(_sign)
                          }; //字典
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}
@end
