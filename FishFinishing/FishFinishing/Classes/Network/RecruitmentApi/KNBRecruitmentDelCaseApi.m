//
//  KNBRecruitmentDelCaseApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/11.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBRecruitmentDelCaseApi.h"

@implementation KNBRecruitmentDelCaseApi {
    NSInteger _case_id;
}

- (instancetype)initWithCaseId:(NSInteger)caseId {
    if (self = [super init]) {
        _case_id = caseId;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBRecruitment_DelCase];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"case_id" : @(_case_id),
                          };
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}

@end
