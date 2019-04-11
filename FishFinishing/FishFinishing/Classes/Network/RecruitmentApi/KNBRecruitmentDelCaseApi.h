//
//  KNBRecruitmentDelCaseApi.h
//  FishFinishing
//
//  Created by apple on 2019/4/11.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBRecruitmentDelCaseApi : KNBBaseRequest

/**
 删除装修案例

 @param token 用户登录标识
 @param caseId 装修案列编号
 */
- (instancetype)initWithToken:(NSString *)token caseId:(NSInteger)caseId;

@end

NS_ASSUME_NONNULL_END
