//
//  KNBRecruitmentPayViewController.h
//  FishFinishing
//
//  Created by 常立山 on 2019/4/9.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBBaseViewController.h"
#import "KNBRecruitmentModel.h"
#import "KNBHomeServiceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBRecruitmentPayViewController : KNBBaseViewController

@property (nonatomic, strong) KNBRecruitmentModel *recruitmentModel;
@property (nonatomic, strong) KNBHomeServiceModel *serviceModel;

@end

NS_ASSUME_NONNULL_END
