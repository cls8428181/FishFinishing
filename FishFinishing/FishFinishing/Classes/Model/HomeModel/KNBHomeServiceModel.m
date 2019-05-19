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
             @"serviceList" : @"service",
             @"logo" : @"logo",
             @"serviceId" : @"id",
             @"remark" : @"remark",
             @"created_at" : @"created_at",
             @"area_name" : @"area_name",
             @"telephone" : @"telephone",
             @"address" : @"address",
             @"share_name" : @"share_name",
             @"parent_cat_id" : @"cat_parent_id",
             @"due_time" : @"due_time",
             @"cat_name" : @"cat_name",
             @"check_in" : @"check_in",
             @"path" : @"path",
             @"is_stick" : @"is_stick",
             @"tag" : @"tag",
             @"cat_id" : @"cat_id",
             @"fac_id" : @"fac_id",
             @"name" : @"name",
             @"parent_cat_name" : @"parent_cat_name",
             @"facilitator_id" : @"facilitator_id",
             @"caseList" : @"case",
             @"is_experience" : @"is_experience",
             @"share_id" : @"share_id",
             @"subscribe_type" : @"subscribe_type",
             @"service_name" : @"service_name",
             @"icon" : @"icon",
             @"img" : @"img",
             @"is_recommend" : @"is_recommend",
             @"distance" : @"distance",
             @"apart_name" : @"apart_name",
             @"style_name" : @"style_name",
             @"acreage" : @"acreage",
             @"title" : @"title"
             };
}

+ (NSValueTransformer *)caseListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:KNBHomeServiceModel.class];
}

+ (NSValueTransformer *)serviceListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:KNBHomeServiceModel.class];
}

- (void)setRemark:(NSString *)remark {
    _remark = remark;
    CGFloat w = [UIScreen mainScreen].bounds.size.width - 24;
    CGFloat h = MAXFLOAT;
    NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
    CGFloat height = [remark boundingRectWithSize:CGSizeMake(w, h) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.height;
    _cellHeight = height + 111;
}

@end
