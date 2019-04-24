//
//  KNBRecruitmentAddApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/11.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBRecruitmentAddApi.h"

@implementation KNBRecruitmentAddApi {
    NSInteger _cat_id;
    NSString *_city_name;
    NSString *_tag_id;
    NSString *_logo;
    NSString *_service_id;
    NSString *_lng;
    NSString *_lat;
    NSString *_name;
    NSString *_telephone;
    NSString *_address;
    NSString *_remark;
    NSInteger _cost_id;
}

- (instancetype)initWithCatId:(NSInteger)catId cityName:(NSString *)cityName tagId:(NSString *)tagId logo:
(NSString *)logo serviceId:(NSString *)serviceId lng:(NSString *)lng lat:(NSString *)lat Name:(NSString *)name  phone:(NSString *)phone address:(NSString *)address remark:(NSString *)remark costId:(NSInteger)costId  {
    if (self = [super init]) {
        _cat_id = catId;
        _city_name = cityName;
        _tag_id = tagId;
        _logo = logo;
        _service_id = serviceId;
        _lng = lng;
        _lat = lat;
        _name = name;
        _telephone = phone;
        _address = address;
        _remark = remark;
        _cost_id = costId;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBRecruitment_Add];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"cat_id" : @(_cat_id),
                          @"city_name" : _city_name,
                          @"tag_id" : _tag_id,
                          @"logo" : _logo,
                          @"service_id" : _service_id,
                          @"lng" : _lng,
                          @"lat" : _lat,
                          @"name" : _name,
                          @"telephone" : _telephone,
                          @"address" : _address,
                          @"remark" : _remark,
                          @"cost_id" : @(_cost_id)
                          };
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}

@end
