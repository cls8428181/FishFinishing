//
//  KNBSearchView.m
//  KenuoTraining
//
//  Created by 常立山 on 2018/7/18.
//  Copyright © 2018年 Robert. All rights reserved.
//

#import "KNBSearchView.h"


@interface KNBSearchView () <UISearchBarDelegate>

@property (nonatomic, strong) UIButton *backButton;
//是否有返回按钮
@property (nonatomic, assign) BOOL isHaveBackBtn;
//是否有取消按钮
@property (nonatomic, assign) BOOL isHaveCancleBtn;
@property (nonatomic, assign) BOOL searchBarSearch;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, assign) BOOL isNavView;

@end


@implementation KNBSearchView

- (instancetype)initWithFrame:(CGRect)frame isNavView:(BOOL)isNavView isHaveBackButton:(BOOL)isHaveBack isHaveCancleButton:(BOOL)isHaveCancle style:(KNBSearchViewStyle)style {
    if (self = [super initWithFrame:frame]) {
        _style = style;
        _isHaveBackBtn = isHaveBack;
        _isHaveCancleBtn = isHaveCancle;
        _isNavView = isNavView;
        if (style == KNBSearchViewStyleWhite) {
            self.backgroundColor = [UIColor whiteColor];
        } else {
            self.backgroundColor = KNB_NAV_COLOR;
        }
        [self configView];
    }
    return self;
}

- (void)configView {
    if (self.isHaveBackBtn) {
        [self addSubview:self.backButton];
    }
    if (self.style == KNBSearchViewStyleWhite) {
        [self addSubview:self.bottomLine];
    }
    [self addSubview:self.searchBar];
    if (self.isHaveCancleBtn) {
        [self addSubview:self.cancelButton];
    }
}

#pragma mark - Layout
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    KNB_WS(weakSelf);

    if (self.isHaveBackBtn) {
        [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(0);
            make.top.mas_equalTo(weakSelf.isNavView ? KNB_StatusBar_H : 10);
            make.width.mas_equalTo(44);
            make.height.mas_equalTo(44);
        }];
    }

    [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        //有返回按钮
        if (weakSelf.isHaveBackBtn) {
            make.left.mas_equalTo(weakSelf.backButton.mas_right).mas_offset(0);
            make.width.mas_equalTo(weakSelf.isHaveCancleBtn ? KNB_SCREEN_WIDTH - 114 : KNB_SCREEN_WIDTH - 68);
        } else { //无返回按钮
            make.left.mas_equalTo(12);
            make.width.mas_equalTo(weakSelf.isHaveCancleBtn ? KNB_SCREEN_WIDTH - 77 : KNB_SCREEN_WIDTH - 24);
        }
        make.top.mas_equalTo((weakSelf.isNavView ? KNB_StatusBar_H : 3) + 7);
        make.height.mas_equalTo(30);
    }];

    if (self.isHaveCancleBtn) {
        [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.searchBar.mas_right).offset(15);
            make.centerY.mas_equalTo(weakSelf.searchBar.mas_centerY);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(44);
        }];
    }

    if (self.style == KNBSearchViewStyleWhite) {
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(weakSelf);
            make.height.mas_offset(1);
        }];
    }

    [super updateConstraints];
}

- (void)touchBackButtonAction:(UIButton *)sender {
    if (self.backBlock) {
        self.backBlock();
    }
}

- (void)cancelButtonAction:(UIButton *)button {
    if (_isHaveBackBtn) {
        if (self.searchBarSearch) {
            [self searchBarCancelButtonClicked:self.searchBar];
        }
    }
    !self.backBlock ?: self.backBlock();
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (_delegate && [_delegate respondsToSelector:@selector(searchView:startSearchWithSearchText:)]) {
        [_delegate searchView:self startSearchWithSearchText:searchBar.text];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if (_delegate && [_delegate respondsToSelector:@selector(searchViewSearchBarBeginEditing)]) {
        [_delegate searchViewSearchBarBeginEditing];
    }
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBarSearch = NO;
    searchBar.text = nil;
    [searchBar resignFirstResponder];
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    self.searchBarSearch = YES;
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (_delegate && [_delegate respondsToSelector:@selector(searchViewSearchBarTextDidChange:)]) {
        [_delegate searchViewSearchBarTextDidChange:searchText];
    }
}
#pragma mark - Setter
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (self.style == KNBSearchViewStyleWhite) {
            [_backButton setImage:[UIImage imageNamed:@"smart_btn_Return"] forState:UIControlStateNormal];
        } else {
            [_backButton setImage:[UIImage imageNamed:@"icon_return"] forState:UIControlStateNormal];
        }
        [_backButton addTarget:self action:@selector(touchBackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (KNBSearchBar *)searchBar {
    if (!_searchBar) {
        if (self.style == KNBSearchViewStyleWhite) {
            _searchBar = [[KNBSearchBar alloc] initWithbBackgroudColor:[UIColor colorWithHex:0xebebeb] borderColor:[UIColor colorWithHex:0xebebeb]];
        } else {
            _searchBar = [[KNBSearchBar alloc] initWithbBackgroudColor:[UIColor whiteColor] borderColor:[UIColor whiteColor]];
        }
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        if (self.style == KNBSearchViewStyleWhite) {
            [_cancelButton setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
            [_cancelButton setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateHighlighted];
        } else {
            [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        }

        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    }
    return _bottomLine;
}
@end
