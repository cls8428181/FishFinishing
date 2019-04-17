
//
//  KNBRecruitmentTypeModel.m
//  FishFinishing
//
//  Created by apple on 2019/4/12.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBRecruitmentTypeModel.h"

@implementation KNBRecruitmentTypeModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"typeId" : @"id",
             @"catName" : @"cat_name",
             @"pid" : @"pid",
             @"img" : @"img",
             @"sort" : @"sort",
             @"enable" : @"enable",
             @"creater" : @"creater",
             @"createdAt" : @"created_at",
             @"updater" : @"updater",
             @"updatedAt" : @"updated_at",
             @"serviceName" : @"service_name",
             @"childList" : @"child"
             };
}

+ (NSValueTransformer *)childListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:KNBRecruitmentTypeModel.class];
}

@end

@implementation KNBRecruitmentCostModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"typeId" : @"id",
             @"name" : @"name",
             @"price" : @"price",
             @"termType" : @"term_type",
             @"term" : @"term",
             @"remark" : @"remark"
             };
}
@end


@implementation KNBRecruitmentUnitModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"typeId" : @"id",
             @"name" : @"name",
             @"sort" : @"sort",
             };
}
@end
