//
//  KNBHomeSingleAreaApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/11.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBHomeSingleAreaApi.h"

@implementation KNBHomeSingleAreaApi {
    NSInteger _area_id;
}

- (instancetype)initWithAreaId:(NSInteger)areaId {
    if (self = [super init]) {
        _area_id = areaId;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBHome_SingleArea];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"area_id" : @(_area_id)
                          };
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}

@end
