//
//  KNBHomeSearchView.h
//  FishFinishing
//
//  Created by 常立山 on 2019/3/26.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^KNBHomeSearchViewTouchBlock)(void);

// 搜索视图高度 44
extern CGFloat KNBHomeSearchViewHeight;

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeSearchView : UIView
@property (nonatomic, copy) void (^chatButtonBlock)(void);
/**
 左边城市选择按钮
 */
@property (nonatomic, strong) UIButton *chooseCityButton;
@property (nonatomic, strong) UIView *searchBgView;
@property (nonatomic, copy) KNBHomeSearchViewTouchBlock touchBlock;
@end

NS_ASSUME_NONNULL_END
