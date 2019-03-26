//
//  KNBTextField.m
//  KenuoTraining
//
//  Created by 沙漠 on 2018/3/16.
//  Copyright © 2018年 Robert. All rights reserved.
//

#import "KNBTextField.h"


@implementation KNBTextField

- (instancetype)initWithPlaceholderText:(NSString *)text {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        self.textColor = [UIColor colorWithHex:0x333333];
        self.font = [UIFont systemFontOfSize:12];
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:text];
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:[UIColor colorWithHex:0xcccccc]
                            range:NSMakeRange(0, text.length)];
        [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont boldSystemFontOfSize:13]
                            range:NSMakeRange(0, text.length)];
        self.attributedPlaceholder = placeholder;
    }

    return self;
}

- (void)addLeftWithImageNameNormal:(NSString *)imageNameN ImageNameSelect:(NSString *)imageNameS {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [button setImage:[UIImage imageNamed:imageNameN] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageNameS] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(leftViewAction:) forControlEvents:UIControlEventTouchUpInside];
    self.leftView = button;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)addRightWithImageNameNormal:(NSString *)imageNameN ImageNameSelect:(NSString *)imageNameS {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [button setImage:[UIImage imageNamed:imageNameN] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageNameS] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(rightViewAction:) forControlEvents:UIControlEventTouchUpInside];
    self.rightView = button;
    self.rightViewMode = UITextFieldViewModeAlways;
}

- (void)addLeftPlaceholderView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    view.backgroundColor = [UIColor clearColor];
    self.leftView = view;
    self.leftViewMode = UITextFieldViewModeAlways;
}


#pragma mark-- Action
- (void)leftViewAction:(UIButton *)sender {
    if (self.leftButtonBlock) {
        self.leftButtonBlock(sender);
    }
}

- (void)rightViewAction:(UIButton *)sender {
    if (self.rightButtonBlock) {
        self.rightButtonBlock(sender);
    }
}
@end
