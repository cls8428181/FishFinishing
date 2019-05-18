//
//  KNBCityModel.m
//  FishFinishing
//
//  Created by apple on 2019/5/18.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBCityModel.h"

@implementation KNBCityModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"code" : @"id",
             @"name" : @"name"
             };
}

// 主健
+ (NSSet *)propertyKeysForManagedObjectUniquing {
    return [NSSet setWithObject:@"name"];
}

@end
