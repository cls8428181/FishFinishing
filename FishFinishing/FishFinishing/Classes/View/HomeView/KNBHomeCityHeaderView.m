//
//  KNBHomeCityHeaderView.m
//  Concubine
//
//  Created by 吴申超 on 2017/5/13.
//  Copyright © 2017年 dengyun. All rights reserved.
//

#import "KNBHomeCityHeaderView.h"


@interface KNBHomeCityHeaderView ()

@property (nonatomic, assign) KNHomeCityHeaderType headerType;
@property (nonatomic, strong) UILabel *currentTipLabel;
@property (nonatomic, strong) UILabel *currentCityLabel;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UILabel *allTipLabel;

@end


@implementation KNBHomeCityHeaderView

- (instancetype)initWithViewType:(KNHomeCityHeaderType)headerType {
    self.headerType = headerType;
    return [self initWithFrame:CGRectMake(0, KNB_NAV_HEIGHT, KNB_SCREEN_WIDTH, self.cityHeaderViewHeight)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureViews];
    }
    return self;
}

- (void)configureViews {
    self.backgroundColor = [UIColor whiteColor];
    if (self.headerType == KNHomeCityHeaderCustom) {
        [self addSubview:self.currentTipLabel];
        [self addSubview:self.currentCityLabel];
        [self addSubview:self.lineLabel];
        self.allTipLabel.userInteractionEnabled = NO;
        self.allTipLabel.text = @"所有城市";
        [self addSubview:self.allTipLabel];
    }
}


- (void)tapAction:(UITapGestureRecognizer *)tap {
    if (self.allCityBlock) {
        self.allCityBlock();
    }
}

#pragma mark - Layout
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    KNB_WS(weakSelf);
    if (self.headerType == KNHomeCityHeaderCustom) {
        [self.allTipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0).offset(-5);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
    }

    /////////// 50 /////////////
    if (self.headerType == KNHomeCityHeaderCustom) {
        [self.lineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
            make.bottom.mas_equalTo(weakSelf.allTipLabel.mas_top).offset(-5);
        }];

        [self.currentTipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(18);
        }];

        [self.currentCityLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.currentTipLabel.mas_bottom).offset(8);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(18);
        }];
    }

    [super updateConstraints];
}

#pragma mark - Getting && Setting

- (UILabel *)allTipLabel {
    if (!_allTipLabel) {
        _allTipLabel = [[UILabel alloc] init];
        _allTipLabel.textColor = [UIColor knMainColor];
        _allTipLabel.text = @"全部城市";
        _allTipLabel.font = [UIFont systemFontOfSize:14.0];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_allTipLabel addGestureRecognizer:tap];
        _allTipLabel.userInteractionEnabled = YES;
    }
    return _allTipLabel;
}

- (UILabel *)currentTipLabel {
    if (!_currentTipLabel) {
        _currentTipLabel = [[UILabel alloc] init];
        _currentTipLabel.textColor = [UIColor knMainColor];
        _currentTipLabel.text = @"当前城市";
        _currentTipLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _currentTipLabel;
}

- (UILabel *)lineLabel {
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] init];
        _lineLabel.backgroundColor = [UIColor knLightGrayColor];
    }
    return _lineLabel;
}

- (UILabel *)currentCityLabel {
    if (!_currentCityLabel) {
        _currentCityLabel = [[UILabel alloc] init];
        _currentCityLabel.textColor = [UIColor knBlackColor];
        _currentCityLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _currentCityLabel;
}

- (void)setCurrentCityName:(NSString *)aCurrentCityName {
    _currentCityName = aCurrentCityName;
    self.currentCityLabel.text = aCurrentCityName;
}

- (CGFloat)cityHeaderViewHeight {
    return 130;
}

@end
