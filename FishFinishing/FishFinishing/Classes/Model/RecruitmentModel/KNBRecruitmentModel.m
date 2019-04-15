//
//  KNBRecruitmentModel.m
//  FishFinishing
//
//  Created by apple on 2019/4/12.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBRecruitmentModel.h"

@implementation KNBRecruitmentModel
- (void)setTypeModel:(KNBRecruitmentTypeModel *)typeModel {
    _typeModel = typeModel;
    _typeModel.typeId = typeModel.typeId;
    _typeModel.catName = typeModel.catName;
    _typeModel.selectSubModel = typeModel.selectSubModel;
    _typeModel.pid = typeModel.pid;
    _typeModel.img = typeModel.img;
    _typeModel.sort = typeModel.sort;
    _typeModel.enable = typeModel.enable;
    _typeModel.creater = typeModel.creater;
    _typeModel.createdAt = typeModel.createdAt;
    _typeModel.updater = typeModel.updater;
    _typeModel.updatedAt = typeModel.updatedAt;
    _typeModel.childList = typeModel.childList;
    _typeModel.serviceName = typeModel.serviceName;
}
@end
