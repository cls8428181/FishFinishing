//
//  UIButton+ImageAndTitle.m
//  KenuoTraining
//
//  Created by Robert on 2017/6/29.
//  Copyright © 2017年 Robert. All rights reserved.
//

#import "UIButton+ImageAndTitle.h"

@implementation UIButton (ImageAndTitle)

- (void)centerImageAndTitle:(float)space {
    CGFloat imageWidth = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    
    CGFloat titleWidth = self.titleLabel.intrinsicContentSize.width;
    CGFloat titleHeight = self.titleLabel.intrinsicContentSize.height;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(-titleHeight-space/2.0, 0, -10, -titleWidth);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, -imageHeight-space/2.0-10, 0);
}

- (void)centerImageAndTitle {
    [self centerImageAndTitle:0.0f];
}

@end
