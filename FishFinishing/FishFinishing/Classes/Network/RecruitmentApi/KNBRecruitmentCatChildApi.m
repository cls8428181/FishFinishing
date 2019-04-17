//
//  KNBRecruitmentCatChildApi.m
//  FishFinishing
//
//  Created by apple on 2019/4/17.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBRecruitmentCatChildApi.h"

@implementation KNBRecruitmentCatChildApi {
    NSInteger _parent_cat_id;
}
- (instancetype)initWithParentCatId:(NSInteger)catId {
    if (self = [super init]) {
        _parent_cat_id = catId;
    }
    return self;
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBRecruitment_GetCatChild];
}

- (id)requestArgument {
    NSDictionary *dic = @{
                          @"parent_cat_id" : @(_parent_cat_id)
                          }; //字典
    [self.baseMuDic addEntriesFromDictionary:dic];
    return self.appendSecretDic;
}
@end
