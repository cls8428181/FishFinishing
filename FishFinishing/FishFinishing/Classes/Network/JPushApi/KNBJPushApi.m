//
//  KNBJPushApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/27.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBJPushApi.h"

@implementation KNBJPushApi {
    NSString *_registration_id;
}
    
- (instancetype)initWithRegistrationId:(NSString *)registrationId {
    if (self = [super init]) {
        _registration_id = registrationId;
    }
    return self;
}
    
- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNB_RegistrationId];
}
    
- (id)requestArgument {
    NSDictionary *dic = @{
                          @"registration_id" : _registration_id
                          }; //字典
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}
@end
