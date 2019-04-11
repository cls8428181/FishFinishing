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
 添加装修案例

 @param token 用户登录标识
 @param title 案列描述
 @param styleId 装修风格编号
 @param acreage 面积
 @param room 卧室数
 @param office 厅数
 @param wei 卫生间数
 @param kitchen 厨房数
 @param balcony 阳台数
 @param imgs 案列图片
 */
- (instancetype)initWithToken:(NSString *)token title:(NSString *)title styleId:(NSInteger)styleId acreage:(double)acreage room:(NSInteger)room office:(NSInteger)office wei:(NSInteger)wei kitchen:(NSInteger)kitchen balcony:(NSInteger)balcony imgs:(NSString *)imgs;

@end

NS_ASSUME_NONNULL_END
