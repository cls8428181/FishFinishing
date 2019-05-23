//
//  KNBHomeCompanyServerCollectionViewCell.h
//  FishFinishing
//
//  Created by apple on 2019/5/16.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNBHomeServiceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeCompanyServerCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) KNBHomeServiceModel *model;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
