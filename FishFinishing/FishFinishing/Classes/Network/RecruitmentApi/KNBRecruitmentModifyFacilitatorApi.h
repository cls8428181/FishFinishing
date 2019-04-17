//
//  KNBRecruitmentModifyFacilitatorApi.h
//  FishFinishing
//
//  Created by apple on 2019/4/17.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBRecruitmentModifyFacilitatorApi : KNBBaseRequest

/**
 类别编号
 */
@property (nonatomic, assign) NSInteger cat_id;

/**
 区域名称
 */
@property (nonatomic, copy) NSString *area_name;

/**
 擅长领域编号
 */
@property (nonatomic, copy) NSString *tag_id;

/**
 服务商头像或logo
 */
@property (nonatomic, copy) NSString *logo;

/**
 服务商服务编号
 */
@property (nonatomic, copy) NSString *service_id;

/**
 经度
 */
@property (nonatomic, copy) NSString *lng;

/**
 纬度
 */
@property (nonatomic, copy) NSString *lat;
/**
 公司或者人名
 */
@property (nonatomic, copy) NSString *name;

/**
 电话号码
 */
@property (nonatomic, copy) NSString *telephone;

/**
 详细地址
 */
@property (nonatomic, copy) NSString *address;

/**
 描述
 */
@property (nonatomic, copy) NSString *remark;
@end

NS_ASSUME_NONNULL_END
