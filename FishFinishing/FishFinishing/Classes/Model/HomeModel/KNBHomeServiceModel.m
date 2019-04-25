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
             @"is_stick" : @"is_stick"
             };
}

+ (NSValueTransformer *)caseListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:KNBHomeServiceModel.class];
}
@end
