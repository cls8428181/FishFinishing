//
//  CCOrderAlertTextView.m
//  FishFinishing
//
//  Created by apple on 2019/5/23.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "CCOrderAlertTextView.h"

@interface CCOrderAlertTextView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *arrowLabel;
@end

@implementation CCOrderAlertTextView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor knf2f2f2Color];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3;
        [self addSubview:self.titleLabel];
        [self addSubview:self.detailTextField];
        [self addSubview:self.arrowLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    KNB_WS(weakSelf);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.centerY.equalTo(weakSelf);
    }];
    [self.detailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLabel.mas_right).mas_offset(8);
        make.right.mas_equalTo(-40);
        make.centerY.equalTo(weakSelf);
    }];
    [self.arrowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-13);
        make.centerY.equalTo(weakSelf);
    }];
}

- (void)setType:(CCOrderAlertTextViewType)type {
    self.arrowLabel.alpha = 0;
    if (type == CCOrderAlertTextViewTypeNickName) {
        self.titleLabel.text = @"您的称呼:";
    } else if (type == CCOrderAlertTextViewTypePhone) {
        self.titleLabel.text = @"手机号:";
        self.detailTextField.keyboardType = UIKeyboardTypeNumberPad;
    } else if (type == CCOrderAlertTextViewTypeArea) {
        self.titleLabel.text = @"面积:";
        self.detailTextField.keyboardType = UIKeyboardTypeDecimalPad;
        self.arrowLabel.alpha = 1;
    } else {
        self.titleLabel.text = @"小区名称:";
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = KNBColor(0x7e7e7e);
        _titleLabel.font = KNBFont(14);
    }
    return _titleLabel;
}

- (UITextField *)detailTextField {
    if (!_detailTextField) {
        _detailTextField = [[UITextField alloc] init];
        _detailTextField.font = KNBFont(14);
    }
    return _detailTextField;
}

- (UILabel *)arrowLabel {
    if (!_arrowLabel) {
        _arrowLabel = [[UILabel alloc] init];
        _arrowLabel.textColor = KNBColor(0x7e7e7e);
        _arrowLabel.font = KNBFont(14);
        _arrowLabel.text = @"㎡";
    }
    return _arrowLabel;
}

@end
