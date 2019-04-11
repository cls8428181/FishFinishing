//
//  KNBHomeSingleAreaApi.h
//  FishFinishing
//
//  Created by apple on 2019/4/11.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeSingleAreaApi : KNBBaseRequest

/**
 获取省市区

 @param areaId 省市编号
 */
- (instancetype)initWithAreaId:(NSInteger)areaId;

@end

NS_ASSUME_NONNULL_END
