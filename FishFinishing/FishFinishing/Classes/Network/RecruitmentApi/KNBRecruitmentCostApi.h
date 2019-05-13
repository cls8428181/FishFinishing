//
//  KNBRecruitmentCostApi.h
//  FishFinishing
//
//  Created by apple on 2019/4/11.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBRecruitmentCostApi : KNBBaseRequest

@property (nonatomic, assign) NSInteger package_type;
/**
 获取入驻费用

 @param catId 服务商类别编号
 @param costType 费用类别 1:入驻费用 2：置顶费用
 */
- (instancetype)initWithCatId:(NSInteger)catId costType:(NSInteger)costType;

@end

NS_ASSUME_NONNULL_END
