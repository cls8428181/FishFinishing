//
//  KNBRecruitmentModifyDetailApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/17.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBRecruitmentModifyDetailApi.h"

@implementation KNBRecruitmentModifyDetailApi

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBRecruitment_GetModify];
}

@end
