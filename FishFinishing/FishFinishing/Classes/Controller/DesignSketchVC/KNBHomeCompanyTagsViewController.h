//
//  KNBHomeCompanyTagsViewController.h
//  FishFinishing
//
//  Created by apple on 2019/4/18.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNBRecruitmentTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeCompanyTagsViewController : UIViewController
@property (nonatomic, strong) KNBRecruitmentTypeModel *model;
@property (nonatomic, assign) NSInteger areaId;
@property (nonatomic, assign) BOOL isDesign;
@end

NS_ASSUME_NONNULL_END
