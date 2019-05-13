//
//  KNBMeAboutFooterView.m
//  FishFinishing
//
//  Created by apple on 2019/4/19.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBMeAboutFooterView.h"

@interface KNBMeAboutFooterView ()
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *middleLabel;
@property (nonatomic, strong) UILabel *bottomLabel;
@end

@implementation KNBMeAboutFooterView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.topLabel];
        [self addSubview:self.middleLabel];
        [self addSubview:self.bottomLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    KNB_WS(weakSelf);
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.centerX.equalTo(weakSelf);
    }];
    [self.middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topLabel.mas_bottom).mas_offset(10);
        make.centerX.equalTo(weakSelf);
    }];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.middleLabel.mas_bottom).mas_offset(10);
        make.centerX.equalTo(weakSelf);
    }];
}

- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.font = [UIFont systemFontOfSize:12];
        _topLabel.textColor = [UIColor colorWithHex:0xffffff alpha:0.5];
        _topLabel.textAlignment = NSTextAlignmentCenter;
        _topLabel.text = @"大鱼装修 版权所有";
    }
    return _topLabel;
}

- (UILabel *)middleLabel {
    if (!_middleLabel) {
        _middleLabel = [[UILabel alloc] init];
        _middleLabel.font = [UIFont systemFontOfSize:12];
        _middleLabel.textColor = [UIColor colorWithHex:0xffffff alpha:0.5];
        _middleLabel.textAlignment = NSTextAlignmentCenter;
        _middleLabel.numberOfLines = 0;
        _middleLabel.text = @"Copyright © 2017­﹣2019 Dayuzhuangxiu.";
    }
    return _middleLabel;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.font = [UIFont systemFontOfSize:12];
        _bottomLabel.textColor = [UIColor colorWithHex:0xffffff alpha:0.5];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        _bottomLabel.text = @"All Rights Reserved. ";
    }
    return _bottomLabel;
}

- (void)setModel:(KNBMeAboutModel *)model {
    self.middleLabel.text = model.copyright;
}

@end
