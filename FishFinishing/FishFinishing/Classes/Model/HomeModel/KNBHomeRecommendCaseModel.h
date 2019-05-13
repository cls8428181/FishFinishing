//
//  KNBHomeRecommendCaseModel.h
//  FishFinishing
//
//  Created by 常立山 on 2019/4/22.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeRecommendCaseModel : KNBBaseModel

/**
 ID
 */
@property (nonatomic, copy) NSString *caseId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *cat_name;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *enable;
@property (nonatomic, copy) NSString *creater;
@property (nonatomic, copy) NSString *creater_at;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *updater;
@property (nonatomic, copy) NSString *updater_at;
@property (nonatomic, copy) NSString *min_area;
@property (nonatomic, copy) NSString *max_area;

@end

NS_ASSUME_NONNULL_END
