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

typedef NS_ENUM(NSInteger, KNBPayVCType) {
    KNBPayVCTypeRecruitment = 0,       //入驻支付
    KNBPayVCTypeTop,                   //置顶支付
    KNBPayVCTypeExperience             //体验支付
};

NS_ASSUME_NONNULL_BEGIN

@interface KNBRecruitmentPayViewController : KNBBaseViewController

@property (nonatomic, strong) KNBRecruitmentModel *recruitmentModel;
@property (nonatomic, assign) KNBPayVCType type;

@end

NS_ASSUME_NONNULL_END
