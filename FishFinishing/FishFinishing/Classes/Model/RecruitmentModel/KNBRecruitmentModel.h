//
//  KNBRecruitmentModel.h
//  FishFinishing
//
//  Created by apple on 2019/4/12.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseModel.h"
#import "KNBRecruitmentTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBRecruitmentModel : KNBBaseModel

/**
 选择的入驻类型
 */
@property (nonatomic, strong) KNBRecruitmentTypeModel *typeModel;

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
 入住费用
 */
@property (nonatomic, strong) KNBRecruitmentCostModel *priceModel;
@end

NS_ASSUME_NONNULL_END
