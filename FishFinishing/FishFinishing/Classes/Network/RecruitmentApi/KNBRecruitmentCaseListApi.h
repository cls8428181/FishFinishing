//
//  KNBRecruitmentCaseListApi.h
//  FishFinishing
//
//  Created by apple on 2019/4/17.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBRecruitmentCaseListApi : KNBBaseRequest

/**
 页码
 */
@property (nonatomic, assign) NSInteger page;

/**
 每页显示数量
 */
@property (nonatomic, assign) NSInteger limit;

/**
 城市名
 */
@property (nonatomic, copy) NSString *city_name;

/**
 装修风格编号
 */
@property (nonatomic, assign) NSInteger style_id;

/**
 户型
 */
@property (nonatomic, copy) NSString *apartment;

/**
 最小面积数
 */
@property (nonatomic, assign) double min_area;

/**
 最大面积数
 */
@property (nonatomic, assign) double max_area;

@end

NS_ASSUME_NONNULL_END
