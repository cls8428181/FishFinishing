//
//  KNBMeModifyInfoViewController.h
//  FishFinishing
//
//  Created by apple on 2019/4/29.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBMeModifyInfoViewController : KNBBaseViewController
@property (nonatomic, copy) void (^modifyComplete)(void);
@end

NS_ASSUME_NONNULL_END
