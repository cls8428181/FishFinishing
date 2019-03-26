//
//  HomeViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/26.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "HomeViewController.h"
#import "SDCycleScrollView.h"

@interface HomeViewController ()<SDCycleScrollViewDelegate>
// 轮播图
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
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
    self.cycleScrollView.imageURLStringsGroup = @[@"https://b-ssl.duitang.com/uploads/item/201601/06/20160106063007_B35dz.jpeg",@"https://b-ssl.duitang.com/uploads/item/201601/06/20160106063007_B35dz.jpeg",@"https://b-ssl.duitang.com/uploads/item/201601/06/20160106063007_B35dz.jpeg"];
}

- (void)addUI {
    [self.view addSubview:self.knbTableView];
    self.knbTableView.tableHeaderView = self.cycleScrollView;
    self.knbTableView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, KNB_SCREEN_HEIGHT);
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
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.backgroundColor = [UIColor redColor];
//    <#CellClass#> *model = self.dataArray[indexPath.section];
//    <#CellClass#> *cell = [<#CellClass#> cellWithTableView:tableView];
//    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
//    KNBQuestionADListModel *bannerModel = self.bannerArray[index];
//    // GROWING: 视频首页banner
//    [[KNBGroManager shareInstance] bannerClickMessage:bannerModel position:index bannerPlace:KNBBannerPlaceTypeCourseHome];
//    if (!isNullStr(bannerModel.ad_url)) {
//        KNWebViewController *webVC = [[KNWebViewController alloc] init];
//        webVC.shareButtonHidden = bannerModel.is_share != 0;
//        webVC.urlString = bannerModel.ad_url;
//        [self.navigationController pushViewController:webVC animated:YES];
//    }
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
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KNB_SCREEN_WIDTH, KNB_SCREEN_WIDTH * 334 / 750) delegate:nil placeholderImage:[UIImage imageNamed:@"placeholder_icon_find"]];
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
//        _bannerArray = bannerArray;
//        [self.bannerUrlArray removeAllObjects];
//        for (KNBQuestionADListModel *model in bannerArray) {
//            [self.bannerUrlArray addObject:model.ad_pic];
//        }
//        self.cycleScrollView.imageURLStringsGroup = self.bannerUrlArray;
        self.cycleScrollView.imageURLStringsGroup = @[@"https://b-ssl.duitang.com/uploads/item/201601/06/20160106063007_B35dz.jpeg",@"https://b-ssl.duitang.com/uploads/item/201601/06/20160106063007_B35dz.jpeg",@"https://b-ssl.duitang.com/uploads/item/201601/06/20160106063007_B35dz.jpeg"];
    }
}
@end
