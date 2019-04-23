//
//  KNBHomeChatDetailViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/19.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeChatDetailViewController.h"

@interface KNBHomeChatDetailViewController ()

@end

@implementation KNBHomeChatDetailViewController

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
    self.naviView.title = @"消息详情";
    [self.naviView addLeftBarItemImageName:@"knb_back_black" target:self sel:@selector(backAction)];
    self.view.backgroundColor = [UIColor knBgColor];
    
}

- (void)addUI {
//    [self.view addSubview:self.knGroupTableView];
}

- (void)fetchData {
    
}

#pragma mark - tableview delegate & dataSource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.dataArray.count;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    <#CellClass#> *model = self.dataArray[indexPath.section];
//    <#CellClass#> *cell = [<#CellClass#> cellWithTableView:tableView];
//    cell.model = model;
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [<#CellClass#> cellHeight];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 10;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}

#pragma mark - Event Response
/*
 *  所有button、gestureRecognizer的响应事件都放在这个区域里面，不要到处乱放。
 */
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getters And Setters
/* getter和setter全部都放在最后*/



@end
