//
//  KNBLoginInputView.h
//  FishFinishing
//
//  Created by 常立山 on 2019/3/27.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KNBLoginInputViewType) {
    KNBLoginInputViewTypeMobileAndIcon = 0, //手机号并展示icon
    KNBLoginInputViewTypeMobileAndText,     //手机号并展示 文字
    KNBLoginInputViewTypeVerify,     //验证码
    KNBLoginInputViewTypePassword,   //密码
    KNBLoginInputViewTypeSetPassword,   //设置密码
    KNBLoginInputViewTypeNewPassword,   //新的密码
    KNBLoginInputViewTypeEnterPassword //确认密码
};

typedef void (^GetVerifyCodeBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface KNBLoginInputView : UIView
/**
 输入框
 */
@property (nonatomic, strong) UITextField *textField;
/**
 获取验证码的回调
 */
@property (nonatomic, copy) GetVerifyCodeBlock getVerifyCodeBlock;
/**
 初始化
 @param viewType KNBLoginInputViewType
 */
- (instancetype)initWithFrame:(CGRect)frame viewType:(KNBLoginInputViewType)viewType;

/**
 定时器开关
 
 @param startTimer YES开器
 */
- (void)timerControll:(BOOL)startTimer;

@end

NS_ASSUME_NONNULL_END
