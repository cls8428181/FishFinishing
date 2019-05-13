//
//  KNBLoginUserInfoApi.m
//  FishFinishing
//
//  Created by apple on 2019/5/6.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBLoginUserInfoApi.h"

@implementation KNBLoginUserInfoApi

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBLogin_UserInfo];
}

@end
