//
//  KNBHomeBespokeApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/17.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBHomeBespokeApi.h"

@implementation KNBHomeBespokeApi {
    NSInteger _fac_id;                      //服务商编号
    NSString *_fac_name;                //服务商名称
    NSInteger _cat_id;                     //二级入驻类型编号
    NSString *_user_id;                   //用户编号
    NSString *_area_info;                //面积信息
    NSString *_house_info;              //户型
    NSString *_community;              //小区信息
    NSInteger _province_id;              //省编号
    NSInteger _city_id;                     //市编号
    NSInteger _area_id;                    //区编号
    NSString *_decorate_style;          //装修风格
    NSString *_decorate_grade;       //装修档次
    NSString *_name;                      //联系人
    NSString *_mobile;                    //联系电话
    NSString *_decorate_cat;           //新房旧房
    NSInteger _type;                       //1.报价 2.装修
    
}
- (instancetype)initWithFacId:(NSInteger)faceId facName:(NSString *)faceName catId:(NSInteger)catId userId:(NSString *)userId areaInfo:(NSString *)areaInfo houseInfo:(NSString *)houseInfo community:(NSString *)community provinceId:(NSInteger)provinceId cityId:(NSInteger)cityId areaId:(NSInteger)areaId decorateStyle:(NSString *)decorateStyle decorateGrade:(NSString *)decorateGrade name:(NSString *)name mobile:(NSString *)mobile decorateCat:(NSString *)decorateCat type:(NSInteger)type {
    if (self = [super init]) {
        _fac_id = faceId;
        _fac_name = faceName;
        _cat_id = catId;
        _user_id = userId;
        _area_info = areaInfo;
        _house_info = houseInfo;
        _community = community;
        _province_id = provinceId;
        _city_id = cityId;
        _area_id = areaId;
        _decorate_style = decorateStyle;
        _decorate_grade = decorateGrade;
        _name = name;
        _mobile = mobile;
        _decorate_cat = decorateCat;
        _type = type;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBOrder_Bespoke];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"fac_id" : @(_fac_id) ?: @(0),
                          @"fac_name" : _fac_name ?: @"",
                          @"cat_id" : @(_cat_id) ?: @(0),
                          @"user_id" : _user_id ?: @"",
                          @"area_info" : _area_info ?: @"",
                          @"house_info" : _house_info ?: @"",
                          @"community" : _community ?: @"",
                          @"province_id" : @(_province_id),
                          @"city_id" : @(_city_id),
                          @"area_id" : @(_area_id),
                          @"decorate_style" : _decorate_style ?: @"",
                          @"decorate_grade" : _decorate_grade ?: @"",
                          @"name" : _name ?: @"",
                          @"mobile" : _mobile ?: @"",
                          @"decorate_cat" : _decorate_cat ?: @"",
                          @"type" : @(_type) ? : @(1)
                          }; //字典
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}
@end
