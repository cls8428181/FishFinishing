//
//  KNBRecruitmentCatChildApi.h
//  FishFinishing
//
//  Created by apple on 2019/4/17.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBRecruitmentCatChildApi : KNBBaseRequest

- (instancetype)initWithParentCatId:(NSInteger)catId;

@end

NS_ASSUME_NONNULL_END
