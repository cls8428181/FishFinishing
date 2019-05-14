//
//  KNBDSFreeOrderNewHouseTableViewCell.h
//  FishFinishing
//
//  Created by 常立山 on 2019/4/1.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KNBDSFreeOrderNewHouseTableViewCell : UITableViewCell

/**
 是不是新房
 */
@property (nonatomic, assign) NSString *isNewHouse;

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
