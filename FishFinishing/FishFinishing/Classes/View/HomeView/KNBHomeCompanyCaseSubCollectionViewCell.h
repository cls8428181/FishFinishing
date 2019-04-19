//
//  KNBHomeCompanyCaseSubCollectionViewCell.h
//  FishFinishing
//
//  Created by apple on 2019/4/19.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNBHomeServiceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeCompanyCaseSubCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) KNBHomeServiceModel *model;
@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, copy) void (^deleteButtonBlock)(void);
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

+ (CGFloat)cellHeight;
@end

NS_ASSUME_NONNULL_END
