//
//  KNBRecruitmentModifyFacilitatorApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/17.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBRecruitmentModifyFacilitatorApi.h"

@implementation KNBRecruitmentModifyFacilitatorApi {
    NSString *_token;
}
- (instancetype)initWithToken:(NSString *)token {
    if (self = [super init]) {
        _token = token;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBRecruitment_GetModify];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"token" : _token,
                          @"cat_id" : @(_cat_id),
                          @"area_name" : _area_name,
                          @"tag_id" : _tag_id,
                          @"logo" : _logo,
                          @"service_id" : _service_id,
                          @"lng" : _lng,
                          @"lat" : _lat,
                          @"name" : _name,
                          @"telephone" : _telephone,
                          @"address" : _address,
                          @"remark" : _remark,
                          }; //字典
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.appendSecretDic;
}

@end
