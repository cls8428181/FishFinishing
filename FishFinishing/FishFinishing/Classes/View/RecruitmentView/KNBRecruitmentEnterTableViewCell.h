//
//  KNBRecruitmentEnterTableViewCell.h
//  FishFinishing
//
//  Created by apple on 2019/4/15.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, KNBRecruitmentEnterType) {
    KNBRecruitmentEnterTypeOrder = 0,       //免费预约
    KNBRecruitmentEnterTypeRecruitment,   //商家入驻
};

NS_ASSUME_NONNULL_BEGIN

@interface KNBRecruitmentEnterTableViewCell : UITableViewCell

/**
 按钮类型
 */
@property (nonatomic, assign) KNBRecruitmentEnterType type;

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
