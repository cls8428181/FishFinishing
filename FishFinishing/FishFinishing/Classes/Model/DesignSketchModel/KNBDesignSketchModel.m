//
//  KNBDesignSketchModel.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/18.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBDesignSketchModel.h"

@implementation KNBDesignSketchModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"caseId" : @"id",
             @"title" : @"title",
             @"name" : @"name",
             @"img" : @"img",
             @"browse_num" : @"browse_num",
             @"created_at" : @"created_at",
             };
}

+ (NSValueTransformer *)imgsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:KNBDesignSketchModel.class];
}

@end
