//
//  KNBRecruitmentAddCaseApi.h
//  FishFinishing
//
//  Created by apple on 2019/4/11.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBRecruitmentAddCaseApi : KNBBaseRequest

/**
 添加装修案例

 @param token 用户登录标识
 @param title 案列描述
 @param styleId 装修风格编号
 @param acreage 面积
 */
- (instancetype)initWithToken:(NSString *)token title:(NSString *)title styleId:(NSInteger)styleId acreage:(double)acreage apartment:(NSString *)apartment imgs:(NSString *)imgs;

@end

NS_ASSUME_NONNULL_END
