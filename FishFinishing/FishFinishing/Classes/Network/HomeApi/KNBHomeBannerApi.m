//
//  KNBHomeBannerApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/11.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBHomeBannerApi.h"

@implementation KNBHomeBannerApi {
    NSString *_vari;
    NSString *_city_name;
}

- (instancetype)initWithVari:(NSString *)vari cityName:(NSString *)cityName {
    if (self = [super init]) {
        _vari = vari;
        _city_name = cityName;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBHome_Banner];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"vari" : _vari,
                          @"city_name" : _city_name,
                          };
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}

@end
