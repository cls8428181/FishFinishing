//
//  KNBMeRecruitmentAlertView.m
//  FishFinishing
//
//  Created by apple on 2019/5/5.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBMeRecruitmentAlertView.h"

@interface KNBMeRecruitmentAlertView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentTopLabel;
@property (nonatomic, strong) UILabel *contentMiddleLabel;
@property (nonatomic, strong) UILabel *contentBottomLabel;
@property (nonatomic, retain) UIView *coverView;
@property (nonatomic, strong) UIButton *recruitmentButton;
@property (nonatomic, strong) UIButton *experienceButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, copy) RecruitmentActionBlock recruitmentBlock;
@property (nonatomic, copy) ExperienceActionBlock experienceBlock;
@end

@implementation KNBMeRecruitmentAlertView

+ (void)showAlertViewRecruitmentBlock:(RecruitmentActionBlock)recruitmentBlock experienceBlock:(ExperienceActionBlock)experienceBlock {
    KNBMeRecruitmentAlertView *alertView = [[KNBMeRecruitmentAlertView alloc] initWithFrame:CGRectMake((KNB_SCREEN_WIDTH - 300)/2, (KNB_SCREEN_HEIGHT - 225)/2, 300, 225)];
    alertView.recruitmentBlock = recruitmentBlock;
    alertView.experienceBlock = experienceBlock;
    [alertView showPopupView:YES];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        [self addSubview:self.titleLabel];
        [self addSubview:self.contentTopLabel];
        [self addSubview:self.contentMiddleLabel];
        [self addSubview:self.contentBottomLabel];
        [self addSubview:self.recruitmentButton];
        [self addSubview:self.experienceButton];
        [self addSubview:self.cancelButton];
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
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
    }];
    [self.contentTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(60);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
    }];
    [self.contentMiddleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentTopLabel.mas_bottom).mas_offset(24);
        make.left.equalTo(weakSelf.contentTopLabel.mas_left);
    }];
    [self.contentBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentMiddleLabel.mas_bottom).mas_offset(14);
        make.left.equalTo(weakSelf.contentTopLabel.mas_left);
    }];
    [self.recruitmentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentBottomLabel.mas_bottom).mas_offset(25);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(25);
        make.left.mas_equalTo(30);
    }];
    [self.experienceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentBottomLabel.mas_bottom).mas_offset(25);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(25);
        make.right.mas_equalTo(-30);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
    }];
}

- (void)cancelButtonAction:(UIButton *)button {
    [self showPopupView:NO];
}

- (void)recruitmentButtonAction {
    [self showPopupView:NO];
    !self.recruitmentBlock ?: self.recruitmentBlock();
}

- (void)experienceButtonAction {
    [self showPopupView:NO];
    !self.experienceBlock ?: self.experienceBlock();
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

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor colorWithHex:0x333333];
        _titleLabel.text = @"提示";
    }
    return _titleLabel;
}

- (UILabel *)contentTopLabel {
    if (!_contentTopLabel) {
        _contentTopLabel = [[UILabel alloc] init];
        _contentTopLabel.textAlignment = NSTextAlignmentCenter;
        _contentTopLabel.font = [UIFont systemFontOfSize:14];
        _contentTopLabel.textColor = [UIColor colorWithHex:0x333333];
        _contentTopLabel.text = @"体验店铺，在功能上有一定的限制";
    }
    return _contentTopLabel;
}

- (UILabel *)contentMiddleLabel {
    if (!_contentMiddleLabel) {
        _contentMiddleLabel = [[UILabel alloc] init];
        _contentMiddleLabel.font = [UIFont systemFontOfSize:11];
        _contentMiddleLabel.textColor = [UIColor colorWithHex:0x333333];
        _contentMiddleLabel.text = @"• 前端不展示商家联系方式";
    }
    return _contentMiddleLabel;
}

- (UILabel *)contentBottomLabel {
    if (!_contentBottomLabel) {
        _contentBottomLabel = [[UILabel alloc] init];
        _contentBottomLabel.font = [UIFont systemFontOfSize:11];
        _contentBottomLabel.textColor = [UIColor colorWithHex:0x333333];
        _contentBottomLabel.text = @"• 仅可上传5个案例 、产品";
    }
    return _contentBottomLabel;
}

- (UIButton *)recruitmentButton {
    if (!_recruitmentButton) {
        _recruitmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recruitmentButton setTitle:@"直接入驻" forState:UIControlStateNormal];
        [_recruitmentButton setTitleColor:[UIColor colorWithHex:0x009fe8] forState:UIControlStateNormal];
        _recruitmentButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_recruitmentButton setBackgroundColor:[UIColor whiteColor]];
        _recruitmentButton.layer.borderWidth = 1;
        _recruitmentButton.layer.borderColor = [UIColor colorWithHex:0x009fe8].CGColor;
        _recruitmentButton.layer.masksToBounds = YES;
        _recruitmentButton.layer.cornerRadius = 12.5;
        [_recruitmentButton addTarget:self action:@selector(recruitmentButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recruitmentButton;
}

- (UIButton *)experienceButton {
    if (!_experienceButton) {
        _experienceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_experienceButton setTitle:@"立即体验" forState:UIControlStateNormal];
        [_experienceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_experienceButton setBackgroundColor:[UIColor colorWithHex:0x009fe8]];
        _experienceButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _experienceButton.layer.masksToBounds = YES;
        _experienceButton.layer.cornerRadius = 12.5;
        [_experienceButton addTarget:self action:@selector(experienceButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _experienceButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:KNBImages(@"knb_me_guanbi") forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

@end
