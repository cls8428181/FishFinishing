//
//  KNBHomeRecommendCaseModel.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/22.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeRecommendCaseModel.h"

@implementation KNBHomeRecommendCaseModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"caseId" : @"id",
             @"name" : @"name",
             @"cat_name" : @"cat_name",
             @"sort" : @"sort",
             @"enable" : @"enable",
             @"creater" : @"creater",
             @"creater_at" : @"creater_at",
             @"img" : @"img",
             @"updater" : @"updater",
             @"updater_at" : @"updater_at",
             @"min_area" : @"min_area",
             @"max_area" : @"max_area"
             };
}

@end
