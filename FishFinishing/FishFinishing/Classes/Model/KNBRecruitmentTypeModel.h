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
 附近装修推荐类型名称
 */
@property (nonatomic, copy) NSString *sub_name;

/**
 选择的子类型模型
 */
@property (nonatomic, strong) KNBRecruitmentTypeModel *selectSubModel;
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

#pragma mark - 装修费用
@interface KNBRecruitmentCostModel : KNBRecruitmentTypeModel
@property (nonatomic, copy) NSString *costId;
@property (nonatomic, copy) NSString *name;

/**
 推荐
 */
@property (nonatomic, copy) NSString *isRecommend;

/**
 是否选择
 */
@property (nonatomic, assign) BOOL isSelected;

/**
 费用
 */
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *termType;
@property (nonatomic, copy) NSString *term;
@property (nonatomic, copy) NSString *remark;
@end

#pragma mark - 装修户型
@interface KNBRecruitmentUnitModel : KNBRecruitmentTypeModel
@property (nonatomic, copy) NSString *houseId;
@property (nonatomic, copy) NSString *name;
@end

#pragma mark - 擅长领域
@interface KNBRecruitmentDomainModel : KNBRecruitmentTypeModel
/**
 擅长领域标签
 */
@property (nonatomic, copy) NSString *tagName;
@end

NS_ASSUME_NONNULL_END
