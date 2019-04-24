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
}

- (instancetype)initWithMobile:(NSString *)mobile code:(NSString *)code {
    if (self = [super init]) {
        _mobile = mobile;
        _code = code;
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
                          };
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}

@end
