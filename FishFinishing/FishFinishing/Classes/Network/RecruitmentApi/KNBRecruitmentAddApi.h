//
//  KNBRecruitmentAddApi.h
//  FishFinishing
//
//  Created by apple on 2019/4/11.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBRecruitmentAddApi : KNBBaseRequest

@property (nonatomic, copy) NSString *orderid;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *city_name;
@property (nonatomic, copy) NSString *area_name;
/**
 添加入驻商家

 @param catId cat_id
 @param tagId 擅长领域编号
 @param logo 服务商头像或logo
 @param serviceId 服务商服务编号
 @param name 公司或者人名
 @param phone 电话号码
 @param address 详细地址
 @param remark 描述
 */
- (instancetype)initWithCatId:(NSInteger)catId tagId:(NSString *)tagId logo:
(NSString *)logo serviceId:(NSString *)serviceId Name:(NSString *)name  phone:(NSString *)phone address:(NSString *)address remark:(NSString *)remark;
@end

NS_ASSUME_NONNULL_END
