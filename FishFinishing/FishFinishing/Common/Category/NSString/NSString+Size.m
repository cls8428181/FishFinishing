//
//  NSString+Size.m
//  KenuoTraining
//
//  Created by Robert on 16/2/22.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "NSString+Size.h"


@implementation NSString (Size)

- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width {
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];

    CGSize textSize;

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName : textFont,
                                     NSParagraphStyleAttributeName : paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                                   attributes:attributes
                                      context:nil]
                       .size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName : textFont,
                                 NSParagraphStyleAttributeName : paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(floor(width), CGFLOAT_MAX)
                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading
                               attributes:attributes
                                  context:nil]
                   .size;
#endif

    return ceil(textSize.height);
}

- (CGFloat)heightWithFont:(UIFont *)font
       constrainedToWidth:(CGFloat)width
           paragraphStyle:(NSParagraphStyle *)paragraphyStyle {
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    NSDictionary *attributes = @{NSFontAttributeName : textFont,
                                 NSParagraphStyleAttributeName : paragraphyStyle};
    CGSize textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading
                                      attributes:attributes
                                         context:nil]
                          .size;
    return ceil(textSize.height);
}


- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width andLineSpace:(CGFloat)lineSpace {
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];

    CGSize textSize;

    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineSpacing:lineSpace];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attributes = @{NSFontAttributeName : textFont,
                                 NSParagraphStyleAttributeName : paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading
                               attributes:attributes
                                  context:nil]
                   .size;
    return ceil(textSize.height);
}

- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width andLineSpace:(CGFloat)lineSpace wordSpace:(CGFloat)wordSpace {
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];

    CGSize textSize;

    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineSpacing:lineSpace];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attributes = @{ NSFontAttributeName : textFont,
                                  NSParagraphStyleAttributeName : paragraph,
                                  NSKernAttributeName : @(wordSpace) };
    textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading
                               attributes:attributes
                                  context:nil]
                   .size;
    return ceil(textSize.height);
}

- (CGFloat)widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height {
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];

    CGSize textSize;

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName : textFont,
                                     NSParagraphStyleAttributeName : paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                                   attributes:attributes
                                      context:nil]
                       .size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(CGFLOAT_MAX, height)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName : textFont,
                                 NSParagraphStyleAttributeName : paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                               attributes:attributes
                                  context:nil]
                   .size;
#endif

    return ceil(textSize.width);
}

- (NSMutableAttributedString *)priceStringWithMoneySignsFont:(CGFloat)signFont intFont:(CGFloat)intFont floatFont:(CGFloat)floatFont {
    NSArray *prices = [self componentsSeparatedByString:@"."];
    NSString *intPrice = prices[0];
    NSString *floatPrice = prices[1];
    NSMutableAttributedString *attrPrice = [[NSMutableAttributedString alloc] initWithString:self];
    [attrPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:intFont] range:NSMakeRange(0, intPrice.length)];
    [attrPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:floatFont] range:NSMakeRange(intPrice.length, floatPrice.length + 1)];
    if ([self containsString:@"￥"]) {
        [attrPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:signFont] range:[self rangeOfString:@"￥"]];
        if ([self containsString:@"商品应付"]) {
            [attrPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:signFont] range:NSMakeRange(0, 4)];
        }
        if ([self containsString:@"欠款"]) {
            [attrPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:signFont] range:NSMakeRange(0, 2)];
        }
    }
    if ([self containsString:@"¥"]) {
        [attrPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:signFont] range:[self rangeOfString:@"¥"]];
        if ([self containsString:@"商品应付"]) {
            [attrPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:signFont] range:NSMakeRange(0, 4)];
        }
        if ([self containsString:@"欠款"]) {
            [attrPrice addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:signFont] range:NSMakeRange(0, 2)];
        }
    }
    return attrPrice;
}

+ (CGFloat)heightOfString:(NSString *)string width:(CGFloat)width withFont:(UIFont *)font {
    CGFloat height = 0;
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];

    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];

    NSArray *stringArray = [string componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];

    for (NSString *string in stringArray) {
        if (string.length > 0) {
            NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
            paragraph.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName : textFont,
                                         NSParagraphStyleAttributeName : paragraph};
            CGRect bounds = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];

            height += bounds.size.height;
        }
    }

    return height;
}

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
    
}

@end
