//
//  KNBRecruitmentCaseListApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/17.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBRecruitmentCaseListApi.h"

@interface KNBRecruitmentCaseListApi ()

@end

@implementation KNBRecruitmentCaseListApi

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBRecruitment_GetCaseList];
}

- (id)requestArgument {
    NSDictionary *dic = nil;
    if (isNullStr(_search)) {
        dic = @{
                @"page" : @(_page) ?: @(1),
                @"limit" : @(_limit) ?: @(10),
                @"city_name" : _city_name ?: [KNGetUserLoaction shareInstance].cityName,
                @"lng" : @([[KNGetUserLoaction shareInstance].lng doubleValue]),
                @"lat" : @([[KNGetUserLoaction shareInstance].lat doubleValue]),
                @"style_id" : @(_style_id) ?: @(0),
                @"apartment_id" : @(_apartment_id) ?: @(0),
                @"min_area" : @(_min_area) ?: @(0),
                @"max_area" : @(_max_area) ?: @(999),
                @"search" : _search ?: @""
                }; //字典
    } else {
        dic = @{
                @"page" : @(_page) ?: @(1),
                @"limit" : @(_limit) ?: @(10),
                @"city_name" : _city_name ?: [KNGetUserLoaction shareInstance].cityName,
                @"lng" : @([[KNGetUserLoaction shareInstance].lng doubleValue]),
                @"lat" : @([[KNGetUserLoaction shareInstance].lat doubleValue]),
                @"search" : _search ?: @""
                }; //字典
    }

    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}
@end
