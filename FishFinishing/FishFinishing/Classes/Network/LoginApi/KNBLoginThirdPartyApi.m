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
}

- (instancetype)initWithOpenid:(NSString *)openid loginType:(KNBLoginThirdPartyType)loginType {
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
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBLogin_ThirdParty];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"openid" : _openid,
                          @"login_type" : _login_type
                          };
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}

@end
