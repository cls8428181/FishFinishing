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
             @"type" : @"type",
             @"case_id" : @"case_id",
             @"title" : @"title",
             @"acreage" : @"acreage",
             @"apartment" : @"apartment",
             @"style_name" : @"style_name",
             @"img" : @"img",
             @"apart" : @"apart"
             };
}

@end
