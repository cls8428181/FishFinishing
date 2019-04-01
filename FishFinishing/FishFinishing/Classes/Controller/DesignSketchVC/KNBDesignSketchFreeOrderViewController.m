//
//  KNBDesignSketchFreeOrderViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/30.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBDesignSketchFreeOrderViewController.h"

@interface KNBDesignSketchFreeOrderViewController ()
//顶部广告图片
@property (nonatomic, strong) UIImageView *adImageView;

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
    
}

- (void)fetchData {
    
}

#pragma mark - tableview delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    <#CellClass#> *model = self.dataArray[indexPath.section];
//    <#CellClass#> *cell = [<#CellClass#> cellWithTableView:tableView];
//    cell.model = model;
//    return cell;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [<#CellClass#> cellHeight];
//}

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

@end
