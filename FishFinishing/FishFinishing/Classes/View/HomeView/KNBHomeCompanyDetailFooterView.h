//
//  KNBHomeCompanyDetailFooterView.h
//  FishFinishing
//
//  Created by apple on 2019/5/20.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNBHomeServiceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeCompanyDetailFooterView : UIView

@property (nonatomic, copy) void (^addCaseBlock)(void);
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) KNBHomeServiceModel *model;

/**
 能否编辑
 */
@property (nonatomic, assign) BOOL isEdit;
@end

NS_ASSUME_NONNULL_END
