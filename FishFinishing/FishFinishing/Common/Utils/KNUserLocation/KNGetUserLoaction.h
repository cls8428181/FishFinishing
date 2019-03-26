//
//  KNGetUserLoaction.h
//  Concubine
//
//  Created by 刘随义 on 16/6/14.
//  Copyright © 2016年 dengyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^KNUserLoactionCompleteBlock)(NSString *location);

@interface KNGetUserLoaction : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong, readonly) CLLocation *location;
@property (nonatomic, strong, readonly) NSDictionary *addressDictionary;
@property (nonatomic, strong) CLLocation *weatherLocation;
@property (nonatomic, readonly) BOOL isSelectCity; //default no
@property (nonatomic, copy) KNUserLoactionCompleteBlock completeBlock;

+ (instancetype)shareInstance;

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
- (void)saveUserCityName:(NSString *)cityName
                  areaId:(NSString *)areaId;

/**
 *  省的名称
 */
- (NSString *)stateName;

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
- (NSString *)subLocalityName;


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

@end
