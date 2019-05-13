//
//  KNBOrderAreaRangeApi.m
//  FishFinishing
//
//  Created by apple on 2019/5/7.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBOrderAreaRangeApi.h"

@implementation KNBOrderAreaRangeApi

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBOrder_AreaRange];
}

@end
