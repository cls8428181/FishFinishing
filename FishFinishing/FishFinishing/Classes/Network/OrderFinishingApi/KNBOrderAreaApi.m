//
//  KNBOrderAreaApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/16.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBOrderAreaApi.h"

@implementation KNBOrderAreaApi

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBOrder_Area];
}

@end
