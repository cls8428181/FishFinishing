//
//  KNBHomeRecommendCaseApi.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/22.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeRecommendCaseApi.h"

@implementation KNBHomeRecommendCaseApi {
    NSInteger _type;
}

- (instancetype)initWithType:(NSInteger)type {
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBHome_RecommendCase];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"type" : @(_type)
                          }; //字典
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}
@end
