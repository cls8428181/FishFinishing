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
                          @"lng" : _lng,
                          @"lat" : _lat,
                          @"page" : @(_page),
                          @"limit" : @(_limit),
                          @"city_name" : _city_name,
                          @"area_name" : _area_name,
                          @"cat_parent_id" : @(_cat_parent_id),
                          @"cat_id" : @(_cat_id)
                          }; //字典
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.appendSecretDic;
}
@end
