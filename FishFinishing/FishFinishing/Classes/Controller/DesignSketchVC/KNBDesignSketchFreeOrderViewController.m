//
//  KNBDesignSketchFreeOrderViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/30.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBDesignSketchFreeOrderViewController.h"
//views
#import "KNBDesignSketchFreeOrderHeaderView.h"
#import "KNBDSFreeOrderNewHouseTableViewCell.h"
#import "KNBDSFreeOrderAddressTableViewCell.h"
#import "KNBDSFreeOrderAreaTableViewCell.h"
#import "KNBDSFreeOrderNameTableViewCell.h"
#import "KNBDSFreeOrderPhoneTableViewCell.h"
#import "KNBDSFreeOrderFooterView.h"


@interface KNBDesignSketchFreeOrderViewController ()
//顶部广告图片
@property (nonatomic, strong) UIImageView *adImageView;
//服务商 label
@property (nonatomic, strong) UILabel *titleLabel;
//服务商按钮
@property (nonatomic, strong) UIButton *titleButton;
//header view
@property (nonatomic, strong) KNBDesignSketchFreeOrderHeaderView *headerView;
//footer view
@property (nonatomic, strong) KNBDSFreeOrderFooterView *footerView;
@end

@implementation KNBDesignSketchFreeOrderViewController

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
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(22);
    }];
    [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    [self.adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.equalTo(weakSelf.naviView.mas_bottom).mas_offset(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(90);
    }];
    [self.knbTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.equalTo(weakSelf.adImageView.mas_bottom).mas_offset(12);
        make.right.mas_equalTo(-12);
        make.bottom.mas_equalTo(-44);
    }];
}

#pragma mark - Utils
- (void)configuration {
    self.naviView.title = @"免费获取装修预算";
    [self.naviView addLeftBarItemImageName:@"knb_design_back" target:self sel:@selector(backAction)];
    [self.naviView addRightBarItemImageName:@"knb_design_share" target:self sel:@selector(shareAction)];
    self.view.backgroundColor = [UIColor knBgColor];
    self.naviView.backgroundColor = [UIColor blackColor];
    self.knbTableView.backgroundColor = [UIColor whiteColor];
    
}

- (void)addUI {
    [self.view addSubview:self.adImageView];
    [self.view addSubview:self.knbTableView];
    self.knbTableView.tableHeaderView = self.headerView;
    self.knbTableView.tableFooterView = self.footerView;
}

- (void)fetchData {
    
}

#pragma mark - tableview delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        cell = [KNBDSFreeOrderNewHouseTableViewCell cellWithTableView:tableView];
    } else if (indexPath.row == 1) {
        cell = [KNBDSFreeOrderAddressTableViewCell cellWithTableView:tableView];
    } else if (indexPath.row == 2) {
        cell = [KNBDSFreeOrderAreaTableViewCell cellWithTableView:tableView];
    } else if (indexPath.row == 3) {
        cell = [KNBDSFreeOrderNameTableViewCell cellWithTableView:tableView];
    } else {
        cell = [KNBDSFreeOrderPhoneTableViewCell cellWithTableView:tableView];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Event Response
/*
 *  所有button、gestureRecognizer的响应事件都放在这个区域里面，不要到处乱放。
 */
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareAction {
    
}

#pragma mark - Getters And Setters
/* getter和setter全部都放在最后*/
- (UIImageView *)adImageView {
    if (!_adImageView) {
        _adImageView = [[UIImageView alloc] init];
        _adImageView.image = KNBImages(@"timg");
    }
    return _adImageView;
}

- (KNBDesignSketchFreeOrderHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[KNBDesignSketchFreeOrderHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, 200);
    }
    return _headerView;
}

- (KNBDSFreeOrderFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[KNBDSFreeOrderFooterView alloc] init];
        _footerView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, 65);
    }
    return _footerView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.text = @"服务商:";
    }
    return _titleLabel;
}

- (UIButton *)titleButton {
    if (!_titleButton) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleButton setTitle:@"装饰公司" forState:UIControlStateNormal];
        [_titleButton setImage:KNBImages(@"KNBMe_5") forState:UIControlStateNormal];
    }
    return _titleButton;
}

@end
