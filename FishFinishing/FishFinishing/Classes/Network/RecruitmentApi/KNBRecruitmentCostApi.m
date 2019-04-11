//
//  KNBRecruitmentCostApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/11.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBRecruitmentCostApi.h"

@implementation KNBRecruitmentCostApi {
    NSInteger _cat_id;
    NSInteger _cost_type;
}

- (instancetype)initWithCatId:(NSInteger)catId costType:(NSInteger)costType {
    if (self = [super init]) {
        _cat_id = catId;
        _cost_type = costType;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBRecruitment_Cost];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"cat_id" : @(_cat_id),
                          @"cost_type" : @(_cost_type)
                          };
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}

@end
