//
//  KNBAlertRemind.h
//  KenuoTraining
//
//  Created by 妖狐小子 on 2017/2/17.
//  Copyright © 2017年 Robert. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KNBAlertRemind : NSObject

+ (instancetype)sharedInstance;

/**
 添加alert提醒

 @param controller 控制器
 @param title 提醒标题
 @param message 提醒信息
 @param cancleBtnTitle 取消按钮title
 @param otherButtonTitles 按钮title数组
 @param handler 点击按钮方法回调
 */
- (void)addAlertRemindWithController:(UIViewController *)controller
                               title:(NSString *)title
                             message:(NSString *)message
                   cancelButtonTitle:(NSString *)cancleBtnTitle
                   otherButtonTitles:(NSArray *)otherButtonTitles
                clickedButtonAtIndex:(void (^)(NSInteger buttonIndex))handler;

/**
 添加AlertLogError

 @param controller 控制器
 @param message 提示信息
 */
- (void)showAlertLogErrorController:(UIViewController *)controller message:(NSString *)message;


/**
 添加alter控制器

 @param title 标题
 @param message 内容
 @param buttonTitles 按钮标题
 @param handler 回调
 */
+ (void)alterWithTitle:(NSString *)title
               message:(NSString *)message
          buttonTitles:(NSArray *)buttonTitles
               handler:(void (^)(NSInteger index, NSString *title))handler;

/**
 获取当前控制器

 @return 当前控制器
 */
+ (UIViewController *)currentViewController;

@end
