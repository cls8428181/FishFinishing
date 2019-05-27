//
//  KNBDesignSketchModel.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/18.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBDesignSketchModel.h"
#import "UIImage+Size.h"
#import "MPNslogHeader.h"

@implementation KNBDesignSketchModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"facilitator_id" : @"facilitator_id",
             @"caseId" : @"id",
             @"title" : @"title",
             @"name" : @"name",
             @"img" : @"img",
             @"logo" : @"logo",
             @"price" : @"price",
             @"browse_num" : @"browse_num",
             @"created_at" : @"created_at",
             @"style_name" : @"style_name",
             @"acreage" : @"acreage",
             @"apart_name" : @"apart_name",
             @"remark" : @"remark",
             @"parent_cat_name" : @"parent_cat_name",
             @"cat_parent_id" : @"cat_parent_id",
             @"cat_name" : @"cat_name",
             @"cat_id" : @"cat_id",
             @"telephone" : @"telephone"
             };
}

+ (NSValueTransformer *)imgsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:KNBDesignSketchModel.class];
}

- (void)setImg:(NSString *)img {
    _img = img;
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:img]];
    CGSize imageSize = [UIImage imageWithData:data].size;
    CGFloat imageH = imageSize.height / imageSize.width * (KNB_SCREEN_WIDTH - 36)/2;
    
    _cellHeight = imageH + 88;
}

@end
