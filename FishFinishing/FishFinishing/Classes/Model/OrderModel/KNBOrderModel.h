//
//  KNBOrderModel.h
//  FishFinishing
//
//  Created by apple on 2019/4/16.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseModel.h"
#import "KNBRecruitmentTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBOrderModel : KNBBaseModel
/**
 选择的服务类型
 */
@property (nonatomic, strong) KNBRecruitmentTypeModel *typeModel;

/**
  面积
 */
@property (nonatomic, copy) NSString *area_info;

/**
  户型
 */
@property (nonatomic, copy) NSString *house_info;

/**
 小区名称
 */
@property (nonatomic, copy) NSString *community;

/**
 省编号
 */
@property (nonatomic, assign) NSInteger province_id;

/**
 市编号
 */
@property (nonatomic, assign) NSInteger city_id;

/**
 区编号
 */
@property (nonatomic, assign) NSInteger area_id;

/**
 装修风格
 */
@property (nonatomic, copy) NSString *style;

/**
 装修档次
 */
@property (nonatomic, copy) NSString *level;

/**
 联系人
 */
@property (nonatomic, copy) NSString *name;

/**
 电话
 */
@property (nonatomic, copy) NSString *mobile;

@end

NS_ASSUME_NONNULL_END
