//
//  KNBMeOrderApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/24.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBMeOrderApi.h"

@implementation KNBMeOrderApi {
    NSInteger _fac_id;
}
- (instancetype)init {
    if (self = [super init]) {
        _fac_id = [[KNBUserInfo shareInstance].fac_id integerValue];
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBHome_DispatchList];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"fac_id" : @(_fac_id)
                          }; //字典
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}
@end
