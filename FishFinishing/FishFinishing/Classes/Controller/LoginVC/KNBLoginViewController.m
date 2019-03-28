//
//  KNBLoginViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/27.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBLoginViewController.h"
//views
#import "KNBButton.h"
#import "KNBLoginInputView.h"

@interface KNBLoginViewController ()
//logo
@property (nonatomic, strong) KNBButton *logoButton;
//输入手机号带icon
@property (nonatomic, strong) KNBLoginInputView *mobileView;
//输入手机号带标题
@property (nonatomic, strong) KNBLoginInputView *mobileTextView;
//输入验证码
@property (nonatomic, strong) KNBLoginInputView *verinumView;
//密码
@property (nonatomic, strong) KNBLoginInputView *passwordView;
//设置密码
@property (nonatomic, strong) KNBLoginInputView *passwordSetView;
//新的密码
@property (nonatomic, strong) KNBLoginInputView *passwordNewView;
//确认密码
@property (nonatomic, strong) KNBLoginInputView *passwordEnterView;
//登录/确定
@property (nonatomic, strong) KNBButton *sureButton;
//返回按钮
@property (nonatomic, strong) KNBButton *backButton;
//新用户注册
@property (nonatomic, strong) KNBButton *newRegisterButton;
//已有账号
@property (nonatomic, strong) KNBButton *loginButton;
//找回密码
@property (nonatomic, strong) KNBButton *findButton;
//用于记录最后一个 View
@property (nonatomic, strong) KNBLoginInputView *lastView;
//底部左边横线
@property (nonatomic, strong) UIView *leftLineView;
//底部右边横线
@property (nonatomic, strong) UIView *rightLineView;
//底部中间横线
@property (nonatomic, strong) UILabel *middleLabel;
//qq登陆
@property (nonatomic, strong) UIButton *qqButton;
//微信登陆
@property (nonatomic, strong) UIButton *wechatButton;
//新浪微博登陆
@property (nonatomic, strong) UIButton *sinaButton;

@end

@implementation KNBLoginViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configuration];
    
    [self addUI];
    
    [self settingConstraints];
}

#pragma mark - Setup UI Constraints
/*
 *  在这里添加UIView的约束布局相关代码
 */
- (void)settingConstraints {
    KNB_WS(weakSelf);
    //logo
    [self.logoButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.naviView.mas_bottom).mas_offset(40);
        make.centerX.equalTo(weakSelf.view);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(95);
    }];
    
    //如果是登录页面
    if (self.vcType == KNBLoginTypeLogin) {
        //手机号码
        [self.mobileView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.logoButton.mas_bottom).mas_offset(40);
            make.centerX.equalTo(weakSelf.view);
            make.width.mas_equalTo(250);
            make.height.mas_equalTo(30);
        }];
        [self.passwordView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.mobileView.mas_bottom).mas_offset(20);
            make.centerX.equalTo(weakSelf.view);
            make.width.mas_equalTo(250);
            make.height.mas_equalTo(30);
        }];
        [self.findButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.passwordView.mas_bottom).offset(10);
            make.right.mas_equalTo(weakSelf.sureButton);
        }];
        //新用户注册
        [self.newRegisterButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.passwordView.mas_bottom).offset(10);
            make.right.equalTo(weakSelf.findButton.mas_left).mas_offset(-5);
        }];
        
        [self.wechatButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.view).mas_offset(-70);
            make.centerX.equalTo(weakSelf.view);
        }];
        
        [self.qqButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.view).mas_offset(-70);
            make.right.equalTo(weakSelf.wechatButton.mas_left).mas_offset(-50);
        }];
        
        [self.sinaButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.view).mas_offset(-70);
            make.left.equalTo(weakSelf.wechatButton.mas_right).mas_offset(50);
        }];
        
        [self.middleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.wechatButton.mas_top).mas_offset(-35);
            make.centerX.equalTo(weakSelf.view);
        }];
        
        [self.leftLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.middleLabel);
            make.left.mas_equalTo(25);
            make.right.equalTo(weakSelf.middleLabel.mas_left).mas_offset(-25);
            make.height.mas_equalTo(0.5);
        }];
        
        [self.rightLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.middleLabel);
            make.right.mas_equalTo(-25);
            make.left.equalTo(weakSelf.middleLabel.mas_right).mas_offset(25);
            make.height.mas_equalTo(0.5);
        }];
    
    } else {
        [self.mobileTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.logoButton.mas_bottom).mas_offset(40);
            make.centerX.equalTo(weakSelf.view);
            make.width.mas_equalTo(250);
            make.height.mas_equalTo(30);
        }];
        [self.verinumView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf.mobileTextView.mas_bottom).mas_offset(20);
            make.centerX.equalTo(weakSelf.view);
            make.width.mas_equalTo(250);
            make.height.mas_equalTo(30);
        }];
        if (self.vcType == KNBLoginTypeRegister) {
            [self.passwordSetView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(weakSelf.verinumView.mas_bottom).mas_offset(20);
                make.centerX.equalTo(weakSelf.view);
                make.width.mas_equalTo(250);
                make.height.mas_equalTo(30);
            }];
            [self.passwordEnterView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(weakSelf.passwordSetView.mas_bottom).mas_offset(20);
                make.centerX.equalTo(weakSelf.view);
                make.width.mas_equalTo(250);
                make.height.mas_equalTo(30);
            }];
            [self.loginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(weakSelf.passwordEnterView.mas_bottom).offset(10);
                make.right.mas_equalTo(weakSelf.sureButton);
            }];
        } else {
            [self.passwordNewView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(weakSelf.verinumView.mas_bottom).mas_offset(20);
                make.centerX.equalTo(weakSelf.view);
                make.width.mas_equalTo(250);
                make.height.mas_equalTo(30);
            }];
            [self.passwordEnterView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(weakSelf.passwordNewView.mas_bottom).mas_offset(20);
                make.centerX.equalTo(weakSelf.view);
                make.width.mas_equalTo(250);
                make.height.mas_equalTo(30);
            }];
        }
    }
    
    //登录确认
    [self.sureButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(250);
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(self.lastView.mas_bottom).mas_offset(60);
    }];
}

#pragma mark - Utils
- (void)configuration {
    //如果是登录页面
    if (self.vcType == KNBLoginTypeLogin) {
        self.naviView.title = @"登录";
    } else if (self.vcType == KNBLoginTypeRegister) {
        self.naviView.title = @"注册";
    } else {
        self.naviView.title = @"密码重置";
    }
    self.naviView.backgroundColor = [UIColor clearColor];
    [self.naviView addRightBarItemImageName:@"knb_login_close" target:self sel:@selector(backAction)];
    self.view.backgroundColor = [UIColor orangeColor];
    
}

- (void)addUI {
    [self.view addSubview:self.logoButton];
    [self.view addSubview:self.sureButton];
    if (self.vcType == KNBLoginTypeLogin) {
        [self.view addSubview:self.mobileView];
        [self.view addSubview:self.passwordView];
        [self.view addSubview:self.findButton];
        [self.view addSubview:self.newRegisterButton];
        [self.view addSubview:self.wechatButton];
        [self.view addSubview:self.qqButton];
        [self.view addSubview:self.sinaButton];
        [self.view addSubview:self.middleLabel];
        [self.view addSubview:self.leftLineView];
        [self.view addSubview:self.rightLineView];
        self.lastView = self.passwordView;
    } else {
        [self.view addSubview:self.mobileTextView];
        [self.view addSubview:self.verinumView];
        if (self.vcType == KNBLoginTypeRegister) {
            [self.view addSubview:self.passwordSetView];
            [self.view addSubview:self.loginButton];
        } else {
            [self.view addSubview:self.passwordNewView];
        }
        [self.view addSubview:self.passwordEnterView];
        self.lastView = self.passwordEnterView;
    }
}
#pragma mark - Event Response
- (void)backAction {
    [self.verinumView timerControll:NO];
    if (self.navigationController.viewControllers.count == 1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//登录or确定
- (void)sureButtonClick:(KNBButton *)sender {
    //验证手机号是否为空
    if (isNullStr(self.mobileView.textField.text) || !isPhoneNumber(self.mobileView.textField.text)) {
        [LCProgressHUD showInfoMsg:@"请输入正确的手机号"];
        [[LCProgressHUD sharedHUD].customView setSize:CGSizeMake(25, 25)];
        return;
    }
    
    if (self.vcType == KNBLoginTypeLogin) {
        if (isNullStr(self.verinumView.textField.text) && isNullStr(self.passwordView.textField.text)) {
            NSString *msg = (self.passwordView.hidden) ? @"验证码不能为空" : @"密码不能为空";
            [LCProgressHUD showInfoMsg:msg];
            [[LCProgressHUD sharedHUD].customView setSize:CGSizeMake(25, 25)];
            return;
        }
    } else {
        if (isNullStr(self.verinumView.textField.text) || isNullStr(self.passwordView.textField.text)) {
            NSString *msg = (isNullStr(self.verinumView.textField.text)) ? @"验证码不能为空" : @"密码不能为空";
            [LCProgressHUD showInfoMsg:msg];
            [[LCProgressHUD sharedHUD].customView setSize:CGSizeMake(25, 25)];
            return;
        }
//        (self.vcType == KNBLoginRegisterType) ? [self registKNAppRequest] : [self findPassswordRequest];
    }
}
//新用户注册
- (void)userRegisterClick:(KNBButton *)sender {
    KNBLoginViewController *registerVC = [[KNBLoginViewController alloc] init];
    registerVC.vcType = KNBLoginTypeRegister;
    [self.navigationController pushViewController:registerVC animated:YES];
}
//密码重置
- (void)findClick:(KNBButton *)sender {
    KNBLoginViewController *findVC = [[KNBLoginViewController alloc] init];
    findVC.vcType = KNBLoginTypeFindPassword;
    [self.navigationController pushViewController:findVC animated:YES];
}
//已有账号
- (void)loginClick:(KNBButton *)sender {
    KNBLoginViewController *findVC = [[KNBLoginViewController alloc] init];
    findVC.vcType = KNBLoginTypeLogin;
    [self.navigationController pushViewController:findVC animated:YES];
}
//获取验证码
- (void)getVerifyCodeRequest {
    if (isNullStr(self.mobileView.textField.text) || !isPhoneNumber(self.mobileView.textField.text)) {
        [LCProgressHUD showInfoMsg:@"请输入正确的手机号"];
        [[LCProgressHUD sharedHUD].customView setSize:CGSizeMake(25, 25)];
        return;
    }
//
//    KNBVerificationCodeApi *verCode = [[KNBVerificationCodeApi alloc]
//                                       initWithMobile:self.mobileView.textField.text];
//    KNB_WS(weakSelf);
//    [verCode startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
//        if (verCode.statusCodeSuccess) {
//            [LCProgressHUD showSuccess:@"发送成功"];
            [self verinumViewTimerControll:YES];
//        } else {
//            [LCProgressHUD showInfoMsg:verCode.errMessage];
//            [[LCProgressHUD sharedHUD].customView setSize:CGSizeMake(25, 25)];
//        }
//    } failure:^(__kindof YTKBaseRequest *request) {
//        [LCProgressHUD showFailure:verCode.errMessage];
//    }];
}
//定时器处理
- (void)verinumViewTimerControll:(BOOL)startTimer {
    [self.verinumView timerControll:startTimer];
}
#pragma mark - lazy load
- (KNBButton *)logoButton {
    if (!_logoButton) {
        _logoButton = [KNBButton buttonWithType:UIButtonTypeCustom];
        [_logoButton setImage:KNBImages(@"knb_login_logo") forState:UIControlStateNormal];
        [_logoButton sizeToFit];
        [_logoButton setTitle:@"大鱼装修" forState:UIControlStateNormal];
        _logoButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_logoButton verticalImageAndTitle:15];
        [_logoButton setUserInteractionEnabled  :NO];
    }
    return _logoButton;
}

- (KNBLoginInputView *)mobileView {
    if (!_mobileView) {
        _mobileView = [[KNBLoginInputView alloc] initWithFrame:CGRectZero viewType:KNBLoginInputViewTypeMobileAndIcon];
    }
    return _mobileView;
}

- (KNBLoginInputView *)mobileTextView {
    if (!_mobileTextView) {
        _mobileTextView = [[KNBLoginInputView alloc] initWithFrame:CGRectZero viewType:KNBLoginInputViewTypeMobileAndText];
    }
    return _mobileTextView;
}

- (KNBLoginInputView *)verinumView {
    if (!_verinumView) {
        _verinumView = [[KNBLoginInputView alloc] initWithFrame:CGRectZero viewType:KNBLoginInputViewTypeVerify];
        KNB_WS(weakSelf);
        _verinumView.getVerifyCodeBlock = ^{
//            [weakSelf getVerifyCodeRequest];
        };
    }
    return _verinumView;
}

- (KNBLoginInputView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[KNBLoginInputView alloc] initWithFrame:CGRectZero viewType:KNBLoginInputViewTypePassword];
    }
    return _passwordView;
}

- (KNBLoginInputView *)passwordSetView {
    if (!_passwordSetView) {
        _passwordSetView = [[KNBLoginInputView alloc] initWithFrame:CGRectZero viewType:KNBLoginInputViewTypeSetPassword];
    }
    return _passwordSetView;
}

- (KNBLoginInputView *)passwordNewView {
    if (!_passwordNewView) {
        _passwordNewView = [[KNBLoginInputView alloc] initWithFrame:CGRectZero viewType:KNBLoginInputViewTypeNewPassword];
    }
    return _passwordNewView;
}

- (KNBLoginInputView *)passwordEnterView {
    if (!_passwordEnterView) {
        _passwordEnterView = [[KNBLoginInputView alloc] initWithFrame:CGRectZero viewType:KNBLoginInputViewTypeEnterPassword];
    }
    return _passwordEnterView;
}

- (KNBButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [KNBButton buttonWithType:UIButtonTypeCustom];
        _sureButton.titleLabel.font = KNBFont(16);
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureButton setBackgroundColor:[UIColor colorWithHex:0x009fe8]];
        _sureButton.layer.masksToBounds = YES;
        _sureButton.layer.cornerRadius = 15;
        [_sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (self.vcType == KNBLoginTypeLogin) {
            [_sureButton setTitle:@"登录" forState:UIControlStateNormal];
        } else if (self.vcType == KNBLoginTypeRegister) {
            [_sureButton setTitle:@"立即注册" forState:UIControlStateNormal];
        } else {
            [_sureButton setTitle:@"重置密码" forState:UIControlStateNormal];
        }
    }
    return _sureButton;
}

- (KNBButton *)newRegisterButton {
    if (!_newRegisterButton) {
        _newRegisterButton = [KNBButton buttonWithType:UIButtonTypeCustom];
        [_newRegisterButton setTitle:@"没有账号?" forState:UIControlStateNormal];
        _newRegisterButton.titleLabel.font = KNBFont(11);
        [_newRegisterButton setTitleColor:[UIColor colorWithHex:0x009fe8] forState:UIControlStateNormal];
        [_newRegisterButton addTarget:self action:@selector(userRegisterClick:) forControlEvents:UIControlEventTouchUpInside];
        _newRegisterButton.titleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _newRegisterButton;
}

- (KNBButton *)findButton {
    if (!_findButton) {
        _findButton = [KNBButton buttonWithType:UIButtonTypeCustom];
        [_findButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        _findButton.titleLabel.font = KNBFont(11);
        [_findButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_findButton addTarget:self action:@selector(findClick:) forControlEvents:UIControlEventTouchUpInside];
        _findButton.titleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _findButton;
}

- (UIView *)leftLineView {
    if (!_leftLineView) {
        _leftLineView = [[UIView alloc] init];
        _leftLineView.backgroundColor = [UIColor whiteColor];
    }
    return _leftLineView;
}

- (UIView *)rightLineView {
    if (!_rightLineView) {
        _rightLineView = [[UIView alloc] init];
        _rightLineView.backgroundColor = [UIColor whiteColor];
    }
    return _rightLineView;
}

- (UILabel *)middleLabel {
    if (!_middleLabel) {
        _middleLabel = [[UILabel alloc] init];
        _middleLabel.text = @"第三方登陆";
        _middleLabel.textColor = [UIColor whiteColor];
        _middleLabel.font = [UIFont systemFontOfSize:11];
    }
    return _middleLabel;
}

- (UIButton *)qqButton {
    if (!_qqButton) {
        _qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_qqButton setImage:KNBImages(@"knb_login_qq") forState:UIControlStateNormal];
    }
    return _qqButton;
}

- (UIButton *)wechatButton {
    if (!_wechatButton) {
        _wechatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_wechatButton setImage:KNBImages(@"knb_login_wechat") forState:UIControlStateNormal];
    }
    return _wechatButton;
}

- (UIButton *)sinaButton {
    if (!_sinaButton) {
        _sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sinaButton setImage:KNBImages(@"knb_login_blog") forState:UIControlStateNormal];
    }
    return _sinaButton;
}

- (KNBButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [KNBButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:@"已有账号" forState:UIControlStateNormal];
        _loginButton.titleLabel.font = KNBFont(11);
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.titleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _loginButton;
}

@end
