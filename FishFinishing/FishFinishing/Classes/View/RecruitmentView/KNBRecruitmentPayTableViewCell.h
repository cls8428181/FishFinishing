//
//  KNBRecruitmentPayTableViewCell.h
//  FishFinishing
//
//  Created by 常立山 on 2019/4/9.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KNBRecruitmentPayTableViewCell : UITableViewCell

/**
 选择按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

/**
 选择按钮的回调
 */
@property (nonatomic, copy) void(^selectButtonBlock)(UIButton *button);

/**
 cell 创建
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView payType:(NSString *)type;

/**
 cell 高度
 */
+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
