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

- (instancetype)initWithOpenid:(NSString *)openid loginType:(KNBLoginThirdPartyType)loginType portrait:(NSString *)portrait nickName:(NSString *)nickName sex:(NSString *)sex {
    if (self = [super init]) {
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
        _portrait_img = portrait;
        _nickname = nickName;
        _sex = sex;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBLogin_ThirdParty];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"openid" : _openid,
                          @"login_type" : _login_type,
                          @"portrait_img" : _portrait_img,
                          @"nickname" : _nickname,
                          @"sex" : _sex
                          };
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}

@end
