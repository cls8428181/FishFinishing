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

/**
 服务商 id
 */
@property (nonatomic, copy) NSString *facilitator_id;

/**
 案例 id
 */
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
 案例头像
 */
@property (nonatomic, copy) NSString *img;

/**
 服务商头像
 */
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *browse_num;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *price;

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
@property (nonatomic, copy) NSString *apart_name;

/**
 描述
 */
@property (nonatomic, copy) NSString *remark;

/**
 类型
 */
@property (nonatomic, copy) NSString *parent_cat_name;

/**
 类型id
 */
@property (nonatomic, copy) NSString *cat_parent_id;

/**
 子类型
 */
@property (nonatomic, copy) NSString *cat_name;

/**
 子类型id
 */
@property (nonatomic, copy) NSString *cat_id;

/**
 电话
 */
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, strong) NSArray<KNBDesignSketchModel *> *imgs;

/**
 图片的尺寸
 */
@property (nonatomic, assign) CGSize imgSize;

/**
 cell 高度
 */
@property (nonatomic, assign) CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
