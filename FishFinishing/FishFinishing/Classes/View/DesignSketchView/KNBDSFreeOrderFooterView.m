//
//  KNBDSFreeOrderFooterView.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/1.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBDSFreeOrderFooterView.h"

@interface KNBDSFreeOrderFooterView ()
@property (nonatomic, strong) UIButton *enterButton;
@end

@implementation KNBDSFreeOrderFooterView

#pragma mark - life cycle
- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.enterButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
    }];
}

#pragma mark - lazy load
- (UIButton *)enterButton {
    if (!_enterButton) {
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterButton setTitle:@"立即计算" forState:UIControlStateNormal];
        [_enterButton setBackgroundColor:[UIColor colorWithHex:0x0096e6]];
        _enterButton.layer.masksToBounds = YES;
        _enterButton.layer.cornerRadius = 3.f;
    }
    return _enterButton;
}

@end
