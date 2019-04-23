//
//  KNBRecruitmentAddCaseApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/11.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBRecruitmentAddCaseApi.h"

@implementation KNBRecruitmentAddCaseApi {
    NSString *_token;
    NSString *_title;
    NSInteger _style_id;
    double _acreage;
    NSString *_apartment;
    NSString *_imgs;
    NSString *_price;
}

- (instancetype)initWithToken:(NSString *)token title:(NSString *)title styleId:(NSInteger)styleId acreage:(double)acreage apartment:(NSString *)apartment imgs:(NSString *)imgs {
    if (self = [super init]) {
        _token = token;
        _title = title;
        _style_id = styleId;
        _acreage = acreage;
        _apartment = apartment;
        _imgs = imgs;
        _type = 1;
    }
    return self;
}

- (instancetype)initWithToken:(NSString *)token title:(NSString *)title price:(NSString *)price imgs:(NSString *)imgs {
    if (self = [super init]) {
        _token = token;
        _title = title;
        _price = price;
        _imgs = imgs;
        _type = 2;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBRecruitment_AddCase];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"token" : _token,
                          @"type" : @(_type) ?: @(1),
                          @"title" : _title,
                          @"style_id" : @(_style_id),
                          @"acreage" : @(_acreage),
                          @"apartment" : _apartment,
                          @"remark" : _remark ?: @"",
                          @"price" : _price ?: @"",
                          @"imgs" : _imgs
                          };
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.baseMuDic;
}

@end
