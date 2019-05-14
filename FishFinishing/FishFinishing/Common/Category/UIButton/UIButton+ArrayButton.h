//
//  UIButton+ArrayButton.h
//  RYSearch
//
//  Created by Robert on 15/4/24.
//  Copyright (c) 2015年 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIButton (ArrayButton)

/**
 *  批量生成Button
 *
 *  @param array NSString类型的数组
 *  @param gap   Button之间的间距
 *
 *  @return Button数组
 */
+ (NSArray *)ButtonWithArray:(NSArray *)array Gap:(NSUInteger)gap;

/**
 *  批量生成button
 *
 *  @param array NSString类型的数组
 *  @param gap   Button之间的间距
 *  @param tag   tag 起始值
 *
 *  @return Button数组
 */
+ (NSArray *)ButtonWithArray:(NSArray *)array Gap:(NSUInteger)gap tag:(NSInteger)tag;

/**
 通过标题生成
 
 @param titlesArray 标题数组
 */
+ (NSArray *)buttonTitlesArray:(NSArray<NSString *> *)titlesArray
                           gap:(NSUInteger)gap
                           tag:(NSInteger)tag
                        height:(NSInteger *)height;


@end
