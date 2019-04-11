//
//  KNBHomeBannerApi.h
//  FishFinishing
//
//  Created by apple on 2019/4/11.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeBannerApi : KNBBaseRequest

/**
 获取 banner 图

 @param vari 引用变量
 @param cityName 城市
 */
- (instancetype)initWithVari:(NSString *)vari cityName:(NSString *)cityName;

@end

NS_ASSUME_NONNULL_END
