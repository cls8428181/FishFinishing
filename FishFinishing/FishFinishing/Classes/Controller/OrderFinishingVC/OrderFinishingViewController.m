//
//  OrderFinishingViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/26.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "OrderFinishingViewController.h"
#import "KNBOrderViewController.h"
#import "KNBHomeBannerApi.h"
#import "KNBHomeBannerModel.h"
#import "KNBLoginViewController.h"
#import "UIImage+Size.h"
#import "KNBOrderCheckApi.h"

@interface OrderFinishingViewController ()
//背景
@property (nonatomic, strong) UIScrollView *bgView;
@property (nonatomic, strong) UIImageView *bgImageView;
//立即预约
@property (nonatomic, strong) UIButton *enterButton;
//数据
@property (nonatomic, strong) KNBHomeBannerModel *model;
@end

@implementation OrderFinishingViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configuration];
    
    [self addUI];
    
    [self settingConstraints];
    
    [self fetchData];
}

#pragma mark - Setup UI Constraints
/*
 *  在这里添加UIView的约束布局相关代码
 */
- (void)settingConstraints {
    KNB_WS(weakSelf);
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-KNB_TAB_HEIGHT);
    }];
    [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(40);
        make.centerX.equalTo(weakSelf.view);
        make.bottom.mas_equalTo(-KNB_TAB_HEIGHT-20);
    }];
}

#pragma mark - Utils
- (void)configuration {
    [self.naviView removeFromSuperview];
    self.view.backgroundColor = [UIColor knBgColor];
    if (@available(iOS 11.0, *)) {
        self.bgView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)addUI {
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.enterButton];
}

- (void)fetchData {
    KNBHomeBannerApi *api = [[KNBHomeBannerApi alloc] initWithVari:@"appointment_banner" cityName:[KNGetUserLoaction shareInstance].cityName];
    api.hudString = @"";
    KNB_WS(weakSelf);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            NSDictionary *dic = request.responseObject[@"list"];
            NSArray *modelArray = [KNBHomeBannerModel changeResponseJSONObject:dic];
            weakSelf.model = modelArray.firstObject;
            CGSize size = [UIImage getImageSizeWithURL:[NSURL URLWithString:weakSelf.model.img]];
            weakSelf.bgView.contentSize = CGSizeMake(KNB_SCREEN_WIDTH/size.width * size.width, KNB_SCREEN_HEIGHT/size.height * size.height);
            [weakSelf.bgView addSubview:weakSelf.bgImageView];
            weakSelf.bgImageView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH/size.width * size.width, KNB_SCREEN_HEIGHT/size.height * size.height);
            [weakSelf.bgImageView sd_setImageWithURL:[NSURL URLWithString:weakSelf.model.img] placeholderImage:KNBImages(@"knb_default_style")];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
    }];
}


#pragma mark - Event Response
/*
 *  所有button、gestureRecognizer的响应事件都放在这个区域里面，不要到处乱放。
 */
- (void)enterButtonAction:(UIButton *)button {
    KNB_WS(weakSelf);
    if ([KNBUserInfo shareInstance].isLogin) {
        KNBOrderCheckApi *api = [[KNBOrderCheckApi alloc] init];
        api.hudString = @"";
        KNB_WS(weakSelf);
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
            if (api.requestSuccess) {
                KNBOrderViewController *orderVC = [[KNBOrderViewController alloc] init];
                orderVC.VCType = KNBOrderVCTypeOrderFinishing;
                [weakSelf.navigationController pushViewController:orderVC animated:YES];
            } else {
                [LCProgressHUD showMessage:api.errMessage];
            }
        } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
            [LCProgressHUD showMessage:api.errMessage];
        }];

    } else {
        [KNBAlertRemind alterWithTitle:@"" message:@"您还未登录,请先登录" buttonTitles:@[@"去登录",@"取消"] handler:^(NSInteger index, NSString *title) {
            if ([title isEqualToString:@"去登录"]) {
                KNBLoginViewController *loginVC = [[KNBLoginViewController alloc] init];
                loginVC.vcType = KNBLoginTypeLogin;
                [weakSelf presentViewController:loginVC animated:YES completion:nil];
            }
        }];
    }

}

#pragma mark - Getters And Setters
/* getter和setter全部都放在最后*/
- (UIScrollView *)bgView {
    if (!_bgView) {
        _bgView = [[UIScrollView alloc] init];
    }
    return _bgView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
    }
    return _bgImageView;
}

- (UIButton *)enterButton {
    if (!_enterButton) {
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterButton setTitle:@"免费预约" forState:UIControlStateNormal];
        [_enterButton setBackgroundColor:[UIColor colorWithHex:0x1898e3]];
        _enterButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_enterButton addTarget:self action:@selector(enterButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _enterButton.layer.masksToBounds = YES;
        _enterButton.layer.cornerRadius = 20;
    }
    return _enterButton;
}

@end
