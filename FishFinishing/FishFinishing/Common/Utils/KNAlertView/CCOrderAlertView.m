//
//  CCOrderAlertView.m
//  FishFinishing
//
//  Created by apple on 2019/5/22.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "CCOrderAlertView.h"
#import "CCOrderAlertTextView.h"
#import "UIButton+Style.h"

@interface CCOrderAlertView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *nickNameArrow;
@property (nonatomic, strong) CCOrderAlertTextView *nickNameTextView;
@property (nonatomic, strong) UILabel *phoneArrow;
@property (nonatomic, strong) CCOrderAlertTextView *phoneTextView;
@property (nonatomic, strong) UIButton *openButton;
@property (nonatomic, strong) UILabel *openDescribe;
@property (nonatomic, retain) UIView *coverView;
@property (nonatomic, strong) UIButton *orderButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) CCOrderAlertTextView *areaTextView;
@property (nonatomic, strong) CCOrderAlertTextView *addressTextView;
@property (nonatomic, strong) UIButton *houseButton;
@property (nonatomic, strong) UIButton *oldHouseButton;
@property (nonatomic, copy) OrderActionBlock orderBlock;
@property (nonatomic, copy) NSString *house;
@end

@implementation CCOrderAlertView
+ (void)showAlertViewOrderBlock:(OrderActionBlock)orderBlock {
    CCOrderAlertView *alertView = [[CCOrderAlertView alloc] initWithFrame:CGRectMake((KNB_SCREEN_WIDTH - 305)/2, (KNB_SCREEN_HEIGHT - 315)/2, 305, 315)];
    alertView.orderBlock = orderBlock;
    [alertView showPopupView:YES];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        [self addSubview:self.titleLabel];
        [self addSubview:self.nickNameTextView];
        [self addSubview:self.nickNameArrow];
        [self addSubview:self.phoneTextView];
        [self addSubview:self.phoneArrow];
        [self addSubview:self.orderButton];
        [self addSubview:self.openDescribe];
        [self addSubview:self.openButton];
        [self addSubview:self.cancelButton];
        [self setUpDataUI];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)showPopupView:(BOOL)show {
    if (show) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.coverView.frame = window.frame;
        [window addSubview:self.coverView];
    } else {
        KNB_WS(weakSelf);
        [weakSelf.coverView removeFromSuperview];
    }
}

- (void)openView:(BOOL)open {
    KNB_WS(weakSelf);
    [self addSubview:weakSelf.areaTextView];
    [self addSubview:weakSelf.addressTextView];
    [self addSubview:weakSelf.houseButton];
    [self addSubview:weakSelf.oldHouseButton];
    [self settingLayout];
    [UIView animateWithDuration:0.5 animations:^{
        self.openButton.alpha = 0;
        self.openDescribe.alpha = 0;
        self.orderButton.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.y = weakSelf.y - (410 - 315)/2;
            weakSelf.height = 410;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                weakSelf.orderButton.alpha = 1;
                weakSelf.areaTextView.alpha = 1;
                weakSelf.addressTextView.alpha = 1;
                weakSelf.houseButton.alpha = 1;
                weakSelf.oldHouseButton.alpha = 1;
            }];
        }];
    }];
}

- (void)setUpDataUI {
    KNB_WS(weakSelf);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(26);
        make.centerX.mas_equalTo(weakSelf);
    }];
    [self.nickNameTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).mas_offset(35);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(38);
    }];
    [self.nickNameArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.nickNameTextView.mas_left).mas_offset(0);;
        make.left.mas_equalTo(0);
        make.centerY.equalTo(weakSelf.nickNameTextView);
    }];
    [self.phoneTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nickNameTextView.mas_bottom).mas_offset(13);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(38);
    }];
    [self.phoneArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.phoneTextView.mas_left).mas_offset(0);;
        make.left.mas_equalTo(0);
        make.centerY.equalTo(weakSelf.phoneTextView);
    }];
    [self.orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-25);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(40);
    }];
    [self.openDescribe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.orderButton.mas_top).mas_offset(-20);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
    }];
    [self.openButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.openDescribe.mas_top).mas_offset(0);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
}

- (void)settingLayout {
    KNB_WS(weakSelf);
    [self.areaTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.phoneTextView.mas_bottom).mas_offset(13);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(38);
    }];
    [self.addressTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.areaTextView.mas_bottom).mas_offset(13);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(38);
    }];
    [self.houseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.addressTextView.mas_bottom).mas_offset(15);
        make.right.mas_equalTo(weakSelf.mas_centerX).mas_offset(-25);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(45);
    }];
    [self.oldHouseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.addressTextView.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(weakSelf.mas_centerX).mas_offset(25);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(45);
    }];
}

- (void)cancelButtonAction:(UIButton *)button {
    [self showPopupView:NO];
}

- (void)openButtonAction {
    [self openView:YES];
}

- (void)orderButtonAction {
    if (isNullStr(self.nickNameTextView.detailTextField.text)) {
        [LCProgressHUD showMessage:@"昵称不能为空"];
        return;
    }
    
    if (isNullStr(self.phoneTextView.detailTextField.text)) {
        [LCProgressHUD showMessage:@"手机号不能为空"];
        return;
    }
    
    [self showPopupView:NO];
    !self.orderBlock ?: self.orderBlock(self.nickNameTextView.detailTextField.text, self.phoneTextView.detailTextField.text, self.areaTextView.detailTextField.text ?: @"", self.addressTextView.detailTextField.text ?: @"", self.house ?: @"");
}

- (void)houseButtonAction:(UIButton *)button {
    button.selected = YES;
    self.house = button.titleLabel.text;
    self.oldHouseButton.selected = NO;
}

- (void)oldHouseButtonAction:(UIButton *)button {
    button.selected = YES;
    self.house = button.titleLabel.text;
    self.houseButton.selected = NO;
}

#pragma mark 懒加载
- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.userInteractionEnabled = YES;
        _coverView.backgroundColor = [UIColor colorWithRed:26 / 255.0 green:26 / 255.0 blue:26 / 255.0 alpha:0.7];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, KNB_SCREEN_HEIGHT);
        [_coverView addSubview:button];
        [_coverView addSubview:self];
    }
    return _coverView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        _titleLabel.textColor = [UIColor colorWithHex:0x343434];
        _titleLabel.text = @"公司名称";
    }
    return _titleLabel;
}

- (UILabel *)nickNameArrow {
    if (!_nickNameArrow) {
        _nickNameArrow = [[UILabel alloc] init];
        _nickNameArrow.text = @"＊";
        _nickNameArrow.textColor = [UIColor redColor];
        _nickNameArrow.textAlignment = NSTextAlignmentCenter;
    }
    return _nickNameArrow;
}

- (CCOrderAlertTextView *)nickNameTextView {
    if (!_nickNameTextView) {
        _nickNameTextView = [[CCOrderAlertTextView alloc] init];
        _nickNameTextView.type = CCOrderAlertTextViewTypeNickName;
    }
    return _nickNameTextView;
}

- (UILabel *)phoneArrow {
    if (!_phoneArrow) {
        _phoneArrow = [[UILabel alloc] init];
        _phoneArrow.text = @"＊";
        _phoneArrow.textColor = [UIColor redColor];
        _phoneArrow.textAlignment = NSTextAlignmentCenter;
    }
    return _phoneArrow;
}

- (CCOrderAlertTextView *)phoneTextView {
    if (!_phoneTextView) {
        _phoneTextView = [[CCOrderAlertTextView alloc] init];
        _phoneTextView.type = CCOrderAlertTextViewTypePhone;
    }
    return _phoneTextView;
}

- (UIButton *)openButton {
    if (!_openButton) {
        _openButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_openButton setImage:KNBImages(@"knb_service_open") forState:UIControlStateNormal];
        [_openButton addTarget:self action:@selector(openButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openButton;
}

- (UILabel *)openDescribe {
    if (!_openDescribe) {
        _openDescribe = [[UILabel alloc] init];
        _openDescribe.font = [UIFont systemFontOfSize:10];
        _openDescribe.textColor = [UIColor colorWithHex:0x858585];
        _openDescribe.text = @"点击+号，补充完整信息，获取更多优质服务哦！";
    }
    return _openDescribe;
}

- (UIButton *)orderButton {
    if (!_orderButton) {
        _orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_orderButton setTitle:@"免费预约" forState:UIControlStateNormal];
        [_orderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_orderButton setBackgroundColor:[UIColor colorWithHex:0x009fe8]];
        _orderButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _orderButton.layer.masksToBounds = YES;
        _orderButton.layer.cornerRadius = 20;
        [_orderButton addTarget:self action:@selector(orderButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orderButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:KNBImages(@"knb_me_guanbi") forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (CCOrderAlertTextView *)areaTextView {
    if (!_areaTextView) {
        _areaTextView = [[CCOrderAlertTextView alloc] init];
        _areaTextView.type = CCOrderAlertTextViewTypeArea;
        _areaTextView.alpha = 0;
    }
    return _areaTextView;
}

- (CCOrderAlertTextView *)addressTextView {
    if (!_addressTextView) {
        _addressTextView = [[CCOrderAlertTextView alloc] init];
        _addressTextView.type = CCOrderAlertTextViewTypeAddress;
        _addressTextView.alpha = 0;
    }
    return _addressTextView;
}

- (UIButton *)houseButton {
    if (!_houseButton) {
        _houseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_houseButton setTitle:@"新房" forState:UIControlStateNormal];
        [_houseButton setTitleColor:[UIColor kn808080Color] forState:UIControlStateNormal];
        _houseButton.titleLabel.font = KNBFont(15);
        [_houseButton setImage:KNBImages(@"knb_offer_kong") forState:UIControlStateNormal];
        [_houseButton setImage:KNBImages(@"knb_offer_hover") forState:UIControlStateSelected];
        [_houseButton addTarget:self action:@selector(houseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_houseButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:6];
        _houseButton.alpha = 0;
    }
    return _houseButton;
}

- (UIButton *)oldHouseButton {
    if (!_oldHouseButton) {
        _oldHouseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_oldHouseButton setTitle:@"旧房" forState:UIControlStateNormal];
        [_oldHouseButton setTitleColor:[UIColor kn808080Color] forState:UIControlStateNormal];
        _oldHouseButton.titleLabel.font = KNBFont(15);
        [_oldHouseButton setImage:KNBImages(@"knb_offer_kong") forState:UIControlStateNormal];
        [_oldHouseButton setImage:KNBImages(@"knb_offer_hover") forState:UIControlStateSelected];
        [_oldHouseButton addTarget:self action:@selector(oldHouseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_oldHouseButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:6];
        _oldHouseButton.alpha = 0;
    }
    return _oldHouseButton;
}

@end
