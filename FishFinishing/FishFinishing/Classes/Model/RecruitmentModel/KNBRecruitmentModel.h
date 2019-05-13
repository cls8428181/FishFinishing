//
//  KNBRecruitmentModel.h
//  FishFinishing
//
//  Created by apple on 2019/4/12.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseModel.h"
#import "KNBRecruitmentTypeModel.h"
#import "KNBHomeServiceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBRecruitmentModel : KNBBaseModel

/**
 选择的入驻类型
 */
@property (nonatomic, strong) KNBRecruitmentTypeModel *typeModel;

/**
 选择的入驻类型
 */
@property (nonatomic, strong) KNBHomeServiceModel *serviceModel;

/**
 经度
 */
@property (nonatomic, assign) CGFloat longitude;

/**
 纬度
 */
@property (nonatomic, assign) CGFloat latitude;

/**
 区域名称
 */
@property (nonatomic, copy) NSString *areaName;

/**
 城市名称
 */
@property (nonatomic, copy) NSString *cityName;

/**
 头像
 */
@property (nonatomic, strong) UIImage *iconImage;

/**
 商家名称
 */
@property (nonatomic, copy) NSString *name;

/**
 商家头像
 */
@property (nonatomic, copy) NSString *logo;

/**
 商家位置
 */
@property (nonatomic, copy) NSString *address;

/**
 商家电话
 */
@property (nonatomic, copy) NSString *telephone;

/**
 擅长领域
 */
@property (nonatomic, strong) NSArray *domainList;

/**
 擅长领域 Id
 */
@property (nonatomic, copy) NSString *domainId;

/**
 服务选择
 */
@property (nonatomic, strong) NSArray *serviceList;

/**
 服务选择 Id
 */
@property (nonatomic, copy) NSString *serviceId;

/**
 擅长领域
 */
@property (nonatomic, copy) NSString *tag;

/**
 服务
 */
@property (nonatomic, copy) NSString *service;

/**
 简介
 */
@property (nonatomic, copy) NSString *remark;

/**
 简介
 */
@property (nonatomic, copy) NSString *orderId;

/**
 入住费用
 */
@property (nonatomic, strong) KNBRecruitmentCostModel *priceModel;
@end

NS_ASSUME_NONNULL_END
