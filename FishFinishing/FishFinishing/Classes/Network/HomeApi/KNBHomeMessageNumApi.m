//
//  KNBHomeMessageNumApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/17.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBHomeMessageNumApi.h"

@implementation KNBHomeMessageNumApi

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBHome_MassageNum];
}

@end
