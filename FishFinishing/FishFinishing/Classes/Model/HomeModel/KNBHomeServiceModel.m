//
//  KNBHomeServiceModel.m
//  FishFinishing
//
//  Created by apple on 2019/4/18.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBHomeServiceModel.h"
#import "NSString+Size.h"

@implementation KNBHomeServiceModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"serviceList" : @"service",
             @"logo" : @"logo",
             @"serviceId" : @"id",
             @"remark" : @"remark",
             @"created_at" : @"created_at",
             @"province_name" : @"province_name",
             @"city_name" : @"city_name",
             @"area_name" : @"area_name",
             @"telephone" : @"telephone",
             @"address" : @"address",
             @"share_name" : @"share_name",
             @"parent_cat_id" : @"cat_parent_id",
             @"due_time" : @"due_time",
             @"cat_name" : @"cat_name",
             @"check_in" : @"check_in",
             @"path" : @"path",
             @"is_stick" : @"is_stick",
             @"tag" : @"tag",
             @"cat_id" : @"cat_id",
             @"fac_id" : @"fac_id",
             @"name" : @"name",
             @"parent_cat_name" : @"parent_cat_name",
             @"facilitator_id" : @"facilitator_id",
             @"price" : @"price",
             @"caseList" : @"case",
             @"is_experience" : @"is_experience",
             @"share_id" : @"share_id",
             @"subscribe_type" : @"subscribe_type",
             @"service_name" : @"service_name",
             @"icon" : @"icon",
             @"img" : @"img",
             @"is_recommend" : @"is_recommend",
             @"distance" : @"distance",
             @"apart_name" : @"apart_name",
             @"style_name" : @"style_name",
             @"acreage" : @"acreage",
             @"title" : @"title",
             @"status" : @"status"
             };
}

+ (NSValueTransformer *)caseListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:KNBHomeServiceModel.class];
}

+ (NSValueTransformer *)serviceListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:KNBHomeServiceModel.class];
}

- (void)setRemark:(NSString *)remark {
    _remark = remark;
    CGFloat w = [UIScreen mainScreen].bounds.size.width - 24;
    CGFloat h = MAXFLOAT;
    NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
    CGFloat height = [remark boundingRectWithSize:CGSizeMake(w, h) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.height;
    if (self.isOpen) {
        _remarkHeight = height + 111;
        _isShow = YES;
    } else {
        if (height < 55) {
            _remarkHeight = height + 81;
            _isShow = NO;
        } else {
            _remarkHeight = 55 + 111;
            _isShow = YES;
        }
    }
}

- (void)setCaseList:(NSArray<KNBHomeServiceModel *> *)caseList {
    _caseList = caseList;
    NSInteger count = caseList.count;
    if (count == 0) {
        _caseListHeight = 300;
    } else {
        if (count %2 == 0) {
            _caseListHeight = 220 *count /2 + 84;
        } else {
            _caseListHeight = 220 *(count /2 + 1) + 84;
        }
    }
}

- (void)setDistance:(NSString *)distance {
    _distance = distance;
    if ([distance integerValue] > 1000) {
        _distanceString = [NSString stringWithFormat:@"%ldkm",(long)[distance integerValue] / 1000];
    } else {
        _distanceString = [NSString stringWithFormat:@"%ldm",(long)[distance integerValue]];
    }
    CGFloat width = [_distanceString widthWithFont:KNBFont(12) constrainedToHeight:15];
    
    _maxAddressWidth = KNB_SCREEN_WIDTH - 190 - width;
}

- (void)setName:(NSString *)name {
    _name = name;
    if (name.length > 9) {
        _nameString = [NSString stringWithFormat:@"%@...",[name substringToIndex:9]];
    } else {
        _nameString = name;
    }
}

- (void)setIsEdit:(BOOL)isEdit {
    _isEdit = isEdit;
    if (isEdit) {
        if (!isNullArray(self.caseList)) {
            if (self.caseList.count %2 == 0) {
                _caseListHeight = 220 *(self.caseList.count /2 + 1) + 84;
            }
        }
    }
}

@end
