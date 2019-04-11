//
//  KNBButton.m
//  KNMedicalBeauty
//
//  Created by ADC on 2017/12/25.
//  Copyright © 2017年 idengyun. All rights reserved.
//

#import "KNBButton.h"
#import <objc/runtime.h>
// 间隔时间
#define ClickInterval .7


@implementation KNBButton

- (void)verticalImageAndTitle:(CGFloat)spacing width:(NSInteger)width height:(NSInteger)height {
    CGSize imageSize = CGSizeMake(width, height);
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{ @"NSFontAttributeName" : self.titleLabel.font }];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight - imageSize.height), 0.0, 0.0, -titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -(totalHeight - titleSize.height), 0);
}

- (void)verticalImageAndTitle:(CGFloat)spacing {
    CGSize imageSize = CGSizeMake(50, 50);
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{ @"NSFontAttributeName" : self.titleLabel.font }];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight - imageSize.height), 0.0, 0.0, -titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -(totalHeight - titleSize.height), 0);
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL oldSel = @selector(sendAction:to:forEvent:);
        SEL newSel = @selector(newSendAction:to:forEvent:);

        Method oldMethod = class_getInstanceMethod(self, oldSel);
        Method newMethod = class_getInstanceMethod(self, newSel);

        BOOL isHave = class_addMethod(self, oldSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
        if (isHave) {
            class_replaceMethod(self, newSel, method_getImplementation(oldMethod), method_getTypeEncoding(oldMethod));
        } else {
            method_exchangeImplementations(oldMethod, newMethod);
        }
    });
}

- (void)newSendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if ([NSStringFromClass(self.class) isEqualToString:@"KNBButton"]) {
        if (self.isExcuteEvent == 0) {
            self.timeInterVal = self.timeInterVal = 0 ? ClickInterval : self.timeInterVal;
        }
        if (self.isExcuteEvent) return;
        if (self.timeInterVal > 0) {
            self.isExcuteEvent = YES;
            [self performSelector:@selector(setIsExcuteEvent:) withObject:nil afterDelay:self.timeInterVal];
        }
    }
    [self newSendAction:action to:target forEvent:event];
}

- (NSTimeInterval)timeInterVal {
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setTimeInterVal:(NSTimeInterval)timeInterVal {
    objc_setAssociatedObject(self, @selector(timeInterVal), @(timeInterVal), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setIsExcuteEvent:(BOOL)isExcuteEvent {
    objc_setAssociatedObject(self, @selector(isExcuteEvent), @(isExcuteEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isExcuteEvent {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (NSString *)touchEvent {
    if (_touchEvent == nil || _touchEvent.length == 0) {
        NSLog(@"点击事件未赋值");
        return @"";
    }
    return _touchEvent;
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event{
    if(UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero) ||       !self.enabled || self.hidden) {
        return [super pointInside:point withEvent:event];
    }

    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitTestEdgeInsets);
    
    return CGRectContainsPoint(hitFrame, point);
    
}

@end
