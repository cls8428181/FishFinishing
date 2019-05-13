//
//  KNBHomeCompanyCaseTableViewCell.h
//  FishFinishing
//
//  Created by 常立山 on 2019/4/3.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNBHomeServiceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeCompanyCaseTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^addCaseBlock)(void);

@property (nonatomic, strong) KNBHomeServiceModel *model;

/**
 能否编辑
 */
@property (nonatomic, assign) BOOL isEdit;

/**
 cell 创建
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 cell 高度
 */
+ (CGFloat)cellHeight:(NSInteger)count isEdit:(BOOL)isEdit;
@end

NS_ASSUME_NONNULL_END
