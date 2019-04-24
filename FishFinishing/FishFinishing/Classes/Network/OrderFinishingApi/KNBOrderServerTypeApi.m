//
//  KNBOrderServerTypeApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/11.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBOrderServerTypeApi.h"

@implementation KNBOrderServerTypeApi {
    NSInteger _catId;
}

- (instancetype)initWithCatId:(NSInteger)catId {
    if (self = [super init]) {
        _catId = catId;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBOrder_ServerType];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"cat_id" : @(_catId),
                          };
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}


@end
