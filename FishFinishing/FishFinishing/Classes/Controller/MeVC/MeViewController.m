//
//  MeViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/26.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "MeViewController.h"

@interface MeViewController ()

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
    self.naviView.title = @"我的";
    self.naviView.titleNaviLabel.textColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor knBgColor];
    
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
//    <#CellClass#> *model = self.dataArray[indexPath.section];
//    <#CellClass#> *cell = [<#CellClass#> cellWithTableView:tableView];
//    cell.model = model;
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    NSDictionary *dic = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.text = dic[@"title"];
    cell.imageView.image = KNBImages(dic[@"imageName"]);
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

#pragma mark - Getters And Setters
/* getter和setter全部都放在最后*/

@end
