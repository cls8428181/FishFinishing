//
//  KNBRecruitmentServiceListApi.h
//  FishFinishing
//
//  Created by apple on 2019/4/17.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBRecruitmentServiceListApi : KNBBaseRequest

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
@property (nonatomic, assign) NSString *city_name;

/**
 区域名
 */
@property (nonatomic, assign) NSString *area_name;

/**
 入驻类型父级编号
 */
@property (nonatomic, assign) NSInteger cat_parent_id;

/**
 入驻类型子级编号
 */
@property (nonatomic, assign) NSInteger cat_id;

- (instancetype)initWithLng:(NSString *)lng lat:(NSString *)lat;

@end

NS_ASSUME_NONNULL_END
