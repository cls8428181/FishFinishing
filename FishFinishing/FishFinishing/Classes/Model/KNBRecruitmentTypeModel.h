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

/**
 选择的子类型模型
 */
@property (nonatomic, strong) KNBRecruitmentTypeModel *selectSubModel;

/**
 擅长领域标签
 */
@property (nonatomic, copy) NSString *tagName;
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


@interface KNBRecruitmentCostModel : KNBRecruitmentTypeModel
@property (nonatomic, copy) NSString *name;

/**
 费用
 */
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *termType;
@property (nonatomic, copy) NSString *term;
@property (nonatomic, copy) NSString *remark;
@end

@interface KNBRecruitmentUnitModel : KNBRecruitmentTypeModel
@property (nonatomic, copy) NSString *name;
@end
NS_ASSUME_NONNULL_END
