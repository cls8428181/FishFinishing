//
//  DesignSketchViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/26.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "DesignSketchViewController.h"
//views
#import "KNBDesignSketchCollectionViewCell.h"
#import "KNBDesignSketchCollectionSectionView.h"
#import "KNBRecruitmentCaseListApi.h"
//controllers
#import "KNBDesignSketchDetailViewController.h"
#import "KNBDesignSketchModel.h"
#import "CQTopBarViewController.h"
#import "KNBHomeCompanyTagsViewController.h"
#import "KNBHomeCompanyHouseViewController.h"
#import "KNBHomeCompanyAreaViewController.h"
#import "KNBHomeRecommendCaseModel.h"

@interface DesignSketchViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
//滑动区域
@property (nonatomic, strong) UICollectionView *collectionView;
//顶部下拉筛选
@property (nonatomic, strong) KNBDesignSketchCollectionSectionView *sectionView;
@property (nonatomic, strong) CQTopBarViewController *topBar;
//网络请求
@property (nonatomic, strong) KNBRecruitmentCaseListApi *api;

@end

@implementation DesignSketchViewController

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchData:1];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configuration];
    
    [self addUI];
    
    [self settingConstraints];
    
}

#pragma mark - Setup UI Constraints
/*
 *  在这里添加UIView的约束布局相关代码
 */
- (void)settingConstraints {
    KNB_WS(weakSelf);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.naviView.mas_bottom).mas_offset(0);
    }];
}

#pragma mark - Utils
- (void)configuration {
    self.naviView.title = @"装修效果图";
    if (self.isTabbar) {
        [self.naviView removeLeftBarItem];
    }
    self.naviView.titleNaviLabel.textColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor knBgColor];
    
    if (self.isTabbar) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TagsNotificationAction:) name:@"DesignSketchViewController" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HouseNotificationAction:) name:NSStringFromClass([KNBHomeCompanyHouseViewController class]) object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AreaNotificationAction:) name:NSStringFromClass([KNBHomeCompanyAreaViewController class]) object:nil];
        
        [self addChildViewController:self.topBar];
        [self.view addSubview:self.topBar.view];
        [self.topBar.footerView addSubview:self.collectionView];
        [self.view bringSubviewToFront:self.naviView];
        self.topBar.footerView.frame = CGRectMake(0, KNB_NAV_HEIGHT + 50, KNB_SCREEN_WIDTH, KNB_SCREEN_HEIGHT - KNB_NAV_HEIGHT - KNB_TAB_HEIGHT - 50);
        self.collectionView.frame = CGRectMake(0, KNB_NAV_HEIGHT + 50, KNB_SCREEN_WIDTH, KNB_SCREEN_HEIGHT - KNB_NAV_HEIGHT - KNB_TAB_HEIGHT- 50);

    } else {
        [self.view addSubview:self.collectionView];
        self.collectionView.frame = CGRectMake(0, KNB_NAV_HEIGHT, KNB_SCREEN_WIDTH, KNB_SCREEN_HEIGHT - KNB_NAV_HEIGHT);
    }
  
    
}

- (void)addUI {
    KNB_WS(weakSelf);
    [self addMJRefreshHeadView:^(NSInteger page) {
        [weakSelf fetchData:page];
    }];
    [self addMJRefreshFootView:^(NSInteger page) {
    }];
}

- (void)fetchData:(NSInteger)page {
    KNB_WS(weakSelf);
    self.api.page = page;
    [self.api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (weakSelf.api.requestSuccess) {
            NSDictionary *dic = request.responseObject[@"list"];
            NSArray *modelArray = [KNBDesignSketchModel changeResponseJSONObject:dic];
            if (page == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            [weakSelf.dataArray addObjectsFromArray:modelArray];
            [weakSelf requestSuccess:YES requestEnd:modelArray.count == 0];

        } else {
            [weakSelf requestSuccess:NO requestEnd:NO];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [weakSelf requestSuccess:NO requestEnd:NO];
    }];
}

- (void)requestSuccess:(BOOL)success requestEnd:(BOOL)end {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    
    if (end) {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        [self.collectionView reloadData];
        return;
    }
    if (!success && self.requestPage > 1) {
        self.requestPage -= 1;
    } else {
        [self.collectionView reloadData];
    }
}

- (void)addMJRefreshHeadView:(KNMJHeaderLoadCompleteBlock)completeBlock {
    KNB_WS(weakSelf);
    MJRefreshNormalHeader *knbTableViewHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.collectionView.mj_footer resetNoMoreData];
        weakSelf.requestPage = 1;
        if (completeBlock) {
            completeBlock(1);
        }
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    knbTableViewHeader.automaticallyChangeAlpha = YES;
    // 隐藏时间
    knbTableViewHeader.lastUpdatedTimeLabel.hidden = YES;
    self.collectionView.mj_header = knbTableViewHeader;
}

- (void)addMJRefreshFootView:(KNMJFooterLoadCompleteBlock)completeBlock {
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)loadMoreData {
    self.requestPage += 1;
    [self fetchData:self.requestPage];
}

#pragma mark - collectionview delegate & dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
//每一个cell是什么
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KNBDesignSketchModel *model = self.dataArray[indexPath.row];
    KNBDesignSketchCollectionViewCell *cell = [KNBDesignSketchCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    cell.model = model;
    return cell;
}
//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(170, 192);
}

//cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    KNBDesignSketchModel *model = self.dataArray[indexPath.row];
    KNBDesignSketchDetailViewController *detailVC = [[KNBDesignSketchDetailViewController alloc] init];
    detailVC.model = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - Event Response
/*
 *  所有button、gestureRecognizer的响应事件都放在这个区域里面，不要到处乱放。
 */
- (void)TagsNotificationAction:(NSNotification *)notification {
    KNBRecruitmentTypeModel *model = notification.userInfo[@"model"];
    [self.topBar topBarReplaceObjectsAtIndexes:0 withObjects:model.catName];
    if ([model.catName isEqualToString:@"全部"]) {
        self.api.style_id = 0;
    } else {
        self.api.style_id = [model.typeId integerValue];
    }
    [self fetchData:1];
}

- (void)HouseNotificationAction:(NSNotification *)notification {
    KNBRecruitmentUnitModel *model = notification.userInfo[@"model"];
    [self.topBar topBarReplaceObjectsAtIndexes:1 withObjects:isNullStr(model.catName) ? model.name : model.catName];
    self.api.apartment_id = [model.houseId integerValue];
    [self fetchData:1];
}

- (void)AreaNotificationAction:(NSNotification *)notification {
    KNBHomeRecommendCaseModel *model = notification.userInfo[@"model"];
    [self.topBar topBarReplaceObjectsAtIndexes:2 withObjects:model.name];
    if ([model.name isEqualToString:@"全部"]) {
        self.api.min_area = 0;
        self.api.max_area = 9999;
    } else {
        self.api.min_area = [model.min_area doubleValue];
        self.api.max_area = [model.max_area doubleValue];
    }
    [self fetchData:1];
}


#pragma mark - Getters And Setters
/* getter和setter全部都放在最后*/
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        if (self.isTabbar) {
            layout.headerReferenceSize = CGSizeMake(KNB_SCREEN_WIDTH, 50); //头视图的大小
            layout.footerReferenceSize = CGSizeMake(KNB_SCREEN_WIDTH, KNB_TAB_HEIGHT); //底部视图的大小
        }
        layout.sectionInset = UIEdgeInsetsMake(10, 12, 10, 12);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"KNBDesignSketchCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"KNBDesignSketchCollectionViewCell"];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;
}

- (KNBRecruitmentCaseListApi *)api {
    KNB_WS(weakSelf);
    if (!_api) {
        _api = [[KNBRecruitmentCaseListApi alloc] init];
        _api.hudString = @"";
        _api.style_id = weakSelf.style_id ?: 0;
        _api.apartment_id = weakSelf.apartment_id ?: 0;
        _api.min_area = weakSelf.min_area ?: 0;
        _api.max_area = weakSelf.max_area ?: 9999;
    }
    _api.city_name = [KNGetUserLoaction shareInstance].cityName;
    return _api;
}

- (CQTopBarViewController *)topBar {
    if (!_topBar) {
        _topBar = [[CQTopBarViewController alloc] init];
        _topBar.segmentFrame = CGRectMake(0, KNB_NAV_HEIGHT, KNB_SCREEN_WIDTH, 50);
        _topBar.sectionTitles = @[@"风格",@"户型",@"面积"];
        _topBar.pageViewClasses = @[[KNBHomeCompanyTagsViewController class],[KNBHomeCompanyHouseViewController class],[KNBHomeCompanyAreaViewController class]];
        _topBar.isDesign = YES;
        _topBar.segmentlineColor = [UIColor whiteColor];
        _topBar.segmentImage = @"knb_home_icon_down";
        _topBar.selectSegmentImage = @"knb_home_icon_up";
        _topBar.selectedTitleTextColor = [UIColor colorWithHex:0x0096e6];
    }
    return _topBar;
}

@end
