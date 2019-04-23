//
//  KNBOrderAlertView.m
//  Concubine
//
//  Created by 王明亮 on 2017/11/9.
//  Copyright © 2017年 dengyun. All rights reserved.
//

#import "KNBOrderAlertView.h"


@interface KNBOrderAlertView ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, retain) UIView *coverView;
@property (nonatomic, strong) UIButton *enterButton;
@property (nonatomic, copy) EnterActionBlock enterBlock;

@end


@implementation KNBOrderAlertView

+ (void)showAlertViewCompleteBlock:(EnterActionBlock)enterBlock {
    KNBOrderAlertView *alertView = [[KNBOrderAlertView alloc] initWithFrame:CGRectMake((KNB_SCREEN_WIDTH - 300)/2, (KNB_SCREEN_HEIGHT - 225)/2, 300, 225)];
    alertView.enterBlock = enterBlock;
    [alertView showPopupView:YES];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        [self addSubview:self.iconImageView];
        [self addSubview:self.titleLab];
        [self addSubview:self.contentLab];
        [self addSubview:self.enterButton];
        [self setUpDataUI];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)showPopupView:(BOOL)show {
    if (show) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.coverView.frame = window.frame;
        [window addSubview:self.coverView];
    } else {
        KNB_WS(weakSelf);
        [weakSelf.coverView removeFromSuperview];
    }
}
- (void)setUpDataUI {
    KNB_WS(weakSelf);
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.width.height.mas_equalTo(60);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.top.equalTo(weakSelf.iconImageView.mas_bottom).mas_offset(15);
    }];
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLab.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
    }];
    [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-25);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(25);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
    }];
}

- (void)enterButtonAction {
    [self showPopupView:NO];
    !self.enterBlock ?: self.enterBlock();
}

- (void)cancelButtonAction:(UIButton *)button {
    [self showPopupView:NO];
}

#pragma mark 懒加载
- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.userInteractionEnabled = YES;
        _coverView.backgroundColor = [UIColor colorWithRed:26 / 255.0 green:26 / 255.0 blue:26 / 255.0 alpha:0.7];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, KNB_SCREEN_HEIGHT);
        [_coverView addSubview:button];
        [_coverView addSubview:self];
    }
    return _coverView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = KNBImages(@"knb_icon_succeed");
    }
    return _iconImageView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"提交成功";
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont boldSystemFontOfSize:16];
        _titleLab.textColor = [UIColor colorWithHex:0x333333];
    }
    return _titleLab;
}

- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.textColor = [UIColor colorWithHex:0x333333];
        _contentLab.font = [UIFont systemFontOfSize:11];
        _contentLab.textAlignment = NSTextAlignmentCenter;
        _contentLab.numberOfLines = 0;
        _contentLab.text = @"感谢您的预约，您的预约信息已经提交后台， 24小时内将致电您，为您提供免费装修咨询。";
    }
    return _contentLab;
}

- (UIButton *)enterButton {
    if (!_enterButton) {
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterButton setTitle:@"完成" forState:UIControlStateNormal];
        [_enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _enterButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_enterButton setBackgroundColor:[UIColor colorWithHex:0x009fe8]];
        _enterButton.layer.masksToBounds = YES;
        _enterButton.layer.cornerRadius = 12.5;
        [_enterButton addTarget:self action:@selector(enterButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterButton;
}
@end
