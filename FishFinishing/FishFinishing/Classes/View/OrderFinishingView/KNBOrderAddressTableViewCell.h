//
//  KNBOrderAddressTableViewCell.h
//  FishFinishing
//
//  Created by 常立山 on 2019/4/8.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KNBOrderAddressTableViewCell : UITableViewCell

/**
 cell 创建
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 cell 高度
 */
+ (CGFloat)cellHeight;

/**
 设置省市区
 */
- (void)setProvinceName:(NSString *)provinceName cityName:(NSString *)cityName areaName:(NSString *)areaName;
@end

NS_ASSUME_NONNULL_END
