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
             @"serviceId" : @"id",
             @"distance" : @"distance",
             @"name" : @"name",
             @"logo" : @"logo",
             @"img" : @"img",
             @"address" : @"address",
             @"telephone" : @"telephone",
             @"tag" : @"tag",
             @"caseList" : @"case",
             };
}

+ (NSValueTransformer *)caseListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:KNBHomeServiceModel.class];
}
@end
