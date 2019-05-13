//
//  KNBRecruitmentServiceListApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/17.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBRecruitmentServiceListApi.h"

@implementation KNBRecruitmentServiceListApi {
    NSString *_lng;
    NSString *_lat;
}
- (instancetype)initWithLng:(NSString *)lng lat:(NSString *)lat {
    if (self = [super init]) {
        _lng = lng;
        _lat = lat;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBRecruitment_Getlist];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"lng" : _lng ?: @"",
                          @"lat" : _lat ?: @"",
                          @"page" : @(_page) ?: @(1),
                          @"limit" : @(_limit) ?: @(10),
                          @"city_name" : _city_name ?: [KNGetUserLoaction shareInstance].cityName,
                          @"area_name" : _area_name?: @"",
                          @"cat_parent_id" : @(_cat_parent_id),
                          @"cat_id" : @(_cat_id) ?: @(0),
                          @"order" : @(_order) ?: @(0)
                          }; //字典
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}
@end
