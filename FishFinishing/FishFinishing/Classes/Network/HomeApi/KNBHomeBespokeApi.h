//
//  KNBHomeBespokeApi.h
//  FishFinishing
//
//  Created by apple on 2019/4/17.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeBespokeApi : KNBBaseRequest

- (instancetype)initWithfacId:(NSInteger)faceId facName:(NSString *)faceName catId:(NSInteger)catId userId:(NSString *)userId areaInfo:(NSString *)areaInfo houseInfo:(NSString *)houseInfo community:(NSString *)community provinceId:(NSInteger)provinceId cityId:(NSInteger)cityId areaId:(NSInteger)areaId decorateStyle:(NSString *)decorateStyle decorateGrade:(NSString *)decorateGrade name:(NSString *)name mobile:(NSString *)mobile decorateCat:(NSString *)decorateCat;

@end

NS_ASSUME_NONNULL_END
