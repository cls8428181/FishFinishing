//
//  KNBCityModel.h
//  FishFinishing
//
//  Created by apple on 2019/4/16.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBCityModel : KNBBaseModel
/**
 省 id/市 id/区 id
 */
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *isOpen;
@property (nonatomic, strong) NSString *isHot;
@property (nonatomic, strong) NSString *temp;
@property (nonatomic, strong) NSString *letter;
@property (nonatomic, strong) NSString *pinyin;
@property (nonatomic, strong) NSString *level;

/**
 城市列表
 */
@property (nonatomic, strong) NSArray *cityList;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *sort;

/**
 省/市/区名称
 */
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *status;

/**
 区列表
 */
@property (nonatomic, strong) NSArray *areaList;
@property (nonatomic, strong) NSArray *dataList;
@end

NS_ASSUME_NONNULL_END
