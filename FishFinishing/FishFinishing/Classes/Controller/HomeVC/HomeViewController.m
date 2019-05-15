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
#import "KNBHomeSectionView.h"
#import "KNBHomeSearchView.h"
#import "KNBHomeTableView.h"
#import "KNBHomeSubView.h"
#import <HMSegmentedControl.h>
//controllers
#import "KNBHomeOfferViewController.h"
#import "KNBHomeDesignViewController.h"
#import "KNBLoginViewController.h"
#import "KNBHomeCompanyDetailViewController.h"
#import "KNBHomeCompanyListViewController.h"
#import "KNBHomeBannerApi.h"
#import "KNBHomeBannerModel.h"
#import "KNBRecruitmentTypeApi.h"
#import "KNBRecruitmentTypeModel.h"
#import "KNBRecruitmentServiceListApi.h"
#import "KNBHomeServiceModel.h"
#import "KNBHomeChatViewController.h"
#import "KNBHomeRecommendCaseApi.h"
#import "KNBHomeRecommendCaseModel.h"
#import "KNBSearchViewController.h"
#import "KNBOrderStyleApi.h"
#import "KNBOrderUnitApi.h"
#import "KNBOrderAreaRangeApi.h"
#import <AFNetworking.h>
#import "KNBMeAboutViewController.h"

static CGFloat const kHeaderViewHeight = 50.0f;

@interface HomeViewController ()<SDCycleScrollViewDelegate,KNBHomeTableViewDelegate>
// 轮播图
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
// 轮播图数据
@property (nonatomic, strong) NSArray *bannerArray;
//搜索
@property (nonatomic, strong) KNBHomeSearchView *searchView;
//主tableview
@property (strong ,nonatomic) KNBHomeTableView *mainTableView;
//子 scrollview
@property (strong ,nonatomic) KNBHomeSubView *subView;
//子 scrollview 的顶部选择
@property (strong ,nonatomic) HMSegmentedControl *segmentedControl;
//推荐装修案例列表数据
@property (nonatomic, strong) NSMutableArray *recommendCaseArray;
//分类数据
@property (nonatomic, strong) NSArray *categoryArray;
//标题数据
@property (nonatomic, strong) NSArray *titleArray;
//服务商数据
@property (nonatomic, strong) NSArray *serviceArray;
//客服按钮
@property (nonatomic, strong) UIButton *serviceButton;
@end

@implementation HomeViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configuration];
    
    [self addUI];
    //监听网络
    AFNetworkReachabilityManager *netManager = [AFNetworkReachabilityManager sharedManager];
    [netManager startMonitoring];  //开始监听
    [netManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        if ((status == AFNetworkReachabilityStatusReachableViaWWAN)||(status == AFNetworkReachabilityStatusReachableViaWiFi)){
            [self fetchData];
        }
        
    }];

}

#pragma mark - Utils
- (void)configuration {
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.mainTableView.scrollIndicatorInsets = self.mainTableView.contentInset;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [UIColor knBgColor];
    [self.naviView removeFromSuperview];
}

- (void)addUI {
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.searchView];
    [self.view bringSubviewToFront:self.searchView];
    [self.view addSubview:self.serviceButton];
    [self.view bringSubviewToFront:self.serviceButton];
    [self addMJRefreshHeaderView];
    [self addMJRefreshFootView];
}

- (void)addMJRefreshHeaderView {
    KNB_WS(weakSelf);
    MJRefreshNormalHeader *knbTableViewHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.mainTableView.mj_footer resetNoMoreData];
        weakSelf.requestPage = 1;
        [weakSelf fetchData];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    knbTableViewHeader.automaticallyChangeAlpha = YES;
    // 隐藏时间
    knbTableViewHeader.lastUpdatedTimeLabel.hidden = YES;
    
    self.mainTableView.mj_header = knbTableViewHeader;
}

- (void)addMJRefreshFootView {
    KNB_WS(weakSelf);
    MJRefreshBackNormalFooter *tableViewFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.requestPage += 1;
        [weakSelf serviceListRequest:self.segmentedControl.selectedSegmentIndex page:self.requestPage];
    }];
    self.subView.tableView.tableView.mj_footer = tableViewFooter;
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableViewFooter.automaticallyChangeAlpha = YES;
}

- (void)fetchData {
    [LCProgressHUD showLoading:@""];
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
            weakSelf.mainTableView.tableHeaderView = weakSelf.cycleScrollView;
            [weakSelf requestSuccess:YES requestEnd:YES];
        } else {
            [weakSelf requestSuccess:NO requestEnd:NO];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [weakSelf requestSuccess:NO requestEnd:NO];
    }];
    
    //请求推荐装修案例列表
    [self recommendCaseRequest:1];
    
    KNBRecruitmentTypeApi *typeApi = [[KNBRecruitmentTypeApi alloc] init];
    [typeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (typeApi.requestSuccess) {
            NSDictionary *dic = request.responseObject[@"list"];
            NSArray *modelArray = [KNBRecruitmentTypeModel changeResponseJSONObject:dic];
            weakSelf.categoryArray = modelArray;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf serviceListRequest:0 page:1];
            });
            [weakSelf requestSuccess:YES requestEnd:YES];
        } else {
            [weakSelf requestSuccess:NO requestEnd:NO];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [weakSelf requestSuccess:NO requestEnd:NO];
    }];

}

- (void)requestSuccess:(BOOL)success requestEnd:(BOOL)end {
    [self.mainTableView.mj_header endRefreshing];
    
    if (end) {
        [self.mainTableView reloadData];
        return;
    }
    if (!success && self.requestPage > 1) {
        self.requestPage -= 1;
    } else {
        [self.mainTableView reloadData];
    }
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
        cell = [KNBHomeCategoryTableViewCell cellWithTableView:tableView dataSource:self.categoryArray];
        KNBHomeCategoryTableViewCell *blockCell = (KNBHomeCategoryTableViewCell *)cell;
        [blockCell reloadCollectionView];
        //类型按钮的选择
        blockCell.selectItemAtIndexBlock = ^(NSInteger index) {
            if (index == 0) {
                KNBHomeOfferViewController *offerVC = [[KNBHomeOfferViewController alloc] init];
                [weakSelf.navigationController pushViewController:offerVC animated:YES];

            } else {
                KNBRecruitmentTypeModel *model = weakSelf.categoryArray[index - 1];
                KNBHomeCompanyListViewController *workerVC = [[KNBHomeCompanyListViewController alloc] init];
                workerVC.model = model;
                [weakSelf.navigationController pushViewController:workerVC animated:YES];
            }
        };
        //广告图点击
//        blockCell.adButtonBlock = ^{
////            if ([KNBUserInfo shareInstance].isLogin) {
//                KNBHomeOfferViewController *offerVC = [[KNBHomeOfferViewController alloc] init];
//                [weakSelf.navigationController pushViewController:offerVC animated:YES];
////            } else {
////                [KNBAlertRemind alterWithTitle:@"" message:@"您还未登录,请先登录" buttonTitles:@[@"去登录",@"取消"] handler:^(NSInteger index, NSString *title) {
////                    if ([title isEqualToString:@"去登录"]) {
////                        KNBLoginViewController *loginVC = [[KNBLoginViewController alloc] init];
////                        loginVC.vcType = KNBLoginTypeLogin;
////                        [weakSelf presentViewController:loginVC animated:YES completion:nil];
////                    }
////                }];
////            }
//        };
    } else if (indexPath.section == 1) {
        cell = [KNBHomeDesignSketchTableViewCell cellWithTableView:tableView];
        KNBHomeDesignSketchTableViewCell *blockCell = (KNBHomeDesignSketchTableViewCell *)cell;
        blockCell.modelArray = self.recommendCaseArray;
        blockCell.selectIndexBlock = ^(NSInteger index) {
            [weakSelf recommendCaseRequest:index+1];
        };

    } else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"subCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSMutableArray *titleArray = [NSMutableArray array];
        for (KNBRecruitmentTypeModel *model in self.categoryArray) {
            [titleArray addObject:model.catName];
        }
        self.titleArray = titleArray;
        if (!isNullArray(self.titleArray)) {
            [cell addSubview:self.segmentedControl];
            [cell addSubview:self.subView];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [KNBHomeCategoryTableViewCell cellHeight];
    } else if (indexPath.section == 1) {
        return [KNBHomeDesignSketchTableViewCell cellHeight];
    } else {
        return isNullArray(self.categoryArray) ? CGFLOAT_MIN : self.subView.bounds.size.height + 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? CGFLOAT_MIN : 30;
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

// !!!: 悬停的位置
-(CGFloat)homeTableViewHeightForStayPosition:(KNBHomeTableView *)tableView{
    return [tableView rectForSection:2].origin.y;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {

}

#pragma mark - private method
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    // 导航栏处理
//    CGFloat yOffset = scrollView.contentOffset.y;
//    if (yOffset < 0.0) {
//        [UIView animateWithDuration:0.5 animations:^{
//            self.searchView.backgroundColor=[[UIColor colorWithHex:0x0096e6] colorWithAlphaComponent:0];
//        }];
//    } else {
//        [UIView animateWithDuration:0.5 animations:^{
//            self.searchView.backgroundColor=[[UIColor colorWithHex:0x0096e6] colorWithAlphaComponent:1];
//        }];
//    }
//
//    CGFloat maxAlphaOffset = 150;
//    CGFloat alpha = yOffset / (CGFloat)maxAlphaOffset;
//    alpha = (alpha >= 1) ? 1 : alpha;
//    alpha = (alpha <= 0) ? 0 : alpha;
//    self.searchView.backgroundColor=[[UIColor colorWithHex:0x0096e6] colorWithAlphaComponent:alpha];
//}

- (void)serviceListRequest:(NSInteger)index page:(NSInteger)page {
    KNBRecruitmentServiceListApi *serviceApi = [[KNBRecruitmentServiceListApi alloc] initWithLng:[KNGetUserLoaction shareInstance].lng lat:[KNGetUserLoaction shareInstance].lat];
    KNBRecruitmentTypeModel *model = self.categoryArray[index];
    serviceApi.cat_parent_id = [model.typeId integerValue];
    serviceApi.page = page;
    serviceApi.limit = 10;
    KNB_WS(weakSelf);
    [serviceApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (serviceApi.requestSuccess) {
            [LCProgressHUD hide];
            NSDictionary *dic = request.responseObject[@"list"];
            NSArray *modelArray = [KNBHomeServiceModel changeResponseJSONObject:dic];
            self.serviceArray = modelArray;
            [weakSelf.subView reloadTableViewAtIndex:index dataSource:modelArray title:weakSelf.titleArray[index] page:page];
            if (modelArray.count < 10) {
                weakSelf.requestPage = 1;
            }
        } else {
            [weakSelf requestSuccess:NO requestEnd:NO];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [weakSelf requestSuccess:NO requestEnd:NO];
    }];
}

- (void)recommendCaseRequest:(NSInteger)type {
    KNBBaseRequest *api = nil;
    if (type == 1) {
        api = [[KNBOrderStyleApi alloc] init];
    } else if (type == 2) {
        api = [[KNBOrderUnitApi alloc] init];
    } else {
        api = [[KNBOrderAreaRangeApi alloc] init];
    }
    KNB_WS(weakSelf);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            NSDictionary *dic = request.responseObject[@"list"];
            NSArray *modelArray = [KNBHomeRecommendCaseModel changeResponseJSONObject:dic];
            [weakSelf.recommendCaseArray removeAllObjects];
            [weakSelf.recommendCaseArray addObjectsFromArray:modelArray];
            KNBHomeDesignSketchTableViewCell *cell = [weakSelf.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            [cell.collectionView reloadData];
        } else {
            [weakSelf requestSuccess:NO requestEnd:NO];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [weakSelf requestSuccess:NO requestEnd:NO];
    }];
}

#pragma mark - Event Response
/*
 *  所有button、gestureRecognizer的响应事件都放在这个区域里面，不要到处乱放。
 */
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)serviceButtonAction {
    KNBMeAboutViewController *aboutVC = [[KNBMeAboutViewController alloc] init];
    [self.navigationController pushViewController:aboutVC animated:YES];
}

#pragma mark - Getters And Setters
/* getter和setter全部都放在最后*/
- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(13, 13, KNB_SCREEN_WIDTH - 26, 126) delegate:nil placeholderImage:[UIImage imageNamed:@"knb_home_banner"]];
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

-(KNBHomeSubView *)subView{
    if (!_subView) {
        _subView = [[KNBHomeSubView alloc] initWithFrame:CGRectMake(0, 50, KNB_SCREEN_WIDTH, self.mainTableView.frame.size.height - kHeaderViewHeight - 45) index:self.titleArray.count dataSource:self.serviceArray];
        KNB_WS(weakSelf);
        _subView.scrollEventBlock = ^(NSInteger row) {
            weakSelf.segmentedControl.selectedSegmentIndex = row;
        };
    }
    return _subView;
}

- (HMSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:self.titleArray];
        _segmentedControl.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, 50);
        _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:15.0]};
        _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHex:0x009fe8], NSFontAttributeName : [UIFont boldSystemFontOfSize:15.0]};
        _segmentedControl.selectionIndicatorColor = [UIColor colorWithHex:0x009fe8];
        _segmentedControl.selectionIndicatorHeight = 2.0;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 0, -10, 0);
        KNB_WS(weakSelf);
        [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
            if (weakSelf.subView.contentView) {
                [weakSelf serviceListRequest:index page:1];
            }
        }];
    }
    return _segmentedControl;
}

-(KNBHomeTableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[KNBHomeTableView alloc] initWithFrame:CGRectMake(0, KNB_NAV_HEIGHT, KNB_SCREEN_WIDTH, KNB_SCREEN_HEIGHT - KNB_TAB_HEIGHT - KNB_NAV_HEIGHT) style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.delegate_StayPosition = self;
        _mainTableView.tableFooterView = [UIView new];
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.type = KNBHomeTableViewTypeMain;
        _mainTableView.tableHeaderView = self.cycleScrollView;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mainTableView;
}

- (UIButton *)serviceButton {
    if (!_serviceButton) {
        _serviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _serviceButton.frame = CGRectMake(KNB_SCREEN_WIDTH - 40, KNB_SCREEN_HEIGHT - 300, 40, 40);
        [_serviceButton setImage:KNBImages(@"knb_home_kefu") forState:UIControlStateNormal];
        [_serviceButton addTarget:self action:@selector(serviceButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _serviceButton;
}

- (void)setBannerArray:(NSArray *)bannerArray{
    if (_bannerArray != bannerArray) {
        _bannerArray = bannerArray;
    }
}

- (KNBHomeSearchView *)searchView {
    KNB_WS(weakSelf);
    if (!_searchView) {
        _searchView = [[KNBHomeSearchView alloc] initWithFrame:CGRectMake(0, 0, KNB_SCREEN_WIDTH, KNB_NAV_HEIGHT)];
        _searchView.chatButtonBlock = ^{
            KNBHomeChatViewController *chatVC = [[KNBHomeChatViewController alloc] init];
            [weakSelf.navigationController pushViewController:chatVC animated:YES];
        };
        _searchView.touchBlock = ^{
            KNBSearchViewController *searchVC = [[KNBSearchViewController alloc] init];
            [weakSelf.navigationController pushViewController:searchVC animated:YES];
        };
    }
    return _searchView;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSArray array];
    }
    return _titleArray;
}

- (NSMutableArray *)recommendCaseArray {
    if (!_recommendCaseArray) {
        _recommendCaseArray = [NSMutableArray array];
    }
    return _recommendCaseArray;
}
@end
