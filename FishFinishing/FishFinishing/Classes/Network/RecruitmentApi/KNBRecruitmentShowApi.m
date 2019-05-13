//
//  KNBRecruitmentShowApi.m
//  FishFinishing
//
//  Created by apple on 2019/5/9.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBRecruitmentShowApi.h"

@implementation KNBRecruitmentShowApi
{
    NSInteger _case_id;
    NSInteger _is_recommend;
}
- (instancetype)initWithCaseId:(NSInteger)caseId isRecommend:(NSInteger)isRecommend {
    if (self = [super init]) {
        _case_id = caseId;
        _is_recommend = isRecommend;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBRecruitment_DefaultShow];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"case_id" : @(_case_id),
                          @"is_recommend" : @(_is_recommend)
                          }; //字典
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}

@end
