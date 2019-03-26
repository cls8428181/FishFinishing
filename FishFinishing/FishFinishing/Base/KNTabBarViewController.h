//
//  KNTabBarViewController.h
//  Concubine
//
//  Created by ... on 16/5/31.
//  Copyright © 2016年 dengyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "OrderFinishingViewController.h"
#import "DesignSketchViewController.h"
#import "RecruitmentViewController.h"
#import "MeViewController.h"

typedef void (^KNTabBarViewCurrentSelectIndexBlock)(NSInteger index);


@interface KNTabBarViewController : UITabBarController

//底部工具条
@property (nonatomic, strong) UIView *tabBarView;
//首页
@property (nonatomic, strong) HomeViewController *homeVC;
//效果图
@property (nonatomic, strong) DesignSketchViewController *designSketchVC;
//预约装修
@property (nonatomic, strong) OrderFinishingViewController *orderFinishingVC;
//商家入驻
@property (nonatomic, strong) RecruitmentViewController *recruitmentVC;
//我的
@property (nonatomic, strong) MeViewController *meVC;

@property (nonatomic, copy) KNTabBarViewCurrentSelectIndexBlock selectBlock;

@property (nonatomic, assign) NSInteger lastSelectIndex;

- (void)turnToControllerIndex:(NSInteger)index;

/**
 *  显示未读角标
 */
- (void)showUnread;

/**
 * 刷新数据
 */
- (void)reloadData;

@end
