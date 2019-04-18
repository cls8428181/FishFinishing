//
//  KNBHomeCategoryTableViewCell.h
//  FishFinishing
//
//  Created by 常立山 on 2019/3/26.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeCategoryTableViewCell : UITableViewCell

/**
 装修工人的回调
 */
@property (nonatomic, copy) void(^selectItemAtIndexBlock)(NSInteger index);

/**
 cell 创建
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView dataSource:(NSArray *)dataSource;

/**
 cell 高度
 */
+ (CGFloat)cellHeight;

/**
 刷新 collectionview
 */
- (void)reloadCollectionView;

@end

NS_ASSUME_NONNULL_END
