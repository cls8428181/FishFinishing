//
//  KNGetUserLoaction.h
//  Concubine
//
//  Created by 刘随义 on 16/6/14.
//  Copyright © 2016年 dengyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "KNBCityModel.h"

typedef void (^KNUserLoactionCompleteBlock)(NSString *location, NSString *code);

@interface KNGetUserLoaction : NSObject <CLLocationManagerDelegate>
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *currentLng;
@property (nonatomic, copy) NSString *currentLat;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong, readonly) CLLocation *location;
@property (nonatomic, strong, readonly) NSDictionary *addressDictionary;
@property (nonatomic, strong) CLLocation *weatherLocation;
@property (nonatomic, readonly) BOOL isSelectCity; //default no
@property (nonatomic, copy) KNUserLoactionCompleteBlock completeBlock;

+ (instancetype)shareInstance;
/**
 用户选择的 城市
 */
@property (nonatomic,copy) NSString *selectCityName;

/**
 当前定位城市
 */
@property (nonatomic, copy) NSString *currentCityName;

/**
 当前定位城市Id
 */
@property (nonatomic, copy) NSString *currentCityCode;

/**
 *  开始定位
 */
- (void)startLocation;

/**
 *  定位坐标
 */
- (CLLocation *)cllocation;

/**
 *  保存用户定位信息
 *  @param cityName 城市名称
 *  @param areaId   区域ID（为空时保存的是定位的区名称）
 */
- (void)saveUserProvinceName:(NSString *)provinceName cityName:(NSString *)cityName areaName:(NSString *)areaName address:(NSString *)address areaId:(NSString *)areaId saveCompleteBlock:(void(^)(void))saveCompleteBlock;

/**
 *  当前省的名称
 */
- (NSString *)currentStateName;

/**
 *  当前省的Id
 */
- (NSString *)currentStateCode;

/**
 *  城市的名称
 */
- (NSString *)cityName;

/**
 *  如果是选中的城市有ID
 */
- (NSString *)cityAreaId;

/**
 *  区名称(定位的时候保存)
 */
- (NSString *)currentSubLocalityName;

/**
 *  当前区Id
 */
- (NSString *)currentSubLocalityCode;

/**
 完整的地址
 */
- (NSString *)fullAddress;

/**
 *  提示用户切换到城市
 *
 *  @param cityName 城市名
 */
- (NSAttributedString *)remidTitle:(NSString *)cityName;


/**
 *  商铺地址
 *
 *  @param address 详细地址
 */
- (void)searchShopAddress:(NSString *)address;

/**
 根据名称获取模型
 */
- (KNBCityModel *)getCityModel:(NSString *)cityName;

@end
