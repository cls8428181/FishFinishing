//
//  KNBHomeDesignViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/2.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeDesignViewController.h"
//views
#import "KNBDSFreeOrderNewHouseTableViewCell.h"
#import "KNBDSFreeOrderAddressTableViewCell.h"
#import "KNBDSFreeOrderAreaTableViewCell.h"
#import "KNBDSFreeOrderNameTableViewCell.h"
#import "KNBDSFreeOrderPhoneTableViewCell.h"
#import "KNBDSFreeOrderRedEnterTableViewCell.h"
#import "KNBDSFreeOrderFooterView.h"
#import "DesignSketchViewController.h"
//utils
#import "KNBButton.h"

@interface KNBHomeDesignViewController ()
@property (nonatomic, strong) UIScrollView *bgView;
//顶部广告图片
@property (nonatomic, strong) UIImageView *adImageView;
//服务商 label
@property (nonatomic, strong) UILabel *titleLabel;
//服务商按钮
@property (nonatomic, strong) UIButton *titleButton;
//服务流程
@property (nonatomic, strong) UILabel *middleLabel;
//电话回访
@property (nonatomic, strong) KNBButton *phoneButton;
//上门量房
@property (nonatomic, strong) KNBButton *ruleButton;
//出设计图
@property (nonatomic, strong) KNBButton *designButton;
//方案调优
@property (nonatomic, strong) KNBButton *infoButton;
//左边的箭头
@property (nonatomic, strong) UIImageView *leftArrowImageView;
//中间的箭头
@property (nonatomic, strong) UIImageView *middleArrowImageView;
//右边的箭头
@property (nonatomic, strong) UIImageView *rightArrowImageView;
//header view
@property (nonatomic, strong) UIView *headerView;
//footer view
@property (nonatomic, strong) KNBDSFreeOrderFooterView *footerView;

@end

@implementation KNBHomeDesignViewController

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
        make.top.mas_equalTo(KNB_NAV_HEIGHT);
        make.left.right.bottom.equalTo(weakSelf.view);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(22);
    }];
    [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.titleLabel);
        make.left.equalTo(weakSelf.titleLabel.mas_right).mas_offset(15);
    }];
    [self.adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.titleButton.mas_bottom).mas_offset(12);
        make.height.mas_equalTo(138);
    }];
    [self.middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.adImageView.mas_bottom).mas_offset(15);
        make.centerX.equalTo(weakSelf.view);
    }];
    CGFloat leftPadding = (KNB_SCREEN_WIDTH - 320)/8;
    CGFloat middlePadding = leftPadding * 2;
    [self.phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftPadding);
        make.top.equalTo(weakSelf.middleLabel.mas_bottom).mas_offset(12);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
    [self.leftArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.phoneButton.mas_right).mas_offset(0);
        make.centerY.equalTo(weakSelf.phoneButton);
    }];
    [self.ruleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.phoneButton.mas_right).mas_offset(middlePadding);
        make.top.equalTo(weakSelf.middleLabel.mas_bottom).mas_offset(12);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
    [self.middleArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.ruleButton.mas_right).mas_offset(0);
        make.centerY.equalTo(weakSelf.phoneButton);
    }];
    [self.designButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.ruleButton.mas_right).mas_offset(middlePadding);
        make.top.equalTo(weakSelf.middleLabel.mas_bottom).mas_offset(12);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
    [self.rightArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.designButton.mas_right).mas_offset(0);
        make.centerY.equalTo(weakSelf.phoneButton);
    }];
    [self.infoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.designButton.mas_right).mas_offset(middlePadding);
        make.top.equalTo(weakSelf.middleLabel.mas_bottom).mas_offset(12);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(10);
        make.top.equalTo(weakSelf.infoButton.mas_bottom).mas_offset(20);
    }];
}

#pragma mark - Utils
- (void)configuration {
    self.naviView.title = @"免费获取装修预算";
    [self.naviView addLeftBarItemImageName:@"knb_back_black" target:self sel:@selector(backAction)];
    [self.naviView addRightBarItemImageName:@"knb_design_share" target:self sel:@selector(shareAction)];
    self.naviView.titleNaviLabel.textColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.knbTableView.backgroundColor = [UIColor whiteColor];
    self.knbTableView.layer.shadowColor = [UIColor colorWithHex:0xcccccc].CGColor;
    self.knbTableView.layer.shadowOffset = CGSizeMake(0,0);
    self.knbTableView.layer.shadowOpacity = 0.5;
    self.knbTableView.layer.shadowRadius = 5;
    self.knbTableView.clipsToBounds = false;
    self.knbTableView.scrollEnabled = NO;
    self.knbTableView.frame = CGRectMake(12, 370, KNB_SCREEN_WIDTH - 24, 315);
    self.footerView.frame = CGRectMake(12, CGRectGetMaxY(self.knbTableView.frame), KNB_SCREEN_WIDTH - 24, 38);
}

- (void)addUI {
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.titleButton];
    [self.bgView addSubview:self.adImageView];
    [self.bgView addSubview:self.middleLabel];
    [self.bgView addSubview:self.phoneButton];
    [self.bgView addSubview:self.leftArrowImageView];
    [self.bgView addSubview:self.ruleButton];
    [self.bgView addSubview:self.middleArrowImageView];
    [self.bgView addSubview:self.designButton];
    [self.bgView addSubview:self.rightArrowImageView];
    [self.bgView addSubview:self.infoButton];
    [self.bgView addSubview:self.headerView];
    [self.bgView addSubview:self.knbTableView];
    [self.bgView addSubview:self.footerView];
}

- (void)fetchData {
    
}

#pragma mark - tableview delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
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
    } else  if (indexPath.row == 4){
        cell = [KNBDSFreeOrderPhoneTableViewCell cellWithTableView:tableView];
    } else {
        cell = [KNBDSFreeOrderRedEnterTableViewCell cellWithTableView:tableView];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? 55 : 50;
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
- (UIScrollView *)bgView {
    if (!_bgView) {
        _bgView = [[UIScrollView alloc] init];
        _bgView.contentSize = CGSizeMake(KNB_SCREEN_WIDTH,730);
    }
    return _bgView;
}
- (UIImageView *)adImageView {
    if (!_adImageView) {
        _adImageView = [[UIImageView alloc] init];
        _adImageView.image = KNBImages(@"knb_home_sy_banner");
    }
    return _adImageView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, 10);
        _headerView.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
    }
    return _headerView;
}

- (KNBDSFreeOrderFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[KNBDSFreeOrderFooterView alloc] init];
        _footerView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, 38);
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
        [_titleButton setImage:KNBImages(@"knb_default_user") forState:UIControlStateNormal];
        [_titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _titleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleButton;
}

- (UILabel *)middleLabel {
    if (!_middleLabel) {
        _middleLabel = [[UILabel alloc] init];
        _middleLabel.text = @"服务流程";
        _middleLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _middleLabel;
}

- (KNBButton *)phoneButton {
    if (!_phoneButton) {
        _phoneButton = [KNBButton buttonWithType:UIButtonTypeCustom];
        [_phoneButton setTitle:@"1.电话回访" forState:UIControlStateNormal];
        [_phoneButton setImage:KNBImages(@"knb_home_phone") forState:UIControlStateNormal];
        [_phoneButton setTitleColor:[UIColor colorWithHex:0x808080] forState:UIControlStateNormal];
        _phoneButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_phoneButton verticalImageAndTitle:12];
    }
    return _phoneButton;
}

- (UIImageView *)leftArrowImageView {
    if (!_leftArrowImageView) {
        _leftArrowImageView = [[UIImageView alloc] init];
        _leftArrowImageView.image = KNBImages(@"knb_home_arrow");
    }
    return _leftArrowImageView;
}

- (KNBButton *)ruleButton {
    if (!_ruleButton) {
        _ruleButton = [KNBButton buttonWithType:UIButtonTypeCustom];
        [_ruleButton setTitle:@"2.上门量房" forState:UIControlStateNormal];
        [_ruleButton setImage:KNBImages(@"knb_home_ruler") forState:UIControlStateNormal];
        [_ruleButton setTitleColor:[UIColor colorWithHex:0x808080] forState:UIControlStateNormal];
        _ruleButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_ruleButton verticalImageAndTitle:12];
    }
    return _ruleButton;
}

- (UIImageView *)middleArrowImageView {
    if (!_middleArrowImageView) {
        _middleArrowImageView = [[UIImageView alloc] init];
        _middleArrowImageView.image = KNBImages(@"knb_home_arrow");
    }
    return _middleArrowImageView;
}

- (KNBButton *)designButton {
    if (!_designButton) {
        _designButton = [KNBButton buttonWithType:UIButtonTypeCustom];
        [_designButton setTitle:@"3.出设计图" forState:UIControlStateNormal];
        [_designButton setImage:KNBImages(@"knb_home_design") forState:UIControlStateNormal];
        [_designButton setTitleColor:[UIColor colorWithHex:0x808080] forState:UIControlStateNormal];
        _designButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_designButton verticalImageAndTitle:12];
    }
    return _designButton;
}

- (UIImageView *)rightArrowImageView {
    if (!_rightArrowImageView) {
        _rightArrowImageView = [[UIImageView alloc] init];
        _rightArrowImageView.image = KNBImages(@"knb_home_arrow");
    }
    return _rightArrowImageView;
}

- (KNBButton *)infoButton {
    if (!_infoButton) {
        _infoButton = [KNBButton buttonWithType:UIButtonTypeCustom];
        [_infoButton setTitle:@"4.方案调优" forState:UIControlStateNormal];
        [_infoButton setImage:KNBImages(@"knb_home_information") forState:UIControlStateNormal];
        [_infoButton setTitleColor:[UIColor colorWithHex:0x808080] forState:UIControlStateNormal];
        _infoButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_infoButton verticalImageAndTitle:12];
    }
    return _infoButton;
}

@end
