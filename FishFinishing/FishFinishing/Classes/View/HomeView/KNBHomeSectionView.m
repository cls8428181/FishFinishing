//
//  KNBHomeSectionView.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/27.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeSectionView.h"

@interface KNBHomeSectionView ()
// 竖线
@property (nonatomic, strong) UIView *lineView;

@end

@implementation KNBHomeSectionView

#pragma mark - life cycle
- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.lineView];
        [self addSubview:self.titleLabel];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    KNB_WS(weakSelf);
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(12);
        make.width.mas_equalTo(2);
        make.height.mas_equalTo(15);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lineView.mas_right).mas_offset(10);
        make.centerY.equalTo(weakSelf.lineView);
    }];
}

#pragma lazy load
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHex:0x009fe8];
    }
    return _lineView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _titleLabel;
}

@end
