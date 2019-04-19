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
#import <CQTopBarViewController.h>
#import "KNBHomeCompanyTagsViewController.h"

@interface KNBHomeCompanyListViewController ()
//header view
@property (nonatomic, strong) KNBHomeCompanyListHeaderView *headerView;
// 空页面
@property (nonatomic, strong) KNBDataEmptySet *emptySet;
@property (nonatomic, strong) CQTopBarViewController *topBar;

@end

@implementation KNBHomeCompanyListViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configuration];
    
    [self addUI];
    
    [self fetchData];
}

#pragma mark - Utils
- (void)configuration {
    [self.naviView addLeftBarItemImageName:@"knb_back_black" target:self sel:@selector(backAction)];
    self.view.backgroundColor = [UIColor knBgColor];
//    self.knbTableView.tableHeaderView = self.headerView;
}

- (void)addUI {
    [self.view addSubview:self.emptySet];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:NSStringFromClass([KNBHomeCompanyTagsViewController class]) object:nil];
    self.topBar = [[CQTopBarViewController alloc] init];
    self.topBar.segmentFrame = CGRectMake(0, KNB_NAV_HEIGHT, KNB_SCREEN_WIDTH, 50);
    self.topBar.sectionTitles = @[@"风格",@"区域"];
    self.topBar.pageViewClasses = @[[KNBHomeCompanyTagsViewController class],[KNBHomeCompanyTagsViewController class]];
    self.topBar.segmentlineColor = [UIColor whiteColor];
    self.topBar.segmentImage = @"knb_home_icon_down";
    self.topBar.selectSegmentImage = @"knb_home_icon_up";
    self.topBar.selectedTitleTextColor = [UIColor colorWithHex:0x0096e6];
    [self addChildViewController:self.topBar];
    [self.view addSubview:self.topBar.view];
    [self.topBar.footerView addSubview:self.knbTableView];
    self.knbTableView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, KNB_SCREEN_HEIGHT - KNB_NAV_HEIGHT - 50);
    [self.view bringSubviewToFront:self.naviView];
}

- (void)InfoNotificationAction:(NSNotification *)notification{
    [self.topBar topBarReplaceObjectsAtIndexes:1 withObjects:notification.userInfo[@"text"]];
}

- (void)fetchData {
    KNBRecruitmentServiceListApi *serviceApi = [[KNBRecruitmentServiceListApi alloc] initWithLng:[KNGetUserLoaction shareInstance].lng lat:[KNGetUserLoaction shareInstance].lat];
    serviceApi.cat_parent_id = [self.model.typeId integerValue];
    serviceApi.page = 1;
    serviceApi.limit = 10;
    KNB_WS(weakSelf);
    [serviceApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (serviceApi.requestSuccess) {
            NSDictionary *dic = request.responseObject[@"list"];
            NSArray *modelArray = [KNBHomeServiceModel changeResponseJSONObject:dic];
            [self.dataArray addObjectsFromArray:modelArray];
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
- (KNBHomeCompanyListHeaderView *)headerView {
    KNB_WS(weakSelf);
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:@"KNBHomeCompanyListHeaderView" owner:nil options:nil].lastObject;
        _headerView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, 50);
        _headerView.leftButtonBlock = ^{
            [KNBCompanyListTagsView showTagsPickerWithDataSource:@[@"1",@"2"] superView:weakSelf.headerView resultBlock:^(id selectValue) {
                
            } cancelBlock:^{
                
            }];
        };
        _headerView.middleButtonBlock = ^{
            
        };
    }
    return _headerView;
}

- (void)setModel:(KNBRecruitmentTypeModel *)model {
    _model = model;
    self.naviView.title = model.catName;
    if ([model.catName isEqualToString:@"装修工人"]) {
        [self.headerView.leftButton setTitle:@"工种" forState: UIControlStateNormal];
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

@end
