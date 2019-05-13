//
//  KNBRecruitmentModel.m
//  FishFinishing
//
//  Created by apple on 2019/4/12.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBRecruitmentModel.h"
#import "KNBRecruitmentTypeModel.h"

@implementation KNBRecruitmentModel

- (NSString *)domainId {
    if (!_domainId) {
        NSString *domain = @"";
        for (KNBRecruitmentDomainModel *model in self.domainList) {
            domain = [domain stringByAppendingString:model.typeId];
            domain = [domain stringByAppendingString:@","];
        }
        domain = [domain substringToIndex:[domain length]-1];
        _domainId = domain;
    }
    return _domainId;
}

- (NSString *)serviceId {
    if (!_serviceId) {
        NSString *service = @"";
        for (KNBRecruitmentTypeModel *model in self.serviceList) {
            service = [service stringByAppendingString:model.typeId];
            service = [service stringByAppendingString:@","];
        }
        service = [service substringToIndex:[service length]-1];
        _serviceId = service;
    }
    return _serviceId;
}

@end
