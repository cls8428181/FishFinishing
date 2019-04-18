//
//  KNBSearchView.h
//  FishFinishing
//
//  Created by 常立山 on 2019/3/26.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^KNBSearchViewTouchBlock)(void);

// 搜索视图高度 44
extern CGFloat KNBSearchViewHeight;

NS_ASSUME_NONNULL_BEGIN

@interface KNBSearchView : UIView
@property (nonatomic, copy) void (^chatButtonBlock)(void);
/**
 左边城市选择按钮
 */
@property (nonatomic, strong) UIButton *chooseCityButton;
@property (nonatomic, strong) UIView *searchBgView;
@property (nonatomic, copy) KNBSearchViewTouchBlock touchBlock;
@end

NS_ASSUME_NONNULL_END
