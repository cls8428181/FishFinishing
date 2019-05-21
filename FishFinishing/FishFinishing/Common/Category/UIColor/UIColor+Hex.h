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

/**
 主色调 0x0096e6
 */
+ (UIColor *)knMainColor;        //主色调
+ (UIColor *)knGrayColor;       //灰色字体

/**
 黑色 0x333333
 */
+ (UIColor *)kn333333Color;

/**
 灰色 0x808080
 */
+ (UIColor *)kn808080Color;

/**
 橘色 0xf5701b
 */
+ (UIColor *)knf5701bColor;

/**
 灰色 0xf2f2f2
 */
+ (UIColor *)knf2f2f2Color;
+ (UIColor *)knCoverBlackColor; // #1a1a1a

@end
