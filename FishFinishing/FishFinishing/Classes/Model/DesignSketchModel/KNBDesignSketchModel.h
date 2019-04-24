//
//  KNBDesignSketchModel.h
//  FishFinishing
//
//  Created by 常立山 on 2019/4/18.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBDesignSketchModel : KNBBaseModel
@property (nonatomic, copy) NSString *caseId;

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

/**
 服务商名称
 */
@property (nonatomic, copy) NSString *name;

/**
 服务商头像
 */
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *browse_num;
@property (nonatomic, copy) NSString *created_at;

/**
 类型
 */
@property (nonatomic, copy) NSString *style_name;

/**
 面积
 */
@property (nonatomic, copy) NSString *acreage;

/**
 户型
 */
@property (nonatomic, copy) NSString *apart;

/**
 描述
 */
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, strong) NSArray<KNBDesignSketchModel *> *imgs;
@end

NS_ASSUME_NONNULL_END
