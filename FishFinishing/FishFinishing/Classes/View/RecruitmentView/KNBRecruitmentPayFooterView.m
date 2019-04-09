//
//  KNBRecruitmentPayFooterView.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/9.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBRecruitmentPayFooterView.h"

@interface KNBRecruitmentPayFooterView ()
//按钮
@property (nonatomic, strong) UIButton *enterButton;

@end

@implementation KNBRecruitmentPayFooterView

- (instancetype)init {
    if (self = [super init]) {
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
        [_enterButton setTitle:@"确认支付" forState:UIControlStateNormal];
        [_enterButton setBackgroundColor:[UIColor colorWithHex:0x1898e3]];
        _enterButton.layer.masksToBounds = YES;
        _enterButton.layer.cornerRadius = 20;
        [_enterButton addTarget:self action:@selector(enterButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterButton;
}

@end
