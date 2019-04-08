//
//  KNBDesignSketchDetailViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/30.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBDesignSketchDetailViewController.h"

@interface KNBDesignSketchDetailViewController ()
//返回按钮
@property (nonatomic, strong) UIButton *backButton;
//收藏按钮
@property (nonatomic, strong) UIButton *collectButton;
//分享按钮
@property (nonatomic, strong) UIButton *shareButton;
//大图
@property (nonatomic, strong) UIImageView *bigImageView;
//预约免费设计服务
@property (nonatomic, strong) UIButton *leftButton;
//立即预约
@property (nonatomic, strong) UIButton *orderButton;
@end

@implementation KNBDesignSketchDetailViewController

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
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(35);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(35);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(35);
        make.right.equalTo(weakSelf.shareButton.mas_left).mas_offset(-25);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    [self.bigImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.centerY.equalTo(weakSelf.view);
        make.height.mas_equalTo(290);
    }];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(weakSelf.view);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(KNB_SCREEN_WIDTH/3 * 2);
    }];
    [self.orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(weakSelf.view);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(KNB_SCREEN_WIDTH/3);
    }];
}

#pragma mark - Utils
- (void)configuration {
    [self.naviView removeFromSuperview];
    self.view.backgroundColor = [UIColor blackColor];
    
}

- (void)addUI {
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.collectButton];
    [self.view addSubview:self.shareButton];
    [self.view addSubview:self.bigImageView];
    [self.view addSubview:self.leftButton];
    [self.view addSubview:self.orderButton];
}

- (void)fetchData {
    
}

#pragma mark - Event Response
/*
 *  所有button、gestureRecognizer的响应事件都放在这个区域里面，不要到处乱放。
 */
- (void)backButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)collectButtonAction {
    
}

- (void)shareButtonAction {
    
}

- (void)orderButtonAction {

}

#pragma mark - Getters And Setters
/* getter和setter全部都放在最后*/
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:KNBImages(@"knb_design_back") forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)collectButton {
    if (!_collectButton) {
        _collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectButton setImage:KNBImages(@"knb_design_collect_unselect") forState:UIControlStateNormal];
        [_collectButton setImage:KNBImages(@"knb_design_collect_selected") forState:UIControlStateSelected];
        [_collectButton addTarget:self action:@selector(collectButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectButton;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setImage:KNBImages(@"knb_design_share") forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

- (UIImageView *)bigImageView {
    if (!_bigImageView) {
        _bigImageView = [[UIImageView alloc] init];
        _bigImageView.image = KNBImages(@"timg");
    }
    return _bigImageView;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setImage:KNBImages(@"3_selected") forState:UIControlStateNormal];
        [_leftButton setTitle:@"预约免费设计服务" forState:UIControlStateNormal];
        [_leftButton setBackgroundColor:[UIColor whiteColor]];
        [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _leftButton;
}

- (UIButton *)orderButton {
    if (!_orderButton) {
        _orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_orderButton setTitle:@"立即预约" forState:UIControlStateNormal];
        [_orderButton setBackgroundColor:[UIColor redColor]];
        [_orderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _orderButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_orderButton addTarget:self action:@selector(orderButtonAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _orderButton;
}
@end
