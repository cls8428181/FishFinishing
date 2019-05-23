//
//  KNBHomeDesignSketchSubTableViewCell.h
//  FishFinishing
//
//  Created by 常立山 on 2019/4/1.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNBHomeServiceModel.h"
#import "KNBHomeRecommendCaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeDesignSketchSubTableViewCell : UICollectionViewCell
@property (nonatomic, strong) KNBHomeRecommendCaseModel *model;
/**
 cell 创建
 */
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

/**
 cell 高度
 */
+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
