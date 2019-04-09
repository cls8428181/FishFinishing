//
//  KNBOrderFooterView.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/9.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBOrderFooterView.h"

@interface KNBOrderFooterView ()
//按钮
@property (nonatomic, strong) UIButton *enterButton;
//标题
@property (nonatomic, strong) NSString *title;
@end

@implementation KNBOrderFooterView

- (instancetype)initWithButtonTitle:(NSString *)title {
    if (self = [super init]) {
        _title = title;
        [self addSubview:self.enterButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    KNB_WS(weakSelf);
    [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.centerX.equalTo(weakSelf);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(40);
    }];
}

- (void)enterButtonAction {
    !self.enterButtonBlock ?: self.enterButtonBlock();
}

- (UIButton *)enterButton {
    if (!_enterButton) {
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterButton setTitle:_title forState:UIControlStateNormal];
        [_enterButton setBackgroundColor:[UIColor colorWithHex:0x1898e3]];
        _enterButton.layer.masksToBounds = YES;
        _enterButton.layer.cornerRadius = 20;
        [_enterButton addTarget:self action:@selector(enterButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterButton;
}
@end
