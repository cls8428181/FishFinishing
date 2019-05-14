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
    NSString *_portrait_img;
    NSString *_nickname;
    NSString *_sex;
    NSString *_openid;
    NSString *_login_type;
}

- (instancetype)initWithMobile:(NSString *)mobile code:(NSString *)code portrait:(NSString *)portrait nickName:(NSString *)nickName sex:(NSString *)sex openid:(NSString *)openid loginType:(KNBLoginThirdPartyType)loginType {
    if (self = [super init]) {
        _mobile = mobile;
        _code = code;
        _portrait_img = portrait;
        _nickname = nickName;
        _sex = sex;
        _openid = openid;
        if (loginType == KNBLoginThirdPartyTypeWechat) {
            _login_type = @"weixin";
        }
        if (loginType == KNBLoginThirdPartyTypeQQ) {
            _login_type = @"qq";
        }
        if (loginType == KNBLoginThirdPartyTypeBlog) {
            _login_type = @"weibo";
        }
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
                          @"portrait_img" : _portrait_img,
                          @"nickname" : _nickname,
                          @"sex" : _sex,
                          @"openid" : _openid,
                          @"login_type" : _login_type
                          };
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}

@end
