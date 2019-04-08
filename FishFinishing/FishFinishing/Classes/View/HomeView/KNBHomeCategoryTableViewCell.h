//
//  KNBHomeCategoryTableViewCell.h
//  FishFinishing
//
//  Created by 常立山 on 2019/3/26.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeCategoryTableViewCell : UITableViewCell

/**
 量房报价的回调
 */
@property (nonatomic, copy) void(^offerButtonAction)(void);

/**
 装修公司的回调
 */
@property (nonatomic, copy) void(^companyButtonAction)(void);

/**
 找工长的回调
 */
@property (nonatomic, copy) void(^foremanButtonAction)(void);

/**
 找设计的回调
 */
@property (nonatomic, copy) void(^designButtonAction)(void);

/**
 家居建材的回调
 */
@property (nonatomic, copy) void(^materialButtonAction)(void);

/**
 装修工人的回调
 */
@property (nonatomic, copy) void(^workerButtonAction)(void);

/**
 cell 创建
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 cell 高度
 */
+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
