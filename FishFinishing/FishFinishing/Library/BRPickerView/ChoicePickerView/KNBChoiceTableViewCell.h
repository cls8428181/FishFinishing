//
//  KNBChoiceTableViewCell.h
//  FishFinishing
//
//  Created by apple on 2019/4/16.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KNBChoiceTableViewCell : UITableViewCell

/**
 标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**
 加好按钮的回调
 */
@property (nonatomic, copy) void(^addButtonBlock)(void);

/**
 减号按钮的回调
 */
@property (nonatomic, copy) void(^subButtonBlock)(void);

/**
 cell 创建
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView title:(NSString *)title;

/**
 cell 高度
 */
+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
