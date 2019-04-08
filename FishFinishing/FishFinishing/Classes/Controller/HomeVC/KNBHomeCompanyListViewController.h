//
//  KNBHomeCompanyListViewController.h
//  FishFinishing
//
//  Created by 常立山 on 2019/4/8.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBBaseViewController.h"

typedef NS_ENUM(NSInteger, KNBHomeListType) {
    KNBHomeListTypeCompany = 0,     //装修公司
    KNBHomeListTypeForeman,         //找工长
    KNBHomeListTypeDesign,          //找设计
    KNBHomeListTypeMaterial,        //家居建材
    KNBHomeListTypeWorker           //装修工人
};
NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeCompanyListViewController : KNBBaseViewController

@property (nonatomic, assign) KNBHomeListType VCtype;
@end

NS_ASSUME_NONNULL_END
