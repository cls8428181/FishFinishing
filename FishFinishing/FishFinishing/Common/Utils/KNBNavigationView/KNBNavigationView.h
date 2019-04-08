//
//  KNBNavigationView.h
//  KenuoTraining
//
//  Created by 妖狐小子 on 2017/4/12.
//  Copyright © 2017年 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KNBNavigationView : UIView

/**
 导航title
 */
@property (nonatomic, copy) NSString *title;

/**
 导航左侧边按钮
 */
@property (nonatomic, strong) UIButton *leftNaviButton;

/**
 导航Label
 */
@property (nonatomic, strong) UILabel *titleNaviLabel;


/**
 导航右边按钮
 */
@property (nonatomic, strong) UIButton *rightNaviButton;

/**
 是否是普通导航
 */
@property (nonatomic, assign) BOOL customNav;

/**
 *  添加导航右边按钮
 *
 *  @param imgName 图片
 *  @param sel     sel
 */
- (void)addRightBarItemImageName:(NSString *)imgName;

/**
 *  添加导航右边按钮，绑定事件
 *
 *  @param imgName 图片
 *  @param sel     sel
 */
- (void)addRightBarItemImageName:(NSString *)imgName target:(id)target sel:(SEL)sel;

/**
 *  添加导航左边按钮
 *
 *  @param imgName 图片
 *  @param sel     sel
 */
- (void)addLeftBarItemImageName:(NSString *)imgName;

/**
 *  添加导航按钮
 *
 *  @param title 标题
 *  @param sel   sel
 */
- (void)addRightBarItemTitle:(NSString *)title;

/**
 *  添加导航按钮，绑定事件
 *
 *  @param title 标题
 *  @param sel   sel
 */
- (void)addRightBarItemTitle:(NSString *)title target:(id)target sel:(SEL)sel;


/**
 *  默认自带返回按钮
 *
 *  @param title 返回按钮旁边的按钮
 *  @param sel   按钮事件
 */
- (void)addLeftBarItemTitle:(NSString *)title;

/**
 *  添加导航左侧按钮，绑定事件
 *
 *  @param imgName 图片
 *  @param sel     sel
 */
- (void)addLeftBarItemImageName:(NSString *)imgName target:(id)target sel:(SEL)sel;

/**
 *  移除导航左侧按钮
 *  tabbar的childVC 使用
 *
 */
- (void)removeLeftBarItem;

@end
