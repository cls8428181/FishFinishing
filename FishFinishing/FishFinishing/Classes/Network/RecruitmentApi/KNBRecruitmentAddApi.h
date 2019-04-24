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

/**
 添加入驻商家

 @param catId cat_id
 @param cityName 城市
 @param tagId 擅长领域编号
 @param logo 服务商头像或logo
 @param serviceId 服务商服务编号
 @param lng 经度
 @param lat 纬度
 @param name 公司或者人名
 @param phone 电话号码
 @param address 详细地址
 @param remark 描述
 @param costId 入驻费用编号
 */
- (instancetype)initWithCatId:(NSInteger)catId cityName:(NSString *)cityName tagId:(NSString *)tagId logo:
(NSString *)logo serviceId:(NSString *)serviceId lng:(NSString *)lng lat:(NSString *)lat Name:(NSString *)name  phone:(NSString *)phone address:(NSString *)address remark:(NSString *)remark costId:(NSInteger)costId;
@end

NS_ASSUME_NONNULL_END
