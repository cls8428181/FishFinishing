//
//  KNBHomeBannerModel.m
//  FishFinishing
//
//  Created by apple on 2019/4/12.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBHomeBannerModel.h"

@implementation KNBHomeBannerModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"bannerId" : @"id",
             @"img": @"img",
             @"url": @"url"
             };
}
@end
