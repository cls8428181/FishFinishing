//
//  KNBOrderCheckApi.m
//  FishFinishing
//
//  Created by apple on 2019/5/6.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBOrderCheckApi.h"

@implementation KNBOrderCheckApi

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBOrder_CheckBespoke];
}

@end
