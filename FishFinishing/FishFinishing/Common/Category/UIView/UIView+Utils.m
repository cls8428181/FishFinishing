//
//  UIView+Utils.m
//  KenuoTraining
//
//  Created by 常立山 on 2018/8/6.
//  Copyright © 2018年 Robert. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)
- (UIView*)subViewOfClassName:(NSString*)className {
    for (UIView* subView in self.subviews) {
        if ([NSStringFromClass(subView.class) isEqualToString:className]) {
            return subView;
        }
        
        UIView* resultFound = [subView subViewOfClassName:className];
        if (resultFound) {
            return resultFound;
        }
    }
    return nil;
}

@end
