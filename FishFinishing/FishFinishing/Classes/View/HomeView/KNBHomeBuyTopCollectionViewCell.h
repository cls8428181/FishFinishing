//
//  KNBHomeBuyTopCollectionViewCell.h
//  FishFinishing
//
//  Created by apple on 2019/4/25.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNBRecruitmentTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeBuyTopCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) KNBRecruitmentCostModel *model;
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
