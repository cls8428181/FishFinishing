//
//  KNBRecruitmentModifyDetailApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/17.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBRecruitmentModifyDetailApi.h"

@implementation KNBRecruitmentModifyDetailApi {
    NSString *_token;
}
- (instancetype)initWithToken:(NSString *)token {
    if (self = [super init]) {
        _token = token;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBRecruitment_GetModify];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"token" : _token
                          }; //字典
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.appendSecretDic;
}
@end
