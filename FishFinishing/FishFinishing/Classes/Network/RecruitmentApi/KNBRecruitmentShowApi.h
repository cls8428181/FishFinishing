//
//  KNBRecruitmentShowApi.h
//  FishFinishing
//
//  Created by apple on 2019/5/9.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBRecruitmentShowApi : KNBBaseRequest

- (instancetype)initWithCaseId:(NSInteger)caseId isRecommend:(NSInteger)isRecommend;

@end

NS_ASSUME_NONNULL_END
