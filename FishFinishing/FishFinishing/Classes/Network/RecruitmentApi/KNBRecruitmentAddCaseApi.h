//
//  KNBRecruitmentAddCaseApi.h
//  FishFinishing
//
//  Created by apple on 2019/4/11.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBRecruitmentAddCaseApi : KNBBaseRequest

/**
 上传类型 默认值是1
 1：案列
 2：产品
 */
@property (nonatomic, assign) NSInteger type;

/**
 简介
 */
@property (nonatomic, copy) NSString *remark;

/**
 添加装修案例

 @param title 案列描述
 @param styleId 装修风格编号
 @param acreage 面积
 */
- (instancetype)initWithTitle:(NSString *)title styleId:(NSInteger)styleId acreage:(double)acreage apartment:(NSString *)apartment imgs:(NSString *)imgs;

/**
 添加产品

 @param title 名称
 @param price 价格
 */
- (instancetype)initWithTitle:(NSString *)title price:(NSString *)price imgs:(NSString *)imgs;
@end

NS_ASSUME_NONNULL_END
