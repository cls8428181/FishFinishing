//
//  KNBMeTableViewCell.h
//  FishFinishing
//
//  Created by 常立山 on 2019/3/29.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KNBMeTableViewCell : UITableViewCell

/**
 标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**
 图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

/**
 标签
 */
@property (weak, nonatomic) IBOutlet UIImageView *markImageView;

/**
 描述
 */
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

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
