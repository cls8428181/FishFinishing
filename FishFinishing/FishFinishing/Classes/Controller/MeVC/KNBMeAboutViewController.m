//
//  KNBMeAboutViewController.m
//  FishFinishing
//
//  Created by apple on 2019/4/19.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBMeAboutViewController.h"
#import "KNBMeAboutTableViewCell.h"
#import "KNBMeAboutHeaderView.h"
#import "KNBMeAboutFooterView.h"

@interface KNBMeAboutViewController ()
@property (nonatomic, strong) KNBMeAboutHeaderView *headerView;
@property (nonatomic, strong) KNBMeAboutFooterView *footerView;
@end

@implementation KNBMeAboutViewController

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
}

#pragma mark - Utils
- (void)configuration {
    self.naviView.title = @"联系我们";
    [self.naviView addLeftBarItemImageName:@"knb_back_black" target:self sel:@selector(backAction)];
    self.knbTableView.backgroundColor = [UIColor colorWithHex:0x009fe8];
    
}

- (void)addUI {
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KNBMeAboutTableViewCell *cell = [KNBMeAboutTableViewCell cellWithTableView:tableView];
    if (indexPath.row == 0) {
        cell.iconImageView.image = KNBImages(@"knb_me_weixin");
        cell.titleLabel.text = @"微信客服";
        cell.detailLabel.text = @"18600000000";
    } else if (indexPath.row == 1) {
        cell.iconImageView.image = KNBImages(@"knb_me_phone");
        cell.titleLabel.text = @"服务热线";
        cell.detailLabel.text = @"18600000000";
    } else {
        cell.iconImageView.image = KNBImages(@"knb_me_time");
        cell.titleLabel.text = @"接待时间";
        cell.detailLabel.text = @"18600000000";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [KNBMeAboutTableViewCell cellHeight];
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

#pragma mark - Getters And Setters
/* getter和setter全部都放在最后*/
- (KNBMeAboutHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[KNBMeAboutHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, 230);
    }
    return _headerView;
}

- (KNBMeAboutFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[KNBMeAboutFooterView alloc] init];
        _footerView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, 120);
    }
    return _footerView;
}


@end
