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
#import "KNBSearchView.h"
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

static CGFloat const kHeaderViewHeight = 50.0f;

@interface HomeViewController ()<SDCycleScrollViewDelegate,KNBHomeTableViewDelegate>
// 轮播图
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
// 轮播图数据
@property (nonatomic, strong) NSArray *bannerArray;
//搜索
@property (nonatomic, strong) KNBSearchView *searchView;
//主tableview
@property (strong ,nonatomic) KNBHomeTableView *mainTableView;
//子 scrollview
@property (strong ,nonatomic) KNBHomeSubView *subView;
//子 scrollview 的顶部选择
@property (strong ,nonatomic) HMSegmentedControl *segmentedControl;
//分类数据
@property (nonatomic, strong) NSArray *categoryArray;
//标题数据
@property (nonatomic, strong) NSArray *titleArray;
//服务商数据
@property (nonatomic, strong) NSArray *serviceArray;
@end

@implementation HomeViewController
#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configuration];
    
    [self addUI];
        
}

#pragma mark - Utils
- (void)configuration {
    self.view.backgroundColor = [UIColor knBgColor];
    [self.naviView removeFromSuperview];
}

- (void)addUI {
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.searchView];
    [self.view bringSubviewToFront:self.searchView];
    self.searchView.backgroundColor=[[UIColor colorWithHex:0x0096e6] colorWithAlphaComponent:0];
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
            weakSelf.mainTableView.tableHeaderView = weakSelf.cycleScrollView;
            [weakSelf.mainTableView reloadData];
        } else {
            [weakSelf requestSuccess:NO requestEnd:NO];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [weakSelf requestSuccess:NO requestEnd:NO];
    }];
    
    KNBRecruitmentTypeApi *typeApi = [[KNBRecruitmentTypeApi alloc] init];
    typeApi.hudString = @"";
    [typeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            NSDictionary *dic = request.responseObject[@"list"];
            NSArray *modelArray = [KNBRecruitmentTypeModel changeResponseJSONObject:dic];
            weakSelf.categoryArray = modelArray;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf serviceListRequest:0];
                [weakSelf.mainTableView reloadData];
            });
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
        cell = [KNBHomeCategoryTableViewCell cellWithTableView:tableView dataSource:self.categoryArray];
        KNBHomeCategoryTableViewCell *blockCell = (KNBHomeCategoryTableViewCell *)cell;
        [blockCell reloadCollectionView];
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
    } else if (indexPath.section == 1) {
        cell = [KNBHomeDesignSketchTableViewCell cellWithTableView:tableView];
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
        return isNullArray(self.categoryArray) ? CGFLOAT_MIN : self.subView.bounds.size.height + 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
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

// !!!: 悬停的位置
-(CGFloat)homeTableViewHeightForStayPosition:(KNBHomeTableView *)tableView{
    return [tableView rectForSection:2].origin.y - KNB_NAV_HEIGHT;
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

- (void)serviceListRequest:(NSInteger)index {
    KNBRecruitmentServiceListApi *serviceApi = [[KNBRecruitmentServiceListApi alloc] initWithLng:[KNGetUserLoaction shareInstance].lng lat:[KNGetUserLoaction shareInstance].lat];
    KNBRecruitmentTypeModel *model = self.categoryArray[index];
    serviceApi.cat_parent_id = [model.typeId integerValue];
    serviceApi.page = 1;
    serviceApi.limit = 10;
    KNB_WS(weakSelf);
    [serviceApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (serviceApi.requestSuccess) {
            NSDictionary *dic = request.responseObject[@"list"];
            NSArray *modelArray = [KNBHomeServiceModel changeResponseJSONObject:dic];
            self.serviceArray = modelArray;
            [weakSelf.subView reloadTableViewAtIndex:index dataSource:modelArray];
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

-(KNBHomeSubView *)subView{
    if (!_subView) {
        _subView = [[KNBHomeSubView alloc] initWithFrame:CGRectMake(0, 50, KNB_SCREEN_WIDTH, self.mainTableView.frame.size.height-kHeaderViewHeight - KNB_TAB_HEIGHT - 50) index:self.titleArray.count dataSource:self.serviceArray];
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
        _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHex:0x009fe8], NSFontAttributeName : [UIFont systemFontOfSize:15.0]};
        _segmentedControl.selectionIndicatorColor = [UIColor colorWithHex:0x009fe8];
        _segmentedControl.selectionIndicatorHeight = 2.0;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 40);
        _segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 0, 0, 20);
        KNB_WS(weakSelf);
        [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
            if (weakSelf.subView.contentView) {
                [weakSelf serviceListRequest:index];
                [weakSelf.subView.contentView setContentOffset:CGPointMake(KNB_SCREEN_WIDTH*index, 0) animated:YES];
            }
        }];
    }
    return _segmentedControl;
}

-(KNBHomeTableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[KNBHomeTableView alloc] initWithFrame:CGRectMake(0, 0, KNB_SCREEN_WIDTH, KNB_SCREEN_HEIGHT - KNB_TAB_HEIGHT) style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.delegate_StayPosition = self;
        _mainTableView.tableFooterView = [UIView new];
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.type = KNBHomeTableViewTypeMain;
        _mainTableView.tableHeaderView = self.cycleScrollView;
    }
    return _mainTableView;
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

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSArray array];
    }
    return _titleArray;
}
@end
