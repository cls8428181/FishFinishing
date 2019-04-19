//
//  KNBHomeCompanyUploadCaseViewController.h
//  FishFinishing
//
//  Created by apple on 2019/4/19.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeCompanyUploadCaseViewController : KNBBaseViewController
@property (nonatomic, copy) void (^saveSuccessBlock)(void);
@end

NS_ASSUME_NONNULL_END
