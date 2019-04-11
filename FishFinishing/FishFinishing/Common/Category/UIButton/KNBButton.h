//
//  KNBButton.h
//  KNMedicalBeauty
//
//  Created by ADC on 2017/12/25.
//  Copyright © 2017年 idengyun. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KNBButton : UIButton

/**
 用于统计事件名字赋值
 */
@property (nonatomic, copy) NSString *touchEvent;

/**
 标识
 */
@property (nonatomic, copy) NSString *buttonTag;
/**
 *  设置点击时间间隔
 */
@property (nonatomic, assign) NSTimeInterval timeInterVal;

/**
 相应范围
 */
@property (nonatomic,assign) UIEdgeInsets hitTestEdgeInsets;
/**
 设置图上文字下间距

 @param spacing 间距
 */
- (void)verticalImageAndTitle:(CGFloat)spacing;

- (void)verticalImageAndTitle:(CGFloat)spacing width:(NSInteger)width height:(NSInteger)height;

@end
