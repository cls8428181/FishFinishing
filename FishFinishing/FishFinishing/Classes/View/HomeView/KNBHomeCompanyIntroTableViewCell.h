//
//  KNBHomeCompanyIntroTableViewCell.h
//  FishFinishing
//
//  Created by 常立山 on 2019/4/3.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNBHomeServiceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeCompanyIntroTableViewCell : UITableViewCell
@property (nonatomic, strong) KNBHomeServiceModel *model;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, copy) void (^openIntroBlock)(void);

/**
 cell 创建
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 cell 高度
 */
+ (CGFloat)cellHeight:(KNBHomeServiceModel *)model;
@end

NS_ASSUME_NONNULL_END
