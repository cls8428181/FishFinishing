//
//  KNBWelcomeViewController.h
//  KenuoTraining
//
//  Created by 沙漠 on 2018/3/30.
//  Copyright © 2018年 Robert. All rights reserved.
//
/**
 * =========引导页===========
 */

#import <UIKit/UIKit.h>

@protocol KNBWelcomeVCDelegate <NSObject>

/**
 展示引导页的回调
 */
- (void)isShowGuidePageViewComplete;

@end


@interface KNBWelcomeViewController : UIViewController

@property (nonatomic, weak) id<KNBWelcomeVCDelegate> delegate;

/**
 * 是否展示过引导页
 */
+ (BOOL)isShowGuideView;

@end
