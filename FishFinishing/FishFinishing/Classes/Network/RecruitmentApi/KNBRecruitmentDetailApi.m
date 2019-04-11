//
//  KNBRecruitmentDetailApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/11.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBRecruitmentDetailApi.h"

@implementation KNBRecruitmentDetailApi {
    NSInteger _fac_id;
}

- (instancetype)initWithfacId:(NSInteger)facId {
    if (self = [super init]) {
        _fac_id = facId;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBRecruitment_Detail];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"fac_id" : @(_fac_id)
                          };
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}

@end
