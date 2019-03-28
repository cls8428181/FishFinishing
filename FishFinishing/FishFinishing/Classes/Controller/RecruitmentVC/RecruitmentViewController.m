//
//  RecruitmentViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/26.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "RecruitmentViewController.h"
//views
#import "KNBHomeCategoryTableViewCell.h"
#import "KNBHomeRecommendTableViewCell.h"

@interface RecruitmentViewController ()

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
}

#pragma mark - Utils
- (void)configuration {
    self.naviView.title = @"商家入驻";
    self.naviView.titleNaviLabel.textColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor knBgColor];
}

- (void)addUI {
    [self.view addSubview:self.knbTableView];
}

- (void)fetchData {
    
}

#pragma mark - tableview delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        KNBHomeCategoryTableViewCell *cell = [KNBHomeCategoryTableViewCell cellWithTableView:tableView];
        return cell;
    } else {
        KNBHomeRecommendTableViewCell *cell = [KNBHomeRecommendTableViewCell cellWithTableView:tableView];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [KNBHomeCategoryTableViewCell cellHeight];
    } else {
        return [KNBHomeRecommendTableViewCell cellHeight];
    }
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

#pragma mark - Getters And Setters
/* getter和setter全部都放在最后*/
@end
