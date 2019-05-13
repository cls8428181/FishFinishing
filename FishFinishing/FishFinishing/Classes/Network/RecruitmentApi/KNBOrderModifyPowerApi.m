//
//  KNBOrderModifyPowerApi.m
//  FishFinishing
//
//  Created by apple on 2019/5/9.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBOrderModifyPowerApi.h"

@implementation KNBOrderModifyPowerApi

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBOrder_ModifyPower];
}

@end
