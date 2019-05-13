//
//  KNBGetCollocationApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/26.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBGetCollocationApi.h"

@implementation KNBGetCollocationApi {
    NSString *_key;
}
- (instancetype)initWithKey:(NSString *)key {
    if (self = [super init]) {
        _key = key;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNB_GetCollocation];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"key" : _key
                          }; //字典
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}
@end
