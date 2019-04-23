//
//  KNBLoginModifyUserInfoApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/23.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBLoginModifyUserInfoApi.h"

@implementation KNBLoginModifyUserInfoApi {
    NSString *_token;
    NSString *_portrait_img;
    NSString *_nickname;
}

- (instancetype)initWithToken:(NSString *)token portraitImg:(NSString *)portraitImg nickName:(NSString *)nickName {
    if (self = [super init]) {
        _token = token;
        _portrait_img = portraitImg;
        _nickname = nickName;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBLogin_ModifyUserInfo];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"token" : _token,
                          @"portrait_img" : _portrait_img,
                          @"nickname" : _nickname
                          };
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}

@end
