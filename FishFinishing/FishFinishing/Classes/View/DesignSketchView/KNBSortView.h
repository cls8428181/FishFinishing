//
//  KNBeautySortView.h
//  Concubine
//
//  Created by 陈安伟 on 17/6/9.
//  Copyright © 2017年 dengyun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KNBDesignSketchCollectionSectionView;

typedef void (^KNBeautySort)(NSInteger sortTag);

@interface KNBSortView : UIView

/**
 弹框高度
 */
@property (nonatomic, assign) CGFloat sortViewHeight;

/**
 选择之后的回调
 */
@property (nonatomic, copy) KNBeautySort sortClicked;

/**
 创建弹框

 @param sortArr 文字列表
 @param superView 父视图
 @param optionView 定位用
 */
- (instancetype)initWithFrame:(CGRect)frame sortArr:(NSArray *)sortArr superView:(UIView *)superView optionView:(KNBDesignSketchCollectionSectionView *)optionView;

/**
 展示弹框
 */
- (void)showSortViewWithSortTag:(NSInteger)sortTag;

@end
