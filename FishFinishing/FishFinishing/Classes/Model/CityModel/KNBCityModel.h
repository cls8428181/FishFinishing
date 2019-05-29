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
 代码
 */
@property (nonatomic, copy) NSString *code;

/**
 名称
 */
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *isOpen;
@property (nonatomic, copy) NSString *isHot;
@property (nonatomic, copy) NSString *temp;
@property (nonatomic, copy) NSString *letter;
@property (nonatomic, copy) NSString *pinyin;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *region;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *status;
/**
 城市列表
 */
@property (nonatomic, strong) NSArray <KNBCityModel *>*cityList;

/**
 地区列表
 */
@property (nonatomic, strong) NSArray <KNBCityModel *>*areaList;
@end

NS_ASSUME_NONNULL_END
