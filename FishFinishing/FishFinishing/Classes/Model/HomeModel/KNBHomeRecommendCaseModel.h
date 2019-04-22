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
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *case_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *acreage;
@property (nonatomic, copy) NSString *apartment;
@property (nonatomic, copy) NSString *style_name;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *apart;

@end

NS_ASSUME_NONNULL_END
