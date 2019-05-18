//
//  KNBCityModel.h
//  FishFinishing
//
//  Created by apple on 2019/5/18.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBCityModel : KNBBaseModel

/**
 城市代码
 */
@property (nonatomic, strong) NSString *code;

/**
 城市名称
 */
@property (nonatomic, strong) NSString *name;
@end

NS_ASSUME_NONNULL_END
