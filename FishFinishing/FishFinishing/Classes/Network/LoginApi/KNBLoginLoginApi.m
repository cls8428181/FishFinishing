//
//  KNBLoginLoginApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/11.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBLoginLoginApi.h"

@implementation KNBLoginLoginApi {
    NSString *_mobile;
    NSString *_password;
}

- (instancetype)initWithMobile:(NSString *)mobile password:(NSString *)password {
    if (self = [super init]) {
        _mobile = mobile;
        _password = password;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBLogin_Login];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"mobile" : _mobile,
                          @"password" : _password
                          };
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}

@end
