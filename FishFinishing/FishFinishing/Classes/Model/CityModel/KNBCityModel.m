//
//  KNBCityModel.m
//  FishFinishing
//
//  Created by apple on 2019/5/18.
//  Copyright © 2019 常立山. All rights reserved.
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
             @"areaList" : @"area"
             };
}

// 主健
+ (NSSet *)propertyKeysForManagedObjectUniquing {
    return [NSSet setWithObject:@"code"];
}

+ (NSValueTransformer *)cityListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:KNBCityModel.class];
}

+ (NSValueTransformer *)areaListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:KNBCityModel.class];
}

//// 正反关联
//+ (NSDictionary *)relationshipModelClassesByPropertyKey {
//    return @{
//             @"city_list" : [KNBCityModel class],
//             @"area_list" : [KNBCityModel class],
//             @"city_city" : [KNBCityModel class],
//             @"area_province" : [KNBCityModel class]
//             };
//}
@end
