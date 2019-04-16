//
//  KNBCityModel.m
//  FishFinishing
//
//  Created by apple on 2019/4/16.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBCityModel.h"

@implementation KNBCityModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"code" : @"id",
             @"isOpen" : @"is_open",
             @"isHot" : @"is_hot",
             @"temp" : @"temp",
             @"letter" : @"letter",
             @"pinyin" : @"pinyin",
             @"cityList" : @"city",
             @"level" : @"level",
             @"region" : @"region",
             @"pid" : @"pid",
             @"sort" : @"sort",
             @"name" : @"name",
             @"status" : @"status",
             @"areaList" : @"area",
             @"dataList" : @"data"
             };
}

+ (NSValueTransformer *)cityListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:KNBCityModel.class];
}

+ (NSValueTransformer *)areaListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:KNBCityModel.class];
}

+ (NSValueTransformer *)dataListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:KNBCityModel.class];
}
@end
