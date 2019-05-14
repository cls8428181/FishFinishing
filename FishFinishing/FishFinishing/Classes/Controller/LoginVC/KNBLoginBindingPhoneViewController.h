//
//  KNBLoginBindingPhoneViewController.h
//  FishFinishing
//
//  Created by apple on 2019/4/25.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseViewController.h"
#import "KNBLoginThirdPartyApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBLoginBindingPhoneViewController : KNBBaseViewController

/**
 标识
 */
@property (nonatomic, copy) NSString *openId;

/**
 平台类型
 */
@property (nonatomic, assign) KNBLoginThirdPartyType type;

/**
 头像
 */
@property (nonatomic, copy) NSString *portrait;

/**
 昵称
 */
@property (nonatomic, copy) NSString *nickName;

/**
 性别
 */
@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) void (^bindingComplete)(void);
- (instancetype)initWithDataSource:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
