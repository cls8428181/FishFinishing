//
//  KNBHomeCompanyDetailViewController.h
//  FishFinishing
//
//  Created by 常立山 on 2019/4/3.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBBaseViewController.h"
#import "KNBHomeServiceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeCompanyDetailViewController : KNBBaseViewController
@property (nonatomic, strong) KNBHomeServiceModel *model;

/**
 能否编辑
 */
@property (nonatomic, assign) BOOL isEdit;
@end

NS_ASSUME_NONNULL_END
