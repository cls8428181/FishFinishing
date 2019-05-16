//
//  KNBRecruitmentModifyFacilitatorApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/17.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBRecruitmentModifyFacilitatorApi.h"

@implementation KNBRecruitmentModifyFacilitatorApi

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBRecruitment_ModifyFacilitator];
}

- (id)requestArgument {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (!isNullStr(_area_name)) {
        [dic setObject:_area_name forKey:@"area_name"];
    }
    if (!isNullStr(_tag_id)) {
        [dic setObject:_tag_id forKey:@"tag_id"];
    }
    if (!isNullStr(_logo)) {
        [dic setObject:_logo forKey:@"logo"];
    }
    if (!isNullStr(_service_id)) {
        [dic setObject:_service_id forKey:@"service_id"];
    }
    if (!isNullStr(_name)) {
        [dic setObject:_name forKey:@"name"];
    }
    if (!isNullStr(_telephone)) {
        [dic setObject:_telephone forKey:@"telephone"];
    }
    if (!isNullStr(_address)) {
        [dic setObject:_address forKey:@"address"];
    }
    if (!isNullStr(_remark)) {
        [dic setObject:_remark forKey:@"remark"];
    }
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}

@end
