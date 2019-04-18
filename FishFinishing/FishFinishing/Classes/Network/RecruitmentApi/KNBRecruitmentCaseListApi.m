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
    NSDictionary *dic = @{
//                          @"page" : @(_page),
//                          @"limit" : @(_limit),
//                          @"city_name" : _city_name,
//                          @"style_id" : @(_style_id),
//                          @"apartment" : _apartment,
//                          @"min_area" : @(_min_area),
//                          @"max_area" : @(_max_area)
                          }; //字典
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}
@end
