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
@property (nonatomic, strong) NSString *code;

/**
 名称
 */
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *isOpen;
@property (nonatomic, strong) NSString *isHot;
@property (nonatomic, strong) NSString *temp;
@property (nonatomic, strong) NSString *letter;
@property (nonatomic, strong) NSString *pinyin;
@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSString *status;
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
