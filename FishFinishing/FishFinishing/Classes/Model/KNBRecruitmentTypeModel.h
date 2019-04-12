//
//  KNBRecruitmentTypeModel.h
//  FishFinishing
//
//  Created by apple on 2019/4/12.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBRecruitmentTypeModel : KNBBaseModel
@property (nonatomic, copy) NSString *typeId;

/**
 类型名称
 */
@property (nonatomic, copy) NSString *catName;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *enable;
@property (nonatomic, copy) NSString *creater;
@property (nonatomic, copy) NSString *createdAt;
@property (nonatomic, copy) NSString *updater;
@property (nonatomic, copy) NSString *updatedAt;
@property (nonatomic, strong) NSArray<KNBRecruitmentTypeModel *> *childList;

/**
 服务名称
 */
@property (nonatomic, copy) NSString *serviceName;
@end

NS_ASSUME_NONNULL_END
