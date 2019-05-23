//
//  KNBHomeDesignSketchTableViewCell.h
//  FishFinishing
//
//  Created by 常立山 on 2019/3/26.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeDesignSketchTableViewCell : UITableViewCell
@property (nonatomic, copy) void (^selectIndexBlock)(NSInteger index);
//滑动区域
@property (nonatomic, strong) UICollectionView *collectionView;
//头部滑动视图
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *modelArray;

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
