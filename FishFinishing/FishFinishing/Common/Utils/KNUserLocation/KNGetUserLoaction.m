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

NSString *const KNLocationCoordinate2D = @"KNLocationCoordinate2D"; // 经纬度对象
NSString *const KNLocationLongitude = @"KNLocationLongitude"; // 经度
NSString *const KNLocationLatitude = @"KNLocationLatitude"; // 纬度
NSString *const KNLocationAddress = @"KNLocationAddress"; // 地址
NSString *const KNLocationStateName = @"KNLocationStateName";       // 省
NSString *const KNLocationCityName = @"KNLocationCityName";         // 市
NSString *const KNLocationSubLocality = @"KNLocationSubLocality";   //区名称(定位的时候使用)
NSString *const KNLocationAreaId = @"KNLocationAreaId";             // 城市id
NSString *const KNSaveUserLocation = @"KNSaveUserLocation";


@interface KNGetUserLoaction ()

@property (nonatomic, copy) NSString *state;       // 省
@property (nonatomic, copy) NSString *city;        // 市
@property (nonatomic, copy) NSString *subLocality; // 区
@property (nonatomic, strong, readwrite) CLLocation *location;
@property (nonatomic, readwrite) BOOL isSelectCity; //default no
@property (nonatomic, strong, readwrite) NSDictionary *addressDictionary;

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

            if ([self.state isEqualToString:self.stateName] &&
                [self.city isEqualToString:self.cityName] &&
                ![self.subLocality isEqualToString:self.subLocalityName]) {
                [self saveUserCityName:nil address:nil areaId:nil saveCompleteBlock:nil];
            } else {
                if (!isNullStr(self.stateName) && !isNullStr(self.cityAreaId) && !isNullStr(self.subLocalityName)) {
                    [self saveUserCityName:nil address:nil areaId:nil saveCompleteBlock:nil];
                }
            }
            if (![self.city isEmpty]) {
                [self saveUserCityName:self.city address:nil areaId:nil saveCompleteBlock:nil];
                if (self.completeBlock) {
                    self.completeBlock(self.city);
                }
            }
        }
    }];
}


#pragma mark - Private Method
- (void)saveUserCityName:(NSString *)cityName address:(NSString *)address areaId:(NSString *)areaId saveCompleteBlock:(void(^)(void))saveCompleteBlock {
    if (isNullStr(address)) {
        if (areaId) {
            self.isSelectCity = YES;
            [self saveLocationInfo:@{KNLocationCityName : cityName,
                                         KNLocationAddress : @"",
                                         KNLocationAreaId : areaId,
                                         KNLocationLongitude : self.lng,
                                         KNLocationLatitude : self.lat
                                         }];
        } else {
            self.isSelectCity = NO;
            [self saveLocationInfo:@{KNLocationStateName : self.state,
                                     KNLocationCityName : self.city,
                                     KNLocationAddress : @"",
                                     KNLocationSubLocality : self.subLocality,
                                     KNLocationLongitude : self.lng,
                                     KNLocationLatitude : self.lat
                                         }];
        }
        !saveCompleteBlock ?: saveCompleteBlock();
    } else {
        KNB_WS(weakSelf);
        CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
        [myGeocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
            if ([placemarks count] > 0 && error == nil) {
                CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
                if (areaId) {
                    weakSelf.isSelectCity = YES;
                    [weakSelf saveLocationInfo:@{KNLocationCityName : cityName,
                                                 KNLocationAddress : address,
                                                 KNLocationAreaId : areaId,
                                                 KNLocationLongitude : @(firstPlacemark.location.coordinate.longitude),
                                                 KNLocationLatitude : @(firstPlacemark.location.coordinate.latitude)
                                                 }];
                } else {
                    weakSelf.isSelectCity = NO;
                    [weakSelf saveLocationInfo:@{KNLocationStateName : weakSelf.state,
                                                 KNLocationCityName : weakSelf.city,
                                                 KNLocationAddress : address,
                                                 KNLocationSubLocality : weakSelf.subLocality,
                                                 KNLocationLongitude : @(firstPlacemark.location.coordinate.longitude),
                                                 KNLocationLatitude : @(firstPlacemark.location.coordinate.latitude)
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

- (NSString *)subLocalityName {
    NSDictionary *dic = [self userLocation];
    NSString *name = dic[KNLocationSubLocality];
    return name ? name : @"";
}

- (NSString *)stateName {
    NSDictionary *dic = [self userLocation];
    NSString *name = dic[KNLocationStateName];
    return name ? name : @"";
}

- (NSString *)currentLat {
    NSDictionary *dic = [self userLocation];
    NSString *lat = [NSString stringWithFormat:@"%@",dic[KNLocationLatitude]];
    return lat ? lat : @"";
}

- (NSString *)currentLng {
    NSDictionary *dic = [self userLocation];
    NSString *lng = [NSString stringWithFormat:@"%@",dic[KNLocationLongitude]];;
    return lng ? lng : @"";
}

- (CLLocation *)cllocation {
    return self.location;
}

- (NSString *)lat {
    return [NSString stringWithFormat:@"%f",self.location.coordinate.latitude];
}

- (NSString *)lng {
    return [NSString stringWithFormat:@"%f",self.location.coordinate.longitude];
}

/**
 完整的地址
 */
- (NSString *)fullAddress {
    return [NSString stringWithFormat:@"%@%@%@", self.stateName, self.cityName, self.subLocalityName];
}

- (NSDictionary *)userLocation {
    return [[NSUserDefaults standardUserDefaults] objectForKey:KNSaveUserLocation];
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

@end
