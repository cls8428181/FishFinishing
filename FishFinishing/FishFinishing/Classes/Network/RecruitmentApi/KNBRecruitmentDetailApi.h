//
//  KNBRecruitmentDetailApi.h
//  FishFinishing
//
//  Created by apple on 2019/4/11.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBRecruitmentDetailApi : KNBBaseRequest

/**
 获取服务商详情

 @param facId 服务商编号
 */
- (instancetype)initWithfacId:(NSInteger)facId;

@end

NS_ASSUME_NONNULL_END
