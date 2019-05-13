//
//  KNBRecruitmentProtocolTableViewCell.h
//  FishFinishing
//
//  Created by 常立山 on 2019/4/9.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KNBRecruitmentProtocolTableViewCell : UITableViewCell

/**
 选择按钮的回调
 */
@property (nonatomic, copy) void(^selectButtonBlock)(UIButton *button);
/**
 查看协议的回调
 */
@property (nonatomic, copy) void(^protocolButtonBlock)(void);
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
