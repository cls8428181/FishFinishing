//
//  KNBMeOrderTableViewCell.h
//  FishFinishing
//
//  Created by apple on 2019/4/24.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNBMeOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBMeOrderTableViewCell : UITableViewCell

@property (nonatomic, strong) KNBMeOrderModel *model;

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
