//
//  KNBRecruitmentCaseDetailApi.h
//  FishFinishing
//
//  Created by apple on 2019/4/11.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBRecruitmentCaseDetailApi : KNBBaseRequest

/**
 获取装修案例详情

 @param caseId 装修案列编号
 */
- (instancetype)initWithCaseId:(NSInteger)caseId;

@end

NS_ASSUME_NONNULL_END
