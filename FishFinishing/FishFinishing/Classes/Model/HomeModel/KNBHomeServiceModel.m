//
//  KNBHomeServiceModel.m
//  FishFinishing
//
//  Created by apple on 2019/4/18.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBHomeServiceModel.h"

@implementation KNBHomeServiceModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"cat_id" : @"cat_id",
             @"serviceId" : @"id",
             @"fac_id" : @"fac_id",
             @"facilitator_id" : @"facilitator_id",
             @"distance" : @"distance",
             @"name" : @"name",
             @"logo" : @"logo",
             @"img" : @"img",
             @"address" : @"address",
             @"telephone" : @"telephone",
             @"tag" : @"tag",
             @"caseList" : @"case",
             @"service" : @"service",
             @"title" : @"title",
             @"browse_num" : @"browse_num",
             @"remark" : @"remark",
             @"created_at" : @"created_at",
             @"parent_cat_name" : @"parent_cat_name",
             @"parent_cat_id" : @"cat_parent_id",
             @"is_stick" : @"is_stick",
             @"is_experience" : @"is_experience",
             @"due_time" : @"due_time",
             @"share_id" : @"share_id"
             };
}

+ (NSValueTransformer *)caseListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:KNBHomeServiceModel.class];
}
@end
