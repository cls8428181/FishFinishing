//
//  KNBMeOrderModel.h
//  FishFinishing
//
//  Created by apple on 2019/4/24.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBMeOrderModel : KNBBaseModel

/**
 订单 ID
 */
@property (nonatomic, copy) NSString *orderId;

/**
 是否联系  0 未联系 1 已联系
 */
@property (nonatomic, copy) NSString *sign;

/**
 姓名
 */
@property (nonatomic, copy) NSString *name;

/**
 头像
 */
@property (nonatomic, copy) NSString *portrait_img;

/**
 户型
 */
@property (nonatomic, copy) NSString *house_info;

/**
 面积信息
 */
@property (nonatomic, copy) NSString *area_info;

/**
 风格
 */
@property (nonatomic, copy) NSString *decorate_style;

/**
 档次
 */
@property (nonatomic, copy) NSString *decorate_grade;

/**
 新房 or 旧房
 */
@property (nonatomic, copy) NSString *decorate_cat;

/**
 省
 */
@property (nonatomic, copy) NSString *province_name;

/**
 市
 */
@property (nonatomic, copy) NSString *city_name;

/**
 区
 */
@property (nonatomic, copy) NSString *area_name;

/**
 小区名称
 */
@property (nonatomic, copy) NSString *community;

/**
 电话
 */
@property (nonatomic, copy) NSString *mobile;

/**
 创建时间
 */
@property (nonatomic, copy) NSString *created_at;

/**
 1.报价 2.装修
 */
@property (nonatomic, copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
