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
    NSString *_tag_id;
    NSString *_logo;
    NSString *_service_id;
    NSString *_name;
    NSString *_telephone;
    NSString *_remark;
}

- (instancetype)initWithCatId:(NSInteger)catId tagId:(NSString *)tagId logo:
(NSString *)logo serviceId:(NSString *)serviceId Name:(NSString *)name  phone:(NSString *)phone address:(NSString *)address remark:(NSString *)remark {
    if (self = [super init]) {
        _cat_id = catId;
        _tag_id = tagId;
        _logo = logo;
        _service_id = serviceId;
        _name = name;
        _telephone = phone;
        _address = address;
        _remark = remark;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBRecruitment_Add];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"cat_id" : @(_cat_id),
                          @"orderid" : _orderid,
                          @"city_name" : _city_name,
                          @"area_name" : _area_name,
                          @"tag_id" : _tag_id,
                          @"logo" : _logo,
                          @"service_id" : _service_id,
                          @"lng" : _lng,
                          @"lat" : _lat,
                          @"name" : _name,
                          @"telephone" : _telephone,
                          @"address" : _address,
                          @"remark" : _remark
                          };
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}

@end
