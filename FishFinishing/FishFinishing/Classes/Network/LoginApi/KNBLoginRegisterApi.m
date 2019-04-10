//
//  KNBLoginRegisterApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/10.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBLoginRegisterApi.h"

@implementation KNBLoginRegisterApi {
    NSString *_mobile;
    NSString *_code;
    NSString *_password;
    NSString *_repassword;
}

- (instancetype)initWithMobile:(NSString *)mobile code:(NSString *)code password:(NSString *)password repassword:(NSString *)repassword {
    if (self = [super init]) {
        _mobile = mobile;
        _code = code;
        _password = password;
        _repassword = repassword;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNB_Login_Register];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"mobile" : _mobile,
                          @"code" : _code,
                          @"password" : _password,
                          @"repassword" : _repassword
                          };
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}
@end
