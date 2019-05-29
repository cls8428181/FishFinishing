//
//  KNGetUserLoaction.m
//  Concubine
//
//  Created by 刘随义 on 16/6/14.
//  Copyright © 2016年 dengyun. All rights reserved.
//

#import "KNGetUserLoaction.h"
#import "NSString+Contain.h"
#import "NSString+Empty.h"
#import "AppDelegate.h"
#import "LCProgressHUD.h"
#import <JZLocationConverter.h>

NSString *const KNLocationCoordinate2D = @"KNLocationCoordinate2D"; // 经纬度对象
NSString *const KNLocationLongitude = @"KNLocationLongitude"; // 经度
NSString *const KNLocationLatitude = @"KNLocationLatitude"; // 纬度
NSString *const KNLocationAddress = @"KNLocationAddress"; // 地址
NSString *const KNLocationStateName = @"KNLocationStateName";       // 省
NSString *const KNLocationCityName = @"KNLocationCityName";         // 市
NSString *const KNLocationSubLocality = @"KNLocationSubLocality";   //区名称(定位的时候使用)
NSString *const KNLocationAreaId = @"KNLocationAreaId";             // 城市id
NSString *const KNSaveUserLocation = @"KNSaveUserLocation";      //选择位置信息保存
NSString *const KNSaveUserCurrentLocation = @"KNSaveUserCurrentLocation";      //当前位置信息保存

@interface KNGetUserLoaction ()

@property (nonatomic, copy) NSString *state;       // 省
@property (nonatomic, copy) NSString *city;        // 市
@property (nonatomic, copy) NSString *subLocality; // 区
@property (nonatomic, strong, readwrite) CLLocation *location;
@property (nonatomic, readwrite) BOOL isSelectCity; //default no
@property (nonatomic, strong, readwrite) NSDictionary *addressDictionary;
@property (nonatomic, strong) NSArray *cityDataArray;
@end


@implementation KNGetUserLoaction

+ (instancetype)shareInstance {
    static KNGetUserLoaction *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureLocationManager];
    }
    return self;
}

- (void)startLocation {
    [self.locationManager startUpdatingLocation];
}

- (void)configureLocationManager {
    // 默认城市 和 区
    NSDictionary *location = @{ KNLocationStateName : @"北京市",
                                KNLocationCityName : @"北京市",
                                KNLocationAreaId : @"fc0a0d36184a11e69c04080027618918",
                                KNLocationSubLocality : @"朝阳区" };
    if (![self userLocation]) {
        // 默认经纬度坐标
        self.location = [[CLLocation alloc] initWithLatitude:39.911858 longitude:116.480896];
        [self saveLocationInfo:location];
    }
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    if (KNB_SYSTEM_VERSION > 8.0) {
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager requestAlwaysAuthorization];
    }
}

#pragma mark--- CLLocationManagerDelegate
//查看用户是否同意
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways:
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest; // 精确度
            [self.locationManager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusDenied:
            break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"%@", error.description);
}


//已经定位到用户的位置
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
    [self.locationManager stopUpdatingLocation];
    @weakify(self);
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> *_Nullable placemarks, NSError *_Nullable error) {
        if (!error) {
            @strongify(self);
            CLPlacemark *placemark = placemarks[0];
            NSDictionary *dic = placemark.addressDictionary;
            self.addressDictionary = dic;
//            [[KNBGroManager shareInstance] upLocationProperties:dic];
            self.location = placemark.location;
            self.weatherLocation = placemark.location;
            self.state = dic[@"State"] ?: @"";             //省
            self.city = dic[@"City"] ?: @"";               //市
            self.subLocality = dic[@"SubLocality"] ?: @""; // 区

            if ([self.state isEqualToString:self.currentStateName] &&
                [self.city isEqualToString:self.currentCityName] &&
                ![self.subLocality isEqualToString:self.currentSubLocalityName]) {
                [self saveUserProvinceName:nil cityName:nil areaName:nil address:nil areaId:nil saveCompleteBlock:nil];
            } else {
                if (!isNullStr(self.currentStateName) && !isNullStr(self.cityAreaId) && !isNullStr(self.currentSubLocalityName)) {
                    [self saveUserProvinceName:nil cityName:nil areaName:nil address:nil areaId:nil saveCompleteBlock:nil];
                }
            }
            if (![self.city isEmpty]) {
                [self saveUserProvinceName:self.state cityName:self.city areaName:self.subLocality address:nil areaId:nil saveCompleteBlock:nil];
                
                
                KNBCityModel *model = [self getCityModel:self.city];
                if (model) {
                    [KNBCityModel saveWithModel:model resultBlock:^(BOOL success) {
                    }];
                    if (self.completeBlock) {
                        self.completeBlock(model.name, model.code);
                    }
                }
            }
        }
    }];
}


#pragma mark - Private Method
- (void)saveUserProvinceName:(NSString *)provinceName cityName:(NSString *)cityName areaName:(NSString *)areaName address:(NSString *)address areaId:(NSString *)areaId saveCompleteBlock:(void(^)(void))saveCompleteBlock {
    if (isNullStr(address)) {
        CLLocationCoordinate2D wgsPt = self.location.coordinate;
        CLLocationCoordinate2D bd = [JZLocationConverter gcj02ToBd09:wgsPt];
        
        if (areaId) {
            self.isSelectCity = YES;
            [self saveLocationInfo:@{KNLocationStateName : provinceName ?: @"",
                                     KNLocationCityName : cityName ?: @"",
                                     KNLocationSubLocality : areaName ?: @"",
                                     KNLocationAddress : @"",
                                     KNLocationAreaId : areaId ?: @"",
                                     KNLocationLongitude : @(bd.longitude),
                                     KNLocationLatitude : @(bd.latitude)
                                     }];
        } else {
            self.isSelectCity = NO;
            [self saveCurrentLocationInfo:@{KNLocationStateName : self.state,
                                     KNLocationCityName : self.city,
                                     KNLocationSubLocality : self.subLocality,
                                     KNLocationAddress : @"",
                                     KNLocationSubLocality : self.subLocality,
                                            KNLocationLongitude : @(bd.longitude),
                                            KNLocationLatitude : @(bd.latitude)
                                            }];
        }
        !saveCompleteBlock ?: saveCompleteBlock();
    } else {
        KNB_WS(weakSelf);
        CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
        [myGeocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
            if ([placemarks count] > 0 && error == nil) {
                CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
                CLLocationCoordinate2D wgsPt = firstPlacemark.location.coordinate;
                CLLocationCoordinate2D bd = [JZLocationConverter gcj02ToBd09:wgsPt];
                if (areaId) {
                    weakSelf.isSelectCity = YES;
                    [weakSelf saveLocationInfo:@{KNLocationStateName : provinceName ?: @"",
                                                 KNLocationCityName : cityName ?: @"",
                                                 KNLocationSubLocality : areaName ?: @"",
                                                 KNLocationAddress : address ?: @"",
                                                 KNLocationAreaId : areaId ?: @"",
                                                 KNLocationLongitude : @(bd.longitude),
                                                 KNLocationLatitude : @(bd.latitude)
                                                 }];
                } else {
                    weakSelf.isSelectCity = NO;
                    [weakSelf saveCurrentLocationInfo:@{KNLocationStateName : weakSelf.state,
                                                 KNLocationCityName : weakSelf.city,
                                                 KNLocationSubLocality : weakSelf.subLocality,
                                                 KNLocationAddress : address,
                                                 KNLocationSubLocality : weakSelf.subLocality,
                                                 KNLocationLongitude : @(bd.longitude),
                                                 KNLocationLatitude : @(bd.latitude)
                                                 }];
                }

                !saveCompleteBlock ?: saveCompleteBlock();

            } else if ([placemarks count] == 0 && error == nil) {
                NSLog(@"Found no placemarks.");
            } else if (error != nil) {
                NSLog(@"An error occurred = %@", error);
            }
        }];
    }

}

- (void)saveLocationInfo:(NSDictionary *)dic {
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:KNSaveUserLocation];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveCurrentLocationInfo:(NSDictionary *)dic {
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:KNSaveUserCurrentLocation];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (KNBCityModel *)getCityModel:(NSString *)cityName {
    for (int i = 0; i < self.cityDataArray.count; i++) {
        KNBCityModel *provinceModel = self.cityDataArray[i];
        NSArray *cityArray = provinceModel.cityList;
        for (int j = 0; j < cityArray.count; j++) {
            KNBCityModel *cityModel = cityArray[j];
            if ([cityModel.name containsString:cityName]) {
                return cityModel;
            }
        }
    }
    return nil;
}

- (NSString *)currentStateCode {
    for (int i = 0; i < self.cityDataArray.count; i++) {
        KNBCityModel *provinceModel = self.cityDataArray[i];
        if ([provinceModel.name containsString:self.currentStateName]) {
            return provinceModel.code;
        }
    }
    return @"";
}

- (NSString *)currentCityCode {
    for (int i = 0; i < self.cityDataArray.count; i++) {
        KNBCityModel *provinceModel = self.cityDataArray[i];
        NSArray *cityArray = provinceModel.cityList;
        for (int j = 0; j < cityArray.count; j++) {
            KNBCityModel *cityModel = cityArray[j];
            if ([cityModel.name containsString:self.currentCityName]) {
                return cityModel.code;
            }
        }
    }
    return @"";
}

- (NSString *)currentSubLocalityCode {
    for (int i = 0; i < self.cityDataArray.count; i++) {
        KNBCityModel *provinceModel = self.cityDataArray[i];
        NSArray *cityArray = provinceModel.cityList;
        for (int j = 0; j < cityArray.count; j++) {
            KNBCityModel *cityModel = cityArray[j];
            NSArray *areaArray = cityModel.areaList;
            for (int k = 0; k < areaArray.count; k++) {
                KNBCityModel *areaModel = areaArray[k];
                if ([areaModel.name containsString:self.currentSubLocalityName]) {
                    return areaModel.code;
                }
            }
        }
    }
    return @"";
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)searchShopAddress:(NSString *)address {
    if (!address || address.length == 0) {
        [LCProgressHUD showInfoMsg:@"地址不能为空!"];
        return;
    }
    address = [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"http://api.map.baidu.com/geocoder?address=%@&src=mtmy&output=html", address];
    NSURL *addressUrl = [NSURL URLWithString:url];
    if ([[UIApplication sharedApplication] canOpenURL:addressUrl]) {
        [[UIApplication sharedApplication] openURL:addressUrl];
    } else {
        [LCProgressHUD showFailure:@"地址错误!无法打开!"];
    }
}
#pragma clang diagnostic pop

#pragma mark - Getting && Setting

- (CLGeocoder *)geocoder {
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (NSString *)cityName {
    NSDictionary *dic = [self userLocation];
    NSString *name = dic[KNLocationCityName];
    return name;
}

- (NSString *)cityAreaId {
    NSDictionary *dic = [self userLocation];
    NSString *areaId = dic[KNLocationAreaId];
    return areaId ? areaId : @"";
}

- (NSString *)currentSubLocalityName {
    NSDictionary *dic = [self userCurrentLocation];
    NSString *name = dic[KNLocationSubLocality];
    return name ? name : @"";
}

- (NSString *)currentStateName {
    NSDictionary *dic = [self userCurrentLocation];
    NSString *name = dic[KNLocationStateName];
    return name ? name : @"";
}

- (NSString *)currentCityName {
    NSDictionary *dic = [self userCurrentLocation];
    NSString *name = dic[KNLocationCityName];
    return name ? name : @"";
}

- (NSString *)currentLat {
    NSDictionary *dic = [self userCurrentLocation];
    NSString *lat = [NSString stringWithFormat:@"%@",dic[KNLocationLatitude]];
    return lat ? lat : @"";
}

- (NSString *)currentLng {
    NSDictionary *dic = [self userCurrentLocation];
    NSString *lng = [NSString stringWithFormat:@"%@",dic[KNLocationLongitude]];;
    return lng ? lng : @"";
}

- (CLLocation *)cllocation {
    return self.location;
}

- (NSString *)lat {
    NSDictionary *dic = [self userLocation];
    NSString *lat = [NSString stringWithFormat:@"%@",dic[KNLocationLatitude]];
    return lat ? lat : @"";
}

- (NSString *)lng {
    NSDictionary *dic = [self userLocation];
    NSString *lng = [NSString stringWithFormat:@"%@",dic[KNLocationLongitude]];;
    return lng ? lng : @"";
}

/**
 完整的地址
 */
- (NSString *)fullAddress {
    return [NSString stringWithFormat:@"%@%@%@", self.currentStateName, self.currentCityName, self.currentSubLocalityName];
}

- (NSDictionary *)userLocation {
    return [[NSUserDefaults standardUserDefaults] objectForKey:KNSaveUserLocation];
}

- (NSDictionary *)userCurrentLocation {
    return [[NSUserDefaults standardUserDefaults] objectForKey:KNSaveUserCurrentLocation];
}

//设置城市地址字体高亮为黄色
- (NSAttributedString *)remidTitle:(NSString *)cityName {
    cityName = [cityName replaceString:@"市" withString:@""];
    NSString *text = [NSString stringWithFormat:@"系统检测到您当前所处城市为%@,需要切换至%@吗?", cityName, cityName];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor knMainColor] range:NSMakeRange(13, cityName.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor knMainColor] range:NSMakeRange(13 + cityName.length + 6, cityName.length)];
    return str;
}

- (NSArray *)cityDataArray {
    if (!_cityDataArray) {
        NSString *areasPath = [[NSBundle mainBundle] pathForResource:@"KNBCity" ofType:@"plist"];
        NSArray *dataArray = [NSArray arrayWithContentsOfFile:areasPath];
        _cityDataArray = [KNBCityModel changeResponseJSONObject:dataArray];
    }
    return _cityDataArray;
}
@end
