//
//  KNBHomeChatModel.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/19.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeChatModel.h"

@implementation KNBHomeChatModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"caseId" : @"id",
             @"title" : @"title",
             @"name" : @"name",
             @"img" : @"img",
             @"browse_num" : @"browse_num",
             @"created_at" : @"created_at",
             @"subTitle" : @"sub_title"
             };
}
@end
