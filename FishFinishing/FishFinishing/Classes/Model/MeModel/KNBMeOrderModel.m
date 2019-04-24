//
//  KNBMeOrderModel.m
//  FishFinishing
//
//  Created by apple on 2019/4/24.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBMeOrderModel.h"

@implementation KNBMeOrderModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"orderId" : @"id",
             @"sign" : @"sign",
             @"name" : @"name",
             @"portrait_img" : @"portrait_img",
             @"house_info" : @"house_info",
             @"decorate_style" : @"decorate_style",
             @"decorate_grade" : @"decorate_grade",
             @"province_name" : @"province_name",
             @"city_name" : @"city_name",
             @"area_name" : @"area_name",
             @"community" : @"community",
             @"mobile" : @"mobile",
             @"created_at" : @"created_at"
             };
}
@end
