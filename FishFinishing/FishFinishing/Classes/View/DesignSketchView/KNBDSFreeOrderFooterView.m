//
//  KNBDSFreeOrderFooterView.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/1.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBDSFreeOrderFooterView.h"

@interface KNBDSFreeOrderFooterView ()
//图标
@property (nonatomic, strong) UIImageView *iconImageView;
//内容
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation KNBDSFreeOrderFooterView

#pragma mark - life cycle
- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.iconImageView];
        [self addSubview:self.contentLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    KNB_WS(weakSelf);
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.equalTo(weakSelf);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).mas_offset(10);
        make.centerY.equalTo(weakSelf);
    }];
}

#pragma mark - lazy load
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = KNBImages(@"knb_design_asterisk");
    }
    return _iconImageView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = @"大鱼承诺: 您的私人信息, 不泄露给第三方";
        _contentLabel.textColor = [UIColor colorWithHex:0x808080];
        _contentLabel.font = [UIFont systemFontOfSize:12];
    }
    return _contentLabel;
}

@end
