//
//  KNBOrderStyleApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/11.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBOrderStyleApi.h"

@implementation KNBOrderStyleApi

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBOrder_Style];
}

@end
