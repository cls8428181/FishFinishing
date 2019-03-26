//
//  UIButton+EnlargeArea.h
//  KenuoTraining
//
//  Created by 陈安伟 on 17/8/7.
//  Copyright © 2017年 Robert. All rights reserved.
//

//改变按钮点击区域

#import <UIKit/UIKit.h>


@interface UIButton (EnlargeArea)

- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

@end
