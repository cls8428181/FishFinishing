//
//  UIColor+Hex.m
//  KenuoTraining
//
//  Created by Robert on 16/2/22.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "UIColor+Hex.h"


@implementation UIColor (Hex)

+ (UIColor *)colorWithHex:(int)hexValue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hexValue & 0xFF00) >> 8)) / 255.0
                            blue:((float)(hexValue & 0xFF)) / 255.0
                           alpha:alpha];
}

+ (UIColor *)colorWithHex:(int)hexValue {
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)color {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }

    // strip 0X if it appears
    if ([cString hasPrefix:@"0x"] || [cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];

    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;

    //r
    NSString *rString = [cString substringWithRange:range];

    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];

    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];

    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:1.0f];
}

+ (UIColor *)knBlackColor {
    //    return [UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:1.0];
    return [UIColor blackColor];
}

+ (UIColor *)knLightGrayColor {
    return [UIColor colorWithRed:178 / 255.0 green:178 / 255.0 blue:178 / 255.0 alpha:1.0];
}
//0xFF5E84
+ (UIColor *)knYellowColor {
    return [UIColor colorWithRed:235 / 255.0 green:189 / 255.0 blue:48 / 255.0 alpha:1.0];
}

+ (UIColor *)knBgColor {
    return [UIColor colorWithRed:242 / 255.f green:242 / 255.f blue:242 / 255.f alpha:1.0];
}
//0x
+ (UIColor *)knRedColor {
    return [UIColor colorWithRed:255 / 255.0 green:94 / 255.0 blue:132 / 255.0 alpha:1.0];
}

+ (UIColor *)knMainColor {
    return [UIColor colorWithHex:0x0096e6];
}

+ (UIColor *)knf5701bColor {
    return [UIColor colorWithHex:0xf5701b];
}

+ (UIColor *)knf2f2f2Color {
    return [UIColor colorWithHex:0xf2f2f2];
}
//0x666666
+ (UIColor *)knGrayColor {
    return [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1.0];
}

+ (UIColor *)knCoverBlackColor { // #1a1a1a
    return [UIColor colorWithRed:26 / 255.0 green:26 / 255.0 blue:26 / 255.0 alpha:0.7];
}
//0x333333
+ (UIColor *)kn333333Color {
    return [UIColor colorWithHex:0x333333];
}
//0x808080
+ (UIColor *)kn808080Color {
    return [UIColor colorWithHex:0x808080];
}

+ (UIColor *)SmartColorWithHexString:(NSString *)hexValue {
    UIColor *defaultResult = [UIColor whiteColor];
    if ([hexValue hasPrefix:@"#"] && [hexValue length] > 1) {
        hexValue = [hexValue substringFromIndex:1];
    }
    NSUInteger componentLength = 0;
    if ([hexValue length] == 3) {
        componentLength = 1;
    } else if ([hexValue length] == 6) {
        componentLength = 2;
    } else {
        return defaultResult;
    }

    BOOL isValid = YES;
    CGFloat components[3];

    for (NSUInteger i = 0; i < 3; i++) {
        NSString *component = [hexValue substringWithRange:NSMakeRange(componentLength * i, componentLength)];
        if (componentLength == 1) {
            component = [component stringByAppendingString:component];
        }
        NSScanner *scanner = [NSScanner scannerWithString:component];
        unsigned int value;
        isValid &= [scanner scanHexInt:&value];
        components[i] = (CGFloat)value / 255.0f;
    }
    if (!isValid)
        return defaultResult;

    return [UIColor colorWithRed:components[0]
                           green:components[1]
                            blue:components[2]
                           alpha:1.0];
}

@end
