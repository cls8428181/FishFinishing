//
//  KNBLoginBindingApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/11.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBLoginBindingApi.h"

@implementation KNBLoginBindingApi {
    NSString *_mobile;
    NSString *_code;
    NSString *_token;
}

- (instancetype)initWithMobile:(NSString *)mobile code:(NSString *)code token:(NSString *)token {
    if (self = [super init]) {
        _mobile = mobile;
        _code = code;
        _token = token;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBLogin_Binding];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"mobile" : _mobile,
                          @"code" : _code,
                          @"token" : _token
                          };
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}

@end
