//
//  KNBRecruitmentDomainApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/11.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBRecruitmentDomainApi.h"

@implementation KNBRecruitmentDomainApi

- (instancetype)init {
    if (self = [super init]) {

    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBRecruitment_Domain];
}

@end
