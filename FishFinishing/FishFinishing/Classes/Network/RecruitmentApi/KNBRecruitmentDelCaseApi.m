//
//  KNBRecruitmentDelCaseApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/11.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBRecruitmentDelCaseApi.h"

@implementation KNBRecruitmentDelCaseApi {
    NSString *_token;
    NSInteger _case_id;
}

- (instancetype)initWithToken:(NSString *)token caseId:(NSInteger)caseId {
    if (self = [super init]) {
        _token = token;
        _case_id = caseId;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBRecruitment_DelCase];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"token" : _token,
                          @"case_id" : @(_case_id),
                          };
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}

@end
