//
//  UIButton+CountDown.h
//  KenuoTraining
//
//  Created by Robert on 16/2/22.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIButton (CountDown)

/**
 *  倒计时
 *
 *  @param timeout    计时总时间
 *  @param tittle     计时未开始title
 *  @param waitTittle 计时中title
 */
- (void)startTime:(NSInteger)timeout title:(NSString *)tittle waitTittle:(NSString *)waitTittle;

@end
