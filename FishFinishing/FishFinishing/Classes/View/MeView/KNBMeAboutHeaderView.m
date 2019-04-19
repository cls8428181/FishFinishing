//
//  KNBMeAboutHeaderView.m
//  FishFinishing
//
//  Created by apple on 2019/4/19.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBMeAboutHeaderView.h"

@interface KNBMeAboutHeaderView ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *versionLabel;
@end

@implementation KNBMeAboutHeaderView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.iconImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.versionLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    KNB_WS(weakSelf);
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(60);
        make.centerX.equalTo(weakSelf);
        make.width.mas_equalTo(67);
        make.height.mas_equalTo(67);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImageView.mas_bottom).mas_offset(36);
        make.centerX.equalTo(weakSelf);
    }];
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).mas_offset(10);
        make.centerX.equalTo(weakSelf);
    }];
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = KNBImages(@"knb_icon_logo");
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"大鱼装修";
    }
    return _titleLabel;
}

- (UILabel *)versionLabel {
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] init];
        _versionLabel.font = [UIFont systemFontOfSize:12];
        _versionLabel.textColor = [UIColor whiteColor];
        _versionLabel.text = @"Version 1.0.0";
    }
    return _versionLabel;
}

@end
