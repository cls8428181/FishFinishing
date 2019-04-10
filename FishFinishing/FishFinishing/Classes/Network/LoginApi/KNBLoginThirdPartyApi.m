//
//  KNBLoginThirdPartyApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/10.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBLoginThirdPartyApi.h"

@implementation KNBLoginThirdPartyApi {
    NSString *_openid;
    NSString *_login_type;
    NSString *_portrait_img;
    NSString *_nickname;
    NSString *_sex;
}
//
//- (instancetype)initWithMobile:(NSString *)mobile type:(KNBLoginSendCodeType)type {
//    if (self = [super init]) {
//    }
//    return self;
//}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNB_Login_ThirdParty];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          };
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}

@end
