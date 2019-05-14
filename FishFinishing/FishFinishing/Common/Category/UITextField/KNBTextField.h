//
//  KNBTextField.h
//  KenuoTraining
//
//  Created by 沙漠 on 2018/3/16.
//  Copyright © 2018年 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^KNBTextFieldLeftButtonBlock)(UIButton *sender);
typedef void (^KNBTextFieldRightButtonBlock)(UIButton *sender);


@interface KNBTextField : UITextField

@property (nonatomic, copy) KNBTextFieldLeftButtonBlock leftButtonBlock;

@property (nonatomic, copy) KNBTextFieldRightButtonBlock rightButtonBlock;


/**
 * UITextField 初始化
  * @param text 占位文字
 */

- (instancetype)initWithPlaceholderText:(NSString *)text;

/**
 * UITextField 添加左侧按钮
 * @param imageNameN  图片名字
 */
- (void)addLeftWithImageNameNormal:(NSString *)imageNameN ImageNameSelect:(NSString *)imageNameS;

/**
 * UITextField 添加右侧按钮
 */
- (void)addRightWithImageNameNormal:(NSString *)imageNameN ImageNameSelect:(NSString *)imageNameS;

/**
 * UITextField 添加左侧空白占位
 */
- (void)addLeftPlaceholderView;


@end
