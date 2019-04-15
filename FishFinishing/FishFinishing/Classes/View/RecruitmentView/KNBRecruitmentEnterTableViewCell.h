//
//  KNBRecruitmentEnterTableViewCell.h
//  FishFinishing
//
//  Created by apple on 2019/4/15.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KNBRecruitmentEnterTableViewCell : UITableViewCell
/**
 选择按钮的回调
 */
@property (nonatomic, copy) void(^selectButtonBlock)(UIButton *button);

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
