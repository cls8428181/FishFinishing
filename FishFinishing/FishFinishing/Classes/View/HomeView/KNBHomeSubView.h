//
//  KNBHomeSubView.h
//  FishFinishing
//
//  Created by apple on 2019/4/18.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNBHomeSubTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeSubView : UIView<UIScrollViewDelegate>

typedef void (^contentViewScrollEvent)(NSInteger);

@property (nonatomic, strong) KNBHomeSubTableView *tableView;

@property (strong ,nonatomic) UIScrollView *contentView;

@property (nonatomic, strong) contentViewScrollEvent scrollEventBlock;  // 回调点击事件

- (instancetype)initWithFrame:(CGRect)frame index:(NSInteger)index dataSource:(NSArray *)dataSrouce;

- (void)reloadTableViewAtIndex:(NSInteger)index dataSource:(NSArray *)dataSource title:(NSString *)title page:(NSInteger)page;

@end

NS_ASSUME_NONNULL_END
