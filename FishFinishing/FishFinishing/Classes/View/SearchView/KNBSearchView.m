//
//  KNBSearchView.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/26.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBSearchView.h"

CGFloat KNBSearchViewHeight = 44;

@interface KNBSearchView ()

@property (nonatomic, strong) UIImageView *searchImageView;
@property (nonatomic, strong) UILabel *searchLabel;
@property (nonatomic, assign) BOOL isIMSearch;

@end

@implementation KNBSearchView {
    BOOL _isNaviSearch;
}

- (instancetype)initWithFrame:(CGRect)frame isNaviSearch:(BOOL)isNaviSearch {
    if (self = [super initWithFrame:frame]) {
        _isNaviSearch = isNaviSearch;
        [self configView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame isIMSearch:(BOOL)isIMSearch {
    if (self = [super initWithFrame:frame]) {
        _isIMSearch = isIMSearch;
        [self configView];
    }
    return self;
}

- (void)configView {
    [self addSubview:self.searchBgView];
}

- (void)touchSearchBgViewAction:(UITapGestureRecognizer *)gr {
    if (self.touchBlock) {
        self.touchBlock();
    }
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    KNB_WS(weakSelf);
    
    [self.searchBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self->_isNaviSearch) {
            make.left.mas_equalTo(-55);
            make.right.mas_equalTo(-6);
        } else {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
        }
        if (self->_isIMSearch) {
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(42);
            make.bottom.mas_equalTo(-10);
        } else {
            make.height.mas_equalTo(30);
            make.bottom.mas_equalTo(-7);
        }
        
    }];
    
    [self.searchImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.searchBgView.mas_left).offset(15);
        make.centerY.mas_equalTo(weakSelf.searchBgView.mas_centerY);
    }];
    
    [self.searchLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.searchImageView.mas_right).offset(10);
        make.centerY.mas_equalTo(weakSelf.searchBgView.mas_centerY);
    }];
    
    [super updateConstraints];
}

#pragma mark - Setter

- (UIView *)searchBgView {
    if (!_searchBgView) {
        _searchBgView = [[UIView alloc] init];
        _searchBgView.backgroundColor = [UIColor whiteColor];
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
        _searchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_home_search"]];
    }
    return _searchImageView;
}

- (UILabel *)searchLabel {
    if (!_searchLabel) {
        _searchLabel = [[UILabel alloc] init];
        _searchLabel.font = [UIFont systemFontOfSize:12];
        _searchLabel.textColor = [UIColor colorWithHex:0x959595];
        _searchLabel.textAlignment = NSTextAlignmentLeft;
        _searchLabel.text = @"请输入商品名称";
    }
    return _searchLabel;
}
@end
