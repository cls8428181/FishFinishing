//
//  KNBHomeCompanyListViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/8.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeCompanyListViewController.h"
#import "KNBHomeRecommendSubTableViewCell.h"
#import "KNBHomeCompanyListHeaderView.h"
#import "KNBHomeCompanyDetailViewController.h"
#import "KNBRecruitmentServiceListApi.h"
#import "KNBHomeServiceModel.h"
#import "KNBCompanyListTagsView.h"
#import "CQTopBarViewController.h"
#import "KNBHomeCompanyStyleViewController.h"
#import "KNBHomeCompanyCityViewController.h"
#import "KNBHomeCompanyOtherViewController.h"
#import "KNBCityModel.h"

@interface KNBHomeCompanyListViewController ()
//header view
@property (nonatomic, strong) KNBHomeCompanyListHeaderView *headerView;
// 空页面
@property (nonatomic, strong) KNBDataEmptySet *emptySet;
@property (nonatomic, strong) CQTopBarViewController *topBar;
@property (nonatomic, strong) NSArray *cityArray;
@property (nonatomic, strong) KNBRecruitmentServiceListApi *serviceApi;

@end

@implementation KNBHomeCompanyListViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configuration];
    
    [self addUI];
    
    [self fetchData:1];
}

#pragma mark - Utils
- (void)configuration {
    [self.naviView addLeftBarItemImageName:@"knb_back_black" target:self sel:@selector(backAction)];
    self.view.backgroundColor = [UIColor knBgColor];
}

- (void)addUI {
    [self.view addSubview:self.emptySet];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:NSStringFromClass([KNBHomeCompanyStyleViewController class]) object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:NSStringFromClass([KNBHomeCompanyCityViewController class]) object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:NSStringFromClass([KNBHomeCompanyOtherViewController class]) object:nil];
    self.topBar.model = self.model;
    for (KNBCityModel *provinceModel in self.cityArray) {
        for (KNBCityModel *cityModel in provinceModel.cityList) {
            if ([cityModel.name isEqual:[KNGetUserLoaction shareInstance].cityName]) {
                self.topBar.areaId = [cityModel.code integerValue];
            }
        }
    }
    [self addChildViewController:self.topBar];
    [self.view addSubview:self.topBar.view];
    [self.topBar.footerView addSubview:self.knbTableView];
    self.knbTableView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, KNB_SCREEN_HEIGHT - KNB_NAV_HEIGHT - 50);
    [self.view bringSubviewToFront:self.naviView];
    
    KNB_WS(weakSelf);
    [self addMJRefreshHeadView:^(NSInteger page) {
        [weakSelf fetchData:page];
    }];
    [self addMJRefreshFootView:^(NSInteger page) {
        [weakSelf fetchData:page];
    }];
}

- (void)InfoNotificationAction:(NSNotification *)notification{
    if ([notification.userInfo[@"index"] isEqualToString:@"0"]) {
        if ([notification.userInfo[@"text"] isEqualToString:@"全部"]) {
            [self.topBar topBarReplaceObjectsAtIndexes:[notification.userInfo[@"index"] integerValue] withObjects:[self.model.catName isEqualToString:@"装修工人"] ? @"工种" : @"风格"];

            self.serviceApi.cat_id = 0;
        } else {
            [self.topBar topBarReplaceObjectsAtIndexes:[notification.userInfo[@"index"] integerValue] withObjects:notification.userInfo[@"text"]];
            for (KNBRecruitmentTypeModel *model in self.model.childList) {
                if ([model.catName isEqualToString:notification.userInfo[@"text"]]) {
                    self.serviceApi.cat_id = [model.typeId integerValue];
                }
            }
        }
    } else if ([notification.userInfo[@"index"] isEqualToString:@"1"]) {
        if ([notification.userInfo[@"text"] isEqualToString:@"全部"]) {
            [self.topBar topBarReplaceObjectsAtIndexes:[notification.userInfo[@"index"] integerValue] withObjects:@"区域"];

            self.serviceApi.area_name = @"";
        } else {
            [self.topBar topBarReplaceObjectsAtIndexes:[notification.userInfo[@"index"] integerValue] withObjects:notification.userInfo[@"text"]];

            self.serviceApi.area_name = notification.userInfo[@"text"];
        }
    } else {
        [self.topBar topBarReplaceObjectsAtIndexes:[notification.userInfo[@"index"] integerValue] withObjects:notification.userInfo[@"text"]];
        if ([notification.userInfo[@"text"] isEqualToString:@"预约数量"]) {
            self.serviceApi.order = 1;
        } else {
            self.serviceApi.order = 2;
        }
    }
    [self fetchData:1];
}

- (void)fetchData:(NSInteger)page {

    KNB_WS(weakSelf);
    self.serviceApi.page = page;
    [self.serviceApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (weakSelf.serviceApi.requestSuccess) {
            NSDictionary *dic = request.responseObject[@"list"];
            NSArray *modelArray = [KNBHomeServiceModel changeResponseJSONObject:dic];
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

#pragma mark - tableview delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.emptySet.dataArray = self.dataArray;
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KNBHomeServiceModel *model = self.dataArray[indexPath.row];
    KNBHomeRecommendSubTableViewCell *cell = [KNBHomeRecommendSubTableViewCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [KNBHomeRecommendSubTableViewCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KNBHomeServiceModel *model = self.dataArray[indexPath.row];
    KNBHomeCompanyDetailViewController *detailVC = [[KNBHomeCompanyDetailViewController alloc] init];
    detailVC.isEdit = NO;
    detailVC.model = model;
    detailVC.naviView.title = self.naviView.title;
    [self.navigationController pushViewController:detailVC animated:YES];
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
- (void)setModel:(KNBRecruitmentTypeModel *)model {
    _model = model;
    self.naviView.title = model.catName;
    if ([model.catName isEqualToString:@"装修工人"]) {
        self.topBar.sectionTitles = @[@"工种",@"区域",@"其他"];
    } else {
        self.topBar.sectionTitles = @[@"类型",@"区域",@"其他"];
    }
    if ([model.catName isEqualToString:@"设计师"]) {
        self.headerView.middleButton.hidden = YES;
    }
}

- (KNBDataEmptySet *)emptySet {
    if (!_emptySet) {
        _emptySet = [[KNBDataEmptySet alloc] init];
        _emptySet.noticeImage = [UIImage imageNamed:@"knb_icon_logo"];
        _emptySet.noticeString = @"什么都木有搜到";
        _emptySet.hidden = YES;
    }
    return _emptySet;
}

- (NSArray *)cityArray {
    if (!_cityArray) {
        NSString *filePath =[[NSBundle mainBundle] pathForResource:@"KNBCity" ofType:@"plist"];
        NSArray *dataSource = [NSArray arrayWithContentsOfFile:filePath];
        _cityArray = [KNBCityModel changeResponseJSONObject:dataSource];
    }
    return _cityArray;
}

- (KNBRecruitmentServiceListApi *)serviceApi {
    if (!_serviceApi) {
        _serviceApi = [[KNBRecruitmentServiceListApi alloc] initWithLng:[KNGetUserLoaction shareInstance].currentLng lat:[KNGetUserLoaction shareInstance].currentLat];
        _serviceApi.cat_parent_id = [self.model.typeId integerValue];
        _serviceApi.page = 1;
        _serviceApi.limit = 10;
        _serviceApi.hudString = @"";
    }
    return _serviceApi;
}

- (CQTopBarViewController *)topBar {
    if (!_topBar) {
        _topBar = [[CQTopBarViewController alloc] init];
        _topBar.segmentFrame = CGRectMake(0, KNB_NAV_HEIGHT, KNB_SCREEN_WIDTH, 50);
        _topBar.pageViewClasses = @[[KNBHomeCompanyStyleViewController class],[KNBHomeCompanyCityViewController class],[KNBHomeCompanyOtherViewController class]];
        _topBar.segmentlineColor = [UIColor whiteColor];
        _topBar.segmentImage = @"knb_home_icon_down";
        _topBar.selectSegmentImage = @"knb_home_icon_up";
        _topBar.selectedTitleTextColor = [UIColor colorWithHex:0x0096e6];
    }
    return _topBar;
}

@end
