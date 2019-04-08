//
//  KNBSearchView.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/26.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBSearchView.h"
//高度
CGFloat KNBSearchViewHeight = 44;

@interface KNBSearchView ()
//搜索图片
@property (nonatomic, strong) UIImageView *searchImageView;
//搜索文字
@property (nonatomic, strong) UILabel *searchLabel;
//左边城市选择背景
@property (nonatomic, strong) UIImageView *chooseCityView;
//左边城市选择按钮
@property (nonatomic, strong) UIButton *chooseCityButton;
//右边聊天按钮
@property (nonatomic, strong) UIButton *chatButton;
@end

@implementation KNBSearchView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configView];
    }
    return self;
}

- (void)configView {
    [self addSubview:self.chooseCityView];
    [self addSubview:self.chooseCityButton];
    [self addSubview:self.chatButton];
    [self addSubview:self.searchBgView];
    self.backgroundColor = [UIColor colorWithHex:0x0096e6];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    KNB_WS(weakSelf);
    [self.chooseCityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.top.mas_equalTo(KNB_StatusBar_H + 12);
    }];
    [self.chooseCityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.chooseCityView);
    }];
    [self.chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KNB_StatusBar_H + 12);
        make.right.mas_equalTo(-25);
    }];
    [self.searchBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.chooseCityView.mas_right).mas_offset(10);
        make.right.equalTo(weakSelf.chatButton.mas_left).mas_offset(-10);
        make.centerY.equalTo(weakSelf.chooseCityView);
        make.height.mas_equalTo(30);
    }];
    [self.searchImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.searchBgView.mas_left).offset(15);
        make.centerY.mas_equalTo(weakSelf.searchBgView.mas_centerY);
    }];
    [self.searchLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.searchImageView.mas_right).offset(10);
        make.centerY.mas_equalTo(weakSelf.searchBgView.mas_centerY);
    }];
}

- (void)touchSearchBgViewAction:(UITapGestureRecognizer *)gr {
    if (self.touchBlock) {
        self.touchBlock();
    }
}

#pragma mark - Setter

- (UIView *)searchBgView {
    if (!_searchBgView) {
        _searchBgView = [[UIView alloc] init];
        _searchBgView.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.6];
        _searchBgView.layer.cornerRadius = 15;
        _searchBgView.layer.masksToBounds = YES;
        [_searchBgView addSubview:self.searchImageView];
        [_searchBgView addSubview:self.searchLabel];
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchSearchBgViewAction:)];
        [_searchBgView addGestureRecognizer:tapGR];
    }
    return _searchBgView;
}

- (UIImageView *)searchImageView {
    if (!_searchImageView) {
        _searchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"knb_home_search"]];
    }
    return _searchImageView;
}

- (UILabel *)searchLabel {
    if (!_searchLabel) {
        _searchLabel = [[UILabel alloc] init];
        _searchLabel.font = [UIFont systemFontOfSize:12];
        _searchLabel.textColor = [UIColor whiteColor];
        _searchLabel.textAlignment = NSTextAlignmentLeft;
        _searchLabel.text = @"猜猜我的预算能装成什么样?";
    }
    return _searchLabel;
}

- (UIImageView *)chooseCityView {
    if (!_chooseCityView) {
        _chooseCityView = [[UIImageView alloc] init];
        _chooseCityView.image = KNBImages(@"knb_home_locationbg");
    }
    return _chooseCityView;
}

- (UIButton *)chooseCityButton {
    if (!_chooseCityButton) {
        _chooseCityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseCityButton setImage:KNBImages(@"knb_home_location") forState:UIControlStateNormal];
        [_chooseCityButton setTitle:@"北京" forState:UIControlStateNormal];
        _chooseCityButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_chooseCityButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    return _chooseCityButton;
}

- (UIButton *)chatButton {
    if (!_chatButton) {
        _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatButton setImage:KNBImages(@"knb_home_news") forState:UIControlStateNormal];
    }
    return _chatButton;
}

@end
