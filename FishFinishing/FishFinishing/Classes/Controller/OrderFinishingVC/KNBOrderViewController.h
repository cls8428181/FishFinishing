//
//  KNBOrderViewController.h
//  FishFinishing
//
//  Created by 常立山 on 2019/4/8.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBBaseViewController.h"
#import "KNBDesignSketchModel.h"

typedef NS_ENUM(NSInteger, KNBOrderVCType) {
    KNBOrderVCTypeOrderFinishing = 0,       //预约装修
    KNBOrderVCTypeRecruitment,              //立即入驻
};

NS_ASSUME_NONNULL_BEGIN

@interface KNBOrderViewController : KNBBaseViewController

@property (nonatomic, strong) KNBDesignSketchModel *model;

@property (nonatomic, assign) KNBOrderVCType VCType;

/**
 是否是预约
 */
@property (nonatomic, assign) BOOL isExperience;

/**
 是否是预约
 */
@property (nonatomic, assign) BOOL isStyleEnable;

@end

NS_ASSUME_NONNULL_END
