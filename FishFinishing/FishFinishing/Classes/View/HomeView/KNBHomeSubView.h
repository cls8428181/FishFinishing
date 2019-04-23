//
//  KNBHomeSubView.h
//  FishFinishing
//
//  Created by apple on 2019/4/18.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeSubView : UIView<UIScrollViewDelegate>

typedef void (^contentViewScrollEvent)(NSInteger);

@property (strong ,nonatomic) UIScrollView *contentView;

@property (nonatomic, strong) contentViewScrollEvent scrollEventBlock;  // 回调点击事件

- (instancetype)initWithFrame:(CGRect)frame index:(NSInteger)index dataSource:(NSArray *)dataSrouce;

- (void)reloadTableViewAtIndex:(NSInteger)index dataSource:(NSArray *)dataSource title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
