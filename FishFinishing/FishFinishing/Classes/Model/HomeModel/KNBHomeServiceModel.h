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
 类型 id
 */
@property (nonatomic, copy) NSString *cat_id;

/**
 服务商 id
 */
@property (nonatomic, copy) NSString *fac_id;

/**
 案例中的服务商 id
 */
@property (nonatomic, copy) NSString *facilitator_id;

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
@property (nonatomic, copy) NSString *share_id;

/**
 服务商类型名称
 */
@property (nonatomic, copy) NSString *parent_cat_name;

/**
 服务商类型id
 */
@property (nonatomic, copy) NSString *parent_cat_id;

/**
 是否置顶   0 未置顶 1 置顶
 */
@property (nonatomic, copy) NSString *is_stick;

/**
 是否是体验版   0 不是体验版 1 体验版
 */
@property (nonatomic, copy) NSString *is_experience;

/**
 到期时间
 */
@property (nonatomic, copy) NSString *due_time;

/**
 案例数据
 */
@property (nonatomic, strong) NSArray<KNBHomeServiceModel *> *caseList;

@end

NS_ASSUME_NONNULL_END
