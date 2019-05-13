//
//  KNBTopRemainingTimeApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/25.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBTopRemainingTimeApi.h"

@implementation KNBTopRemainingTimeApi {
    NSInteger _fac_id;
}
- (instancetype)initWithFacId:(NSInteger)facId {
    if (self = [super init]) {
        _fac_id = facId;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBRecruitment_StickTime];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"fac_id" : @(_fac_id)
                          }; //字典
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}

@end
