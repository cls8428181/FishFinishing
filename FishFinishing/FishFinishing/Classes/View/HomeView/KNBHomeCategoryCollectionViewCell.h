//
//  KNBHomeCategoryCollectionViewCell.h
//  FishFinishing
//
//  Created by apple on 2019/4/18.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNBRecruitmentTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeCategoryCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) KNBRecruitmentTypeModel *model;
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
