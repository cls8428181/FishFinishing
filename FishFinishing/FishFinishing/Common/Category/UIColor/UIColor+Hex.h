//
//  UIColor+Hex.h
//  KenuoTraining
//
//  Created by Robert on 16/2/22.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIColor (Hex)

/**
 *  十六进制色值转换为UIColor（alpha）
 *
 *  @param hexValue 十六进制色值
 *  @param alpha    透明度
 *
 *  @return UIColor对象
 */
+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha;

/**
 *  十六进制色值转换为UIColor
 *
 *  @param hexValue 十六进制色值
 *
 *  @return UIColor对象
 */
+ (UIColor *)colorWithHex:(int)hexValue;
/**
 * 颜色转换 IOS中十六进制的颜色转换为UIColor
 *
 */
+ (UIColor *)colorWithHexString:(NSString *)color;
/**
 *  十六进制色值转换为UIColor
 *
 *  @param hexValue 十六进制色值
 *
 *  @return UIColor对象
 */
+ (UIColor *)SmartColorWithHexString:(NSString *)hexValue;
+ (UIColor *)knBlackColor;
+ (UIColor *)knLightGrayColor; // 分割线颜色
+ (UIColor *)knYellowColor;
+ (UIColor *)knBgColor;         // 灰色背景颜色
+ (UIColor *)knRedColor;
+ (UIColor *)knMainColor;        //大鱼装修主色调
+ (UIColor *)knGrayColor;       //灰色字体
+ (UIColor *)knWordsColor;      //999999灰色的字
+ (UIColor *)knCoverBlackColor; // #1a1a1a

@end
