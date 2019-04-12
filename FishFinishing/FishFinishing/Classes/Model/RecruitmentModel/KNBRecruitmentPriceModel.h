//
//  KNBRecruitmentPriceModel.h
//  FishFinishing
//
//  Created by apple on 2019/4/12.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBRecruitmentPriceModel : KNBBaseModel
@property (nonatomic, copy) NSString *priceId;
@property (nonatomic, copy) NSString *name;

/**
 费用
 */
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *termType;
@property (nonatomic, copy) NSString *term;
@property (nonatomic, copy) NSString *remark;
@end

NS_ASSUME_NONNULL_END
