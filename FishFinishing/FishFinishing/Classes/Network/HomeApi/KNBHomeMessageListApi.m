//
//  KNBHomeMessageListApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/17.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBHomeMessageListApi.h"

@implementation KNBHomeMessageListApi {
    NSInteger _page;
    NSInteger _limit;
}

- (instancetype)initWithPage:(NSInteger)page limit:(NSInteger)limit {
    if (self = [super init]) {
        _page = page;
        _limit = limit;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBHome_MassageList];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"page" : @(_page),
                          @"limit" : @(_limit)
                          }; //字典
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}
@end
