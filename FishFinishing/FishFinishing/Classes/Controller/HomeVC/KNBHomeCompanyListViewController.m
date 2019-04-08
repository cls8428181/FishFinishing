//
//  KNBHomeCompanyListViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/8.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeCompanyListViewController.h"
#import "KNBHomeRecommendSubTableViewCell.h"
#import "KNBHomeCompanyListHeaderView.h"
#import "KNBHomeCompanyDetailViewController.h"

@interface KNBHomeCompanyListViewController ()
//header view
@property (nonatomic, strong) KNBHomeCompanyListHeaderView *headerView;
@end

@implementation KNBHomeCompanyListViewController

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
    if (self.VCtype == KNBHomeListTypeCompany) {
        self.naviView.title = @"装修公司";
    } else if (self.VCtype == KNBHomeListTypeForeman) {
        self.naviView.title = @"装修工长";
    } else if (self.VCtype == KNBHomeListTypeDesign) {
        self.naviView.title = @"设计师";
    } else if (self.VCtype == KNBHomeListTypeMaterial) {
        self.naviView.title = @"家居建材";
    } else {
        self.naviView.title = @"装修工人";
    }
    [self.naviView addLeftBarItemImageName:@"knb_back_black" target:self sel:@selector(backAction)];
    self.view.backgroundColor = [UIColor knBgColor];
    self.knbTableView.tableHeaderView = self.headerView;
    
}

- (void)addUI {
    [self.view addSubview:self.knbTableView];
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
    KNBHomeRecommendSubTableViewCell *cell = [KNBHomeRecommendSubTableViewCell cellWithTableView:tableView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [KNBHomeRecommendSubTableViewCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KNBHomeCompanyDetailViewController *detailVC = [[KNBHomeCompanyDetailViewController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
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
- (KNBHomeCompanyListHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:@"KNBHomeCompanyListHeaderView" owner:nil options:nil].lastObject;
        _headerView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, 50);
    }
    return _headerView;
}

@end
