//
//  HomeViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/26.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "HomeViewController.h"
//views
#import "SDCycleScrollView.h"
#import "KNBHomeCategoryTableViewCell.h"
#import "KNBHomeDesignSketchTableViewCell.h"
#import "KNBHomeRecommendTableViewCell.h"
#import "KNBHomeSectionView.h"
//controllers
#import "KNBLoginViewController.h"
#import "AppDelegate.h"

@interface HomeViewController ()<SDCycleScrollViewDelegate>
// 轮播图
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
// 轮播图数据
@property (nonatomic, strong) NSArray *bannerArray;

@end

@implementation HomeViewController
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
    self.view.backgroundColor = [UIColor knBgColor];
    [self.naviView removeFromSuperview];
    self.cycleScrollView.imageURLStringsGroup = @[@"knb_home_banner",@"knb_home_banner",@"knb_home_banner"];
}

- (void)addUI {
    [self.view addSubview:self.knbTableView];
    self.knbTableView.tableHeaderView = self.cycleScrollView;
    self.knbTableView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, KNB_SCREEN_HEIGHT - KNB_TAB_HEIGHT);
}

- (void)fetchData {
    
}

#pragma mark - tableview delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [KNBHomeCategoryTableViewCell cellWithTableView:tableView];
    } else if (indexPath.section == 1) {
        cell = [KNBHomeDesignSketchTableViewCell cellWithTableView:tableView];
    } else {
        cell = [KNBHomeRecommendTableViewCell cellWithTableView:tableView];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [KNBHomeCategoryTableViewCell cellHeight];
    } else if (indexPath.section == 1) {
        return [KNBHomeDesignSketchTableViewCell cellHeight];
    } else {
        return [KNBHomeRecommendTableViewCell cellHeight];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 10 : 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) return nil;
    KNBHomeSectionView *sectionView = [[KNBHomeSectionView alloc] init];
    if (section == 1) {
        sectionView.titleLabel.text = @"效果图";
    }
    if (section == 2) {
        sectionView.titleLabel.text = @"附近装修推荐";
    }
    return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    KNBLoginViewController *loginVC = [[KNBLoginViewController alloc] init];
    loginVC.vcType = KNBLoginTypeLogin;
    [self.navigationController pushViewController:loginVC animated:YES];
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
- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KNB_SCREEN_WIDTH, KNB_SCREEN_WIDTH * 245 / 375) delegate:nil placeholderImage:[UIImage imageNamed:@"knb_home_banner"]];
        _cycleScrollView.delegate = self;
        _cycleScrollView.backgroundColor = [UIColor whiteColor];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.pageDotColor = [UIColor whiteColor];
        _cycleScrollView.currentPageDotColor = KNB_RGB(255, 94, 132);
        _cycleScrollView.autoScrollTimeInterval = 3.5f;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
    }
    return _cycleScrollView;
}

- (void)setBannerArray:(NSArray *)bannerArray{
    if (_bannerArray != bannerArray) {
        _bannerArray = bannerArray;
    }
}
@end
