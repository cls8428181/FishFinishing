//
//  KNBSearchView.h
//  KenuoTraining
//
//  Created by 常立山 on 2018/7/18.
//  Copyright © 2018年 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNBSearchBar.h"
@class KNBSearchView;

typedef NS_ENUM(NSInteger, KNBSearchViewStyle) {
    KNBSearchViewStyleDefault,
    KNBSearchViewStyleWhite
};

typedef void (^KNBSearchViewBlock)(void);

@protocol KNBSearchViewDelegate <NSObject>

- (void)searchView:(KNBSearchView *)searchView startSearchWithSearchText:(NSString *)searchText;

@optional
//开始编辑时回调
- (void)searchViewSearchBarBeginEditing;
//搜索内容改变
- (void)searchViewSearchBarTextDidChange:(NSString *)searchText;

@end


@interface KNBSearchView : UIView

@property (nonatomic, strong) KNBSearchBar *searchBar;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, weak) id<KNBSearchViewDelegate> delegate;

@property (nonatomic, assign) KNBSearchViewStyle style;

@property (nonatomic, copy) KNBSearchViewBlock backBlock;

/**
 创建搜索视图

 @param isNavView 是否是NavigationView
 @param isHaveBack 是否有返回按钮
 @param isHaveCancle 是否有取消按钮
 @param style 搜索视图的主题
 */
- (instancetype)initWithFrame:(CGRect)frame isNavView:(BOOL)isNavView isHaveBackButton:(BOOL)isHaveBack isHaveCancleButton:(BOOL)isHaveCancle style:(KNBSearchViewStyle)style;

@end
