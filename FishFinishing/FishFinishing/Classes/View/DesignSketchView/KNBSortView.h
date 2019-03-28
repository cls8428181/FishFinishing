//
//  KNBeautySortView.h
//  Concubine
//
//  Created by 陈安伟 on 17/6/9.
//  Copyright © 2017年 dengyun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^KNBeautySort)(NSInteger sortTag);

@class KNBDesignSketchCollectionSectionView;


@interface KNBSortView : UIView

@property (nonatomic, assign) CGFloat sortViewHeight;
@property (nonatomic, copy) KNBeautySort sortClicked;
@property (nonatomic, assign) BOOL isMerchant;


- (instancetype)initWithFrame:(CGRect)frame sortArr:(NSArray *)sortArr superView:(UIView *)superView optionView:(KNBDesignSketchCollectionSectionView *)optionView;

- (void)showSortViewWithSortTag:(NSInteger)sortTag;

- (void)showMerchantViewWithMerchantTag:(NSInteger)merchantTag;

@end
