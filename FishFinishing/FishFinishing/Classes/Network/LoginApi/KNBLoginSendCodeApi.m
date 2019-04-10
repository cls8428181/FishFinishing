//
//  KNBLoginSendCodeApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/10.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBLoginSendCodeApi.h"

@implementation KNBLoginSendCodeApi {
    NSString *_mobile;
    NSString *_action;
}

- (instancetype)initWithMobile:(NSString *)mobile type:(KNBLoginSendCodeType)type {
    if (self = [super init]) {
        _mobile = mobile;
        if (type == KNBLoginSendCodeTypeRegister) {
            _action = @"register";
        } else {
            _action = @"forgotpassword";
        }
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNB_Login_SendCode];
}

- (id)requestArgument {
//    NSDictionary *dic = @{
//                          @"mobile" : _mobile,
//                          @"action" : _action,
//                          };
//    [self.baseMuDic addEntriesFromDictionary:dic];
    return @{
             @"mobile" : _mobile,
             @"action" : _action,
             };
}
@end
