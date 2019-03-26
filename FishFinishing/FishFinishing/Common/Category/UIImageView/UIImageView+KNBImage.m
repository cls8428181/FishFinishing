//
//  UIImageView+KNBImage.m
//  KenuoTraining
//
//  Created by 王明亮 on 2017/10/12.
//  Copyright © 2017年 Robert. All rights reserved.
//

#import "UIImageView+KNBImage.h"


@implementation UIImageView (KNBImage)

+ (UIImage *)imageWithLineWithImageView:(UIImageView *)imageView {
    CGFloat width = imageView.frame.size.width;
    CGFloat height = imageView.frame.size.height;
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.image drawInRect:CGRectMake(0, 0, width, height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGFloat lengths[] = {6, 3};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, [UIColor colorWithHex:0xe5e5e5].CGColor);
    CGContextSetLineDash(line, 0, lengths, 1);
    CGContextMoveToPoint(line, 0, 1);
    CGContextAddLineToPoint(line, width, 1);
    CGContextStrokePath(line);
    return UIGraphicsGetImageFromCurrentImageContext();
}

@end
