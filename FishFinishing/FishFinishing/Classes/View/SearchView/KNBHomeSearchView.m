//
//  KNBHomeSearchView.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/26.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeSearchView.h"
#import "NSString+Contain.h"
#import "NSString+Size.h"
#import "KNBHomeCityListViewController.h"
#import "KNAlertView.h"

//高度
CGFloat KNBHomeSearchViewHeight = 44;

@interface KNBHomeSearchView ()
//搜索图片
@property (nonatomic, strong) UIImageView *searchImageView;
//搜索文字
@property (nonatomic, strong) UILabel *searchLabel;
//左边城市选择背景
@property (nonatomic, strong) UIImageView *chooseCityView;
//右边聊天按钮
@property (nonatomic, strong) UIButton *chatButton;
//默认城市名称
@property (nonatomic, copy) NSString *defaultCityName;
@end

@implementation KNBHomeSearchView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configView];
    }
    return self;
}

- (void)configView {
    [self addSubview:self.chooseCityButton];
    [self addSubview:self.chooseCityView];
    [self addSubview:self.chatButton];
    [self addSubview:self.searchBgView];
    self.backgroundColor = [UIColor whiteColor];
//    KNB_WS(weakSelf);
    self.defaultCityName = [KNGetUserLoaction shareInstance].cityName;
    [self changeButtontTitle:self.defaultCityName];
//    [KNGetUserLoaction shareInstance].completeBlock = ^(NSString *cityName, NSString *code) {
//        [KNGetUserLoaction shareInstance].currentCityName = cityName;
//        if (![weakSelf.defaultCityName isEqualToString:cityName]) {
//            [weakSelf remindChangeCityName:cityName code:code];
//        }
//    };
}

- (void)layoutSubviews {
    [super layoutSubviews];
    KNB_WS(weakSelf);
    [self.chooseCityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KNB_StatusBar_H);
        make.left.mas_equalTo(13);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(36);
    }];
    [self.chooseCityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.chooseCityButton.mas_right).mas_offset(5);
        make.centerY.equalTo(weakSelf.chooseCityButton);
    }];
    [self.chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.chooseCityButton);
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

- (void)chooseCityButtonAction:(UIButton *)button {
    KNB_WS(weakSelf);
    KNBHomeCityListViewController *cityListVC = [[KNBHomeCityListViewController alloc] init];
    cityListVC.cityBlock = ^(NSString *cityName, NSString *areaId) {
        [[KNGetUserLoaction shareInstance] saveUserProvinceName:nil cityName:cityName areaName:nil address:cityName areaId:areaId saveCompleteBlock:^{
            weakSelf.defaultCityName = cityName;
            [weakSelf changeButtontTitle:cityName];
            !weakSelf.cityChooseBlock ?: weakSelf.cityChooseBlock();
        }];
    };
    KNBNavgationController *nav = [[KNBNavgationController alloc] initWithRootViewController:cityListVC];
    [KNB_AppDelegate.navController presentViewController:nav animated:YES completion:nil];
}

- (void)changeButtontTitle:(NSString *)cityName {
    self.defaultCityName = cityName;
    cityName = [cityName replaceString:@"市" withString:@""];
    CGFloat btnW = [cityName widthWithFont:[UIFont systemFontOfSize:14] constrainedToHeight:20];
    if (btnW >= 35) {
        btnW = 35;
    }
    [self.chooseCityButton setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, btnW)];
    [self.chooseCityButton setTitle:cityName forState:UIControlStateNormal];
    [KNGetUserLoaction shareInstance].selectCityName = cityName;
}

//提醒用户是否切换城市
- (void)remindChangeCityName:(NSString *)cityName code:(NSString *)code {
    KNB_WS(weakSelf);
    KNAlertView *alterView = [[KNAlertView alloc] initAlterTitle:nil];
    alterView.attributedString = [[KNGetUserLoaction shareInstance] remidTitle:cityName];
    alterView.alterBlock = ^(NSInteger selectIndex) {
        if (selectIndex == 1) {
            [[KNGetUserLoaction shareInstance] saveUserProvinceName:nil cityName:cityName areaName:nil address:cityName areaId:code saveCompleteBlock:^{
                [weakSelf changeButtontTitle:cityName];
                !weakSelf.cityChooseBlock ?: weakSelf.cityChooseBlock();
            }];
        }
    };
    [alterView showAlterView];
}

- (void)chatButtonAction {
    !self.chatButtonBlock ?: self.chatButtonBlock();
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
        _searchLabel.textColor = KNBColor(0x919191);
        _searchLabel.textAlignment = NSTextAlignmentLeft;
        _searchLabel.text = @"猜猜我的预算能装成什么样?";
    }
    return _searchLabel;
}

- (UIImageView *)chooseCityView {
    if (!_chooseCityView) {
        _chooseCityView = [[UIImageView alloc] init];
        _chooseCityView.image = KNBImages(@"knb_search_xialajiantou");
    }
    return _chooseCityView;
}

- (UIButton *)chooseCityButton {
    if (!_chooseCityButton) {
        _chooseCityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"knb_home_location"];
        [_chooseCityButton setImage:image forState:UIControlStateNormal];
        [_chooseCityButton setTitle:@"北京" forState:UIControlStateNormal];
        [_chooseCityButton setTitleColor:KNBColor(0x4d4d4d) forState:UIControlStateNormal];
        _chooseCityButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_chooseCityButton addTarget:self action:@selector(chooseCityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_chooseCityButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [self changeButtontTitle:self.defaultCityName];
        _chooseCityButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _chooseCityButton;
}

- (UIButton *)chatButton {
    if (!_chatButton) {
        _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chatButton setImage:KNBImages(@"knb_home_news") forState:UIControlStateNormal];
        [_chatButton addTarget:self action:@selector(chatButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chatButton;
}

@end
