//
//  KNBMeHeaderView.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/29.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBMeHeaderView.h"

@interface KNBMeHeaderView ()
//头像
@property (nonatomic, strong) UIImageView *portraitImageView;
//姓名
@property (nonatomic, strong) UILabel *nameLabel;
//登陆按钮
@property (nonatomic, strong) UIButton *loginButton;
//聊天按钮
@property (nonatomic, strong) UIButton *chatButton;
//设置按钮
@property (nonatomic, strong) UIButton *setButton;
//背景
@property (nonatomic, strong) UIImageView *bgImageView;
//广告
@property (nonatomic, strong) UIButton *adButton;

@end

@implementation KNBMeHeaderView

#pragma mark - life cycle
- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.bgImageView];
        [self addSubview:self.adButton];
        [self addSubview:self.portraitImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.loginButton];
        [self addSubview:self.setButton];
        [self addSubview:self.chatButton];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    KNB_WS(weakSelf);
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(KNB_SCREEN_WIDTH * 170/375);
        make.top.left.right.equalTo(weakSelf);
    }];
    [self.adButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bgImageView.mas_bottom).mas_offset(12);
        make.left.equalTo(weakSelf).mas_offset(12);
        make.bottom.right.equalTo(weakSelf).mas_offset(-12);
    }];
    [self.portraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf).mas_offset(50);
        make.width.height.mas_equalTo(75);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.portraitImageView.mas_bottom).mas_offset(15);;
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.portraitImageView);
        make.bottom.equalTo(weakSelf.nameLabel);
    }];
    [self.setButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(35);
    }];
    [self.chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.setButton.mas_left).mas_offset(-20);
        make.top.mas_equalTo(35);
    }];
}

#pragma mark - event respon
- (void)setButtonAction:(UIButton *)button {
    !self.settingButtonBlock ?: self.settingButtonBlock();
}

- (void)chatButtonAction:(UIButton *)button {
    !self.chatButtonBlock ?: self.chatButtonBlock();
}

- (void)loginButtinAction {
    !self.loginButtonBlock ?: self.loginButtonBlock();
}

#pragma mark - lazy load
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"knb_me_headerbg"];
    }
    return _bgImageView;
}

- (UIButton *)adButton {
    if (!_adButton) {
        _adButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_adButton setImage:[UIImage imageNamed:@"knb_me_banner"] forState:UIControlStateNormal];
    }
    return _adButton;
}

- (UIImageView *)portraitImageView {
    if (!_portraitImageView) {
        _portraitImageView = [[UIImageView alloc] init];
        if ([KNBUserInfo shareInstance].isLogin) {
            [_portraitImageView sd_setImageWithURL:[NSURL URLWithString:[KNBUserInfo shareInstance].portrait] placeholderImage:KNBImages(@"knb_default_user")];
        } else {
            _portraitImageView.image = KNBImages(@"knb_default_user");
        }
    }
    return _portraitImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont boldSystemFontOfSize:18];
        _nameLabel.textColor = [UIColor whiteColor];
        if ([KNBUserInfo shareInstance].isLogin) {
            _nameLabel.text = [KNBUserInfo shareInstance].userName;
        } else {
            _nameLabel.text = @"请登录";
        }

    }
    return _nameLabel;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton addTarget:self action:@selector(loginButtinAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UIButton *)chatButton {
    if (!_chatButton) {
        _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatButton setImage:KNBImages(@"knb_me_chat") forState:UIControlStateNormal];
        [_chatButton addTarget:self action:@selector(chatButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chatButton;
}

- (UIButton *)setButton {
    if (!_setButton) {
        _setButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_setButton setImage:KNBImages(@"knb_me_set") forState:UIControlStateNormal];
        [_setButton addTarget:self action:@selector(setButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setButton;
}
@end
