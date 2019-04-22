//
//  RecruitmentViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/26.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "RecruitmentViewController.h"
#import "KNBOrderViewController.h"
#import "KNBHomeBannerApi.h"
#import "KNBHomeBannerModel.h"

@interface RecruitmentViewController ()
//背景
@property (nonatomic, strong) UIImageView *bgView;
//立即预约
@property (nonatomic, strong) UIButton *enterButton;
//数据
@property (nonatomic, strong) KNBHomeBannerModel *model;
@end

@implementation RecruitmentViewController

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
}

- (void)addUI {
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.enterButton];
}

- (void)fetchData {
    KNBHomeBannerApi *api = [[KNBHomeBannerApi alloc] initWithVari:@"facilitator_entry_banner" cityName:[KNGetUserLoaction shareInstance].cityName];
    api.hudString = @"";
    KNB_WS(weakSelf);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            NSDictionary *dic = request.responseObject[@"list"];
            NSArray *modelArray = [KNBHomeBannerModel changeResponseJSONObject:dic];
            weakSelf.model = modelArray.firstObject;
            KNB_PerformOnMainThread(^{
                [weakSelf.bgView sd_setImageWithURL:[NSURL URLWithString:weakSelf.model.img] placeholderImage:KNBImages(@"knb_default_style")];
            });
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
    }];
}

#pragma mark - Event Response
/*
 *  所有button、gestureRecognizer的响应事件都放在这个区域里面，不要到处乱放。
 */
- (void)enterButtonAction:(UIButton *)button {
    if ([KNBUserInfo shareInstance].isLogin) {
        KNBOrderViewController *orderVC = [[KNBOrderViewController alloc] init];
        orderVC.VCType = KNBOrderVCTypeRecruitment;
        [self.navigationController pushViewController:orderVC animated:YES];
    } else {
        [LCProgressHUD showMessage:@"您还未登录,请先登录"];
    }

}

#pragma mark - Getters And Setters
/* getter和setter全部都放在最后*/
- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        _bgView.image = KNBImages(@"knb_default_style");
    }
    return _bgView;
}

- (UIButton *)enterButton {
    if (!_enterButton) {
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterButton setTitle:@"立即入驻" forState:UIControlStateNormal];
        [_enterButton setBackgroundColor:[UIColor colorWithHex:0x1898e3]];
        _enterButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _enterButton.layer.masksToBounds = YES;
        _enterButton.layer.cornerRadius = 20;
        [_enterButton addTarget:self action:@selector(enterButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterButton;
}

@end
