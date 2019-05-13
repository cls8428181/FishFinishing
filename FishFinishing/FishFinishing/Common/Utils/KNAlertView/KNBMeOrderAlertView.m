//
//  KNBMeOrderAlertView.m
//  FishFinishing
//
//  Created by apple on 2019/4/24.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBMeOrderAlertView.h"
#import "KNBMeOrderStatusApi.h"
#import "UIButton+Style.h"

@interface KNBMeOrderAlertView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, retain) UIView *coverView;
@property (nonatomic, strong) UIButton *enterButton;
@property (nonatomic, strong) UIButton *delButton;
@property (nonatomic, strong) UIButton *signButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, copy) EnterActionBlock enterBlock;
@property (nonatomic, copy) EnterActionBlock deleteBlock;
@property (nonatomic, strong) KNBMeOrderModel *model;
//模型在数组中的位置记录
@property (nonatomic, assign) NSInteger index;
@end

@implementation KNBMeOrderAlertView
+ (void)showAlertViewWithModel:(KNBMeOrderModel *)model CompleteBlock:(EnterActionBlock)enterBlock deleteActionBlock:(DeleteActionBlock)deleteBlock {
    KNBMeOrderAlertView *alertView = [[KNBMeOrderAlertView alloc] initWithFrame:CGRectMake((KNB_SCREEN_WIDTH - 300)/2, (KNB_SCREEN_HEIGHT - 225)/2, 300, 225)];
    alertView.enterBlock = enterBlock;
    alertView.deleteBlock = deleteBlock;
    alertView.model = model;
    [alertView showPopupView:YES];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        [self addSubview:self.titleLabel];
        [self addSubview:self.enterButton];
        [self addSubview:self.delButton];
        [self addSubview:self.signButton];
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
        !self.enterBlock ?: self.enterBlock();
    }
}

- (void)setUpDataUI {
    KNB_WS(weakSelf);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(65);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
    }];
    [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).mas_offset(40);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(25);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
    }];
    [self.delButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.bottom.mas_equalTo(-25);
    }];
    [self.signButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-25);
        make.bottom.mas_equalTo(-25);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
    }];
}

- (void)enterButtonAction {
    NSString *telephoneNumber = self.model.mobile;
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",telephoneNumber];
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:str];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        //OpenSuccess = 选择 呼叫 为 1  选择 取消 为0
        NSLog(@"OpenSuccess=%d",success);
        
    }];
}

- (void)cancelButtonAction:(UIButton *)button {
    [self showPopupView:NO];
}

- (void)signButtonAction:(UIButton *)button {
    if (button.isSelected) {
        KNBMeOrderStatusApi *api = [[KNBMeOrderStatusApi alloc] initDispatchId:[self.model.orderId integerValue] sign:0];
        api.hudString = @"";
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
            if (api.requestSuccess) {
                button.selected = NO;
            } else {
                [LCProgressHUD showMessage:api.errMessage];
            }
        } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
            [LCProgressHUD showMessage:api.errMessage];
        }];
    } else {
        KNBMeOrderStatusApi *api = [[KNBMeOrderStatusApi alloc] initDispatchId:[self.model.orderId integerValue] sign:1];
        api.hudString = @"";
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
            if (api.requestSuccess) {
                button.selected = YES;
            } else {
                [LCProgressHUD showMessage:api.errMessage];
            }
        } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
            [LCProgressHUD showMessage:api.errMessage];
        }];
    }
}

- (void)delButtonAction {
    KNBMeOrderStatusApi *api = [[KNBMeOrderStatusApi alloc] initDispatchId:[self.model.orderId integerValue] sign:2];
    KNB_WS(weakSelf);
    api.hudString = @"";
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            [weakSelf showPopupView:NO];
            !weakSelf.deleteBlock ?: weakSelf.deleteBlock();
        } else {
            [LCProgressHUD showMessage:api.errMessage];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [LCProgressHUD showMessage:api.errMessage];
    }];
}

- (void)changeOrderStatus:(NSInteger)status {
    
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
        _titleLabel.font = [UIFont systemFontOfSize:19];
        _titleLabel.textColor = [UIColor colorWithHex:0x333333];
    }
    return _titleLabel;
}

- (UIButton *)enterButton {
    if (!_enterButton) {
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterButton setTitle:@"联系客户" forState:UIControlStateNormal];
        [_enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _enterButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_enterButton setBackgroundColor:[UIColor colorWithHex:0x009fe8]];
        _enterButton.layer.masksToBounds = YES;
        _enterButton.layer.cornerRadius = 12.5;
        [_enterButton addTarget:self action:@selector(enterButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterButton;
}

- (UIButton *)delButton {
    if (!_delButton) {
        _delButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_delButton setTitle:@"删除该条订单" forState:UIControlStateNormal];
        [_delButton setTitleColor:[UIColor colorWithHex:0x808080] forState:UIControlStateNormal];
        _delButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_delButton setImage:KNBImages(@"knb_me_shanchu-1") forState:UIControlStateNormal];
        [_delButton addTarget:self action:@selector(delButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delButton;
}

- (UIButton *)signButton {
    if (!_signButton) {
        _signButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_signButton setTitle:@"标记为已联系" forState:UIControlStateNormal];
        [_signButton setTitleColor:[UIColor colorWithHex:0x808080] forState:UIControlStateNormal];
        _signButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_signButton setImage:KNBImages(@"knb_me_weibiaoji") forState:UIControlStateNormal];
        [_signButton setImage:KNBImages(@"knb_me_biaoji") forState:UIControlStateSelected];
        [_signButton addTarget:self action:@selector(signButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_signButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    }
    return _signButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:KNBImages(@"knb_me_guanbi") forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (void)setModel:(KNBMeOrderModel *)model {
    _model = model;
    self.titleLabel.text = [NSString stringWithFormat:@"%@     %@",model.name,model.mobile];
    self.signButton.selected = [model.sign isEqualToString:@"1"];
}
@end
