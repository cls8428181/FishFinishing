//
//  KNBHomeServiceModel.h
//  FishFinishing
//
//  Created by apple on 2019/4/18.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeServiceModel : KNBBaseModel

/**
 距离
 */
@property (nonatomic, copy) NSString *distance;

/**
 id
 */
@property (nonatomic, copy) NSString *serviceId;

/**
   名称
 */
@property (nonatomic, copy) NSString *name;

/**
 头像
 */
@property (nonatomic, copy) NSString *logo;

/**
 案例地址
 */
@property (nonatomic, copy) NSString *img;

/**
 地址
 */
@property (nonatomic, copy) NSString *address;

/**
 电话
 */
@property (nonatomic, copy) NSString *telephone;

/**
 标签
 */
@property (nonatomic, copy) NSString *tag;

/**
 服务
 */
@property (nonatomic, copy) NSString *service;

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

/**
 阅读量
 */
@property (nonatomic, copy) NSString *browse_num;

/**
 备注
 */
@property (nonatomic, copy) NSString *remark;

/**
 创建时间
 */
@property (nonatomic, copy) NSString *created_at;

/**
 服务商类型
 */
@property (nonatomic, copy) NSString *type;

/**
 案例数据
 */
@property (nonatomic, strong) NSArray<KNBHomeServiceModel *> *caseList;

@end

NS_ASSUME_NONNULL_END
