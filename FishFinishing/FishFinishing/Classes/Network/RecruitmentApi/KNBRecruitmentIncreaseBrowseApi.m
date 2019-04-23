//
//  KNBRecruitmentIncreaseBrowseApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/17.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBRecruitmentIncreaseBrowseApi.h"

@implementation KNBRecruitmentIncreaseBrowseApi {
    NSInteger _case_id;
}
- (instancetype)initWithCaseId:(NSInteger)caseId {
    if (self = [super init]) {
        _case_id = caseId;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBRecruitment_IncreaseBrowse];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"case_id" : @(_case_id)
                          }; //字典
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}
@end
