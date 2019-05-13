//
//  KNBLoginBindingPhoneViewController.h
//  FishFinishing
//
//  Created by apple on 2019/4/25.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBLoginBindingPhoneViewController : KNBBaseViewController
@property (nonatomic, copy) void (^bindingComplete)(void);
- (instancetype)initWithDataSource:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
