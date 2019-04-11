//
//  KNBLoginModifyApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/11.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBLoginModifyApi.h"

@implementation KNBLoginModifyApi {
    NSString *_mobile;
    NSString *_code;
    NSString *_token;
    NSString *_password;
    NSString *_repassword;
}

- (instancetype)initWithMobile:(NSString *)mobile code:(NSString *)code token:(NSString *)token password:(NSString *)password repassword:(NSString *)repassword {
    if (self = [super init]) {
        _mobile = mobile;
        _code = code;
        _token = token;
        _password = password;
        _repassword = repassword;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBLogin_Modify];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"mobile" : _mobile,
                          @"code" : _code,
                          @"token" : _token,
                          @"password" : _password,
                          @"repassword" : _repassword
                          };
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}

@end
