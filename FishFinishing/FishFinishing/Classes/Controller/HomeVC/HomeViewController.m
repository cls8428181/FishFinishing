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
#import "KNBSearchView.h"
//controllers
#import "KNBHomeOfferViewController.h"
#import "KNBHomeDesignViewController.h"
#import "KNBLoginViewController.h"
#import "KNBHomeCompanyDetailViewController.h"
#import "KNBHomeCompanyListViewController.h"
#import "KNBHomeBannerApi.h"
#import "KNBHomeBannerModel.h"


@interface HomeViewController ()<SDCycleScrollViewDelegate>
// 轮播图
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
// 轮播图数据
@property (nonatomic, strong) NSArray *bannerArray;
//搜索
@property (nonatomic, strong) KNBSearchView *searchView;
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
}

- (void)addUI {
    [self.view addSubview:self.knbTableView];
    [self.view addSubview:self.searchView];
    [self.view bringSubviewToFront:self.searchView];
    self.searchView.backgroundColor=[[UIColor colorWithHex:0x0096e6] colorWithAlphaComponent:0];
    self.knbTableView.tableHeaderView = self.cycleScrollView;
    self.knbTableView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, KNB_SCREEN_HEIGHT - KNB_TAB_HEIGHT);
}

- (void)fetchData {
    KNBHomeBannerApi *api = [[KNBHomeBannerApi alloc] initWithVari:@"index_banner" cityName:[KNGetUserLoaction shareInstance].cityName];
    KNB_WS(weakSelf);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            NSArray *modelArray = [KNBHomeBannerModel changeResponseJSONObject:request.responseObject[@"list"]];
            NSMutableArray *tempArray = [NSMutableArray array];
            for (KNBHomeBannerModel *model in modelArray) {
                [tempArray addObject:model.img];
            }
            weakSelf.cycleScrollView.imageURLStringsGroup = tempArray;
            weakSelf.knbTableView.tableHeaderView = weakSelf.cycleScrollView;
            [weakSelf requestSuccess:YES requestEnd:YES];
        } else {
            [weakSelf requestSuccess:NO requestEnd:NO];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [weakSelf requestSuccess:NO requestEnd:NO];
    }];
}

#pragma mark - tableview delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KNB_WS(weakSelf);
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [KNBHomeCategoryTableViewCell cellWithTableView:tableView];
        KNBHomeCategoryTableViewCell *blockCell = (KNBHomeCategoryTableViewCell *)cell;
        blockCell.offerButtonAction = ^{//量房报价
            KNBHomeOfferViewController *offerVC = [[KNBHomeOfferViewController alloc] init];
            [weakSelf.navigationController pushViewController:offerVC animated:YES];
        };
        blockCell.companyButtonAction = ^{//装修公司
            KNBHomeCompanyListViewController *companyVC = [[KNBHomeCompanyListViewController alloc] init];
            companyVC.VCtype = KNBHomeListTypeCompany;
            [weakSelf.navigationController pushViewController:companyVC animated:YES];
        };
        blockCell.foremanButtonAction = ^{//找工长
            KNBHomeCompanyListViewController *foremanVC = [[KNBHomeCompanyListViewController alloc] init];
            foremanVC.VCtype = KNBHomeListTypeForeman;
            [weakSelf.navigationController pushViewController:foremanVC animated:YES];
        };
        blockCell.designButtonAction = ^{//找设计
            KNBHomeDesignViewController *designVC = [[KNBHomeDesignViewController alloc] init];
            [weakSelf.navigationController pushViewController:designVC animated:YES];
        };
        blockCell.materialButtonAction = ^{//家居建材
            KNBHomeCompanyListViewController *materialVC = [[KNBHomeCompanyListViewController alloc] init];
            materialVC.VCtype = KNBHomeListTypeMaterial;
            [weakSelf.navigationController pushViewController:materialVC animated:YES];
        };
        blockCell.workerButtonAction = ^{//装修工人
            KNBHomeCompanyListViewController *workerVC = [[KNBHomeCompanyListViewController alloc] init];
            workerVC.VCtype = KNBHomeListTypeWorker;
            [weakSelf.navigationController pushViewController:workerVC animated:YES];
        };
    } else if (indexPath.section == 1) {
        cell = [KNBHomeDesignSketchTableViewCell cellWithTableView:tableView];
    } else {
        cell = [KNBHomeRecommendTableViewCell cellWithTableView:tableView];
        KNBHomeRecommendTableViewCell *blockCell = (KNBHomeRecommendTableViewCell *)cell;
        blockCell.didSelectRowAtIndexPath = ^(NSIndexPath * _Nonnull indexPath) {
            KNBHomeCompanyDetailViewController *companyVC = [[KNBHomeCompanyDetailViewController alloc] init];
            [weakSelf.navigationController pushViewController:companyVC animated:YES];
        };

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

#pragma mark - private method
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 导航栏处理
    CGFloat yOffset = scrollView.contentOffset.y;
    if (yOffset < 0.0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.searchView.backgroundColor=[[UIColor colorWithHex:0x0096e6] colorWithAlphaComponent:0];
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.searchView.backgroundColor=[[UIColor colorWithHex:0x0096e6] colorWithAlphaComponent:1];
        }];
    }

    CGFloat maxAlphaOffset = 150;
    CGFloat alpha = yOffset / (CGFloat)maxAlphaOffset;
    alpha = (alpha >= 1) ? 1 : alpha;
    alpha = (alpha <= 0) ? 0 : alpha;
    self.searchView.backgroundColor=[[UIColor colorWithHex:0x0096e6] colorWithAlphaComponent:alpha];
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

- (KNBSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[KNBSearchView alloc] initWithFrame:CGRectMake(0, 0, KNB_SCREEN_WIDTH, KNB_NAV_HEIGHT)];
    }
    return _searchView;
}
@end
