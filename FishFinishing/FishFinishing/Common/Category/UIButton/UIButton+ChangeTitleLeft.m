//
//  UIButton+ChangeTitleLeft.m
//  custom
//
//  Created by . on 2017/9/25.
//  Copyright © 2017年 1. All rights reserved.
//

#import "UIButton+ChangeTitleLeft.h"


@implementation UIButton (ChangeTitleLeft)

- (void)changeTitleLeft {
    CGFloat imgWidth = self.imageView.image.size.width;
    CGFloat titleWidth = self.titleLabel.size.width;
    // button 设置图片的和标题的边距
    self.imageEdgeInsets = UIEdgeInsetsMake(0, titleWidth + 10, 0, -titleWidth);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imgWidth, 0, imgWidth);
}

@end
