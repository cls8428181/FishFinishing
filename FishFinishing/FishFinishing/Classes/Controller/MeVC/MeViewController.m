//
//  MeViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/26.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "MeViewController.h"
//views
#import "KNBMeHeaderView.h"
#import "KNBMeTableViewCell.h"
#import "KNBHomeCompanyDetailViewController.h"

@interface MeViewController ()
@property (nonatomic, strong) KNBMeHeaderView *headerView;
@end

@implementation MeViewController

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
    [self.naviView removeFromSuperview];
    self.view.backgroundColor = [UIColor knBgColor];
    self.knGroupTableView.tableHeaderView = self.headerView;
    self.knGroupTableView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, KNB_SCREEN_HEIGHT - KNB_TAB_HEIGHT);
    
}

- (void)addUI {
    [self.view addSubview:self.knGroupTableView];
}

- (void)fetchData {
    //解析数据
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"KNBMe" ofType:@"plist"];
    NSMutableArray *dataArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    [self.dataArray removeAllObjects];
    self.dataArray = dataArray;
}

#pragma mark - tableview delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *rowsArray = [self.dataArray objectAtIndex:section];
    return rowsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.section][indexPath.row];
    KNBMeTableViewCell *cell = [KNBMeTableViewCell cellWithTableView:tableView];
    cell.titleLabel.text = dic[@"title"];
    cell.iconImageView.image = KNBImages(dic[@"imageName"]);
    if ([dic[@"title"] isEqualToString:@"我要接单"]) {
        cell.markImageView.hidden = NO;
        cell.rightLabel.hidden = NO;
    } else {
        cell.markImageView.hidden = YES;
        cell.rightLabel.hidden = YES;
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
    if (indexPath.section == 0 && indexPath.row == 0) {
        KNBHomeCompanyDetailViewController *detailVC = [[KNBHomeCompanyDetailViewController alloc] init];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
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
- (KNBMeHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[KNBMeHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, KNB_SCREEN_WIDTH * 170/375 + 140);
    }
    return _headerView;
}

@end
