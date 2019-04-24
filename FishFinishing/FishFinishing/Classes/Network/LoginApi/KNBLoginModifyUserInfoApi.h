//
//  KNBLoginModifyUserInfoApi.h
//  FishFinishing
//
//  Created by apple on 2019/4/23.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBLoginModifyUserInfoApi : KNBBaseRequest

/**
 修改用户信息
 */
- (instancetype)initWithPortraitImg:(NSString *)portraitImg nickName:(NSString *)nickName;

@end

NS_ASSUME_NONNULL_END
