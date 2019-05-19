//
//  KNBHomeSubTableView.m
//  FishFinishing
//
//  Created by apple on 2019/4/18.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBHomeSubTableView.h"
#import "KNBHomeRecommendSubTableViewCell.h"
#import "KNBHomeServiceModel.h"
#import "KNBOrderFooterView.h"
#import "KNBHomeCompanyDetailViewController.h"
#import "KNBHomeCompanyListViewController.h"

@interface KNBHomeSubTableView ()
// 空页面
@property (nonatomic, strong) KNBDataEmptySet *emptySet;
@property (nonatomic, strong) KNBOrderFooterView *footerView;
@end

@implementation KNBHomeSubTableView

- (instancetype)initWithFrame:(CGRect)frame dataSource:(nonnull NSArray *)dataSrouce
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.dataArray removeAllObjects];
        self.tableView.frame = self.bounds;
        [self.dataArray addObjectsFromArray:dataSrouce];
        [self addSubview:self.tableView];
        [self addSubview:self.emptySet];
    }
    return self;
}


-(KNBHomeTableView *)tableView {
    if (!_tableView) {
        _tableView = [[KNBHomeTableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.type = KNBHomeTableViewTypeSub;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
//        _tableView.tableFooterView = self.footerView;
    }
    return _tableView;
}

#pragma mark - tableviewe delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    self.emptySet.dataArray = self.dataArray;
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KNBHomeServiceModel *model = self.dataArray[indexPath.section];
    KNBHomeRecommendSubTableViewCell *cell = [KNBHomeRecommendSubTableViewCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [KNBHomeRecommendSubTableViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KNBHomeServiceModel *model = self.dataArray[indexPath.section];
    KNBHomeCompanyDetailViewController *detailVC = [[KNBHomeCompanyDetailViewController alloc] init];
    detailVC.isEdit = NO;
    detailVC.model = model;
    detailVC.naviView.title = self.title;
    [[[self getCurrentViewController] navigationController] pushViewController:detailVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {if ([next isKindOfClass:[UIViewController class]]) {
        return (UIViewController *)next;
    }
        next = [next nextResponder];
    } while (next !=nil);
    return nil;
}


- (void)reloadTableView:(NSArray *)dataSource page:(NSInteger)page {
    [self.tableView.mj_footer resetNoMoreData];
    if (page == 1) {
        [self.dataArray removeAllObjects];
        [self.tableView scrollRectToVisible:CGRectMake(0,0,1,1) animated:YES];
        [self.tableView setContentOffset:CGPointZero animated:YES];
    }
    [self.dataArray addObjectsFromArray:dataSource];
    if (dataSource.count == 0) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.tableView reloadData];
}

- (KNBDataEmptySet *)emptySet {
    if (!_emptySet) {
        _emptySet = [[KNBDataEmptySet alloc] init];
        _emptySet.noticeImage = [UIImage imageNamed:@"knb_icon_logo"];
        _emptySet.noticeString = @"什么都木有搜到";
        _emptySet.hidden = YES;
        _emptySet.center = CGPointMake(KNB_SCREEN_WIDTH/2, 200);
    }
    return _emptySet;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
//
//- (KNBOrderFooterView *)footerView {
//    KNB_WS(weakSelf);
//    if (!_footerView) {
//        _footerView = [[KNBOrderFooterView alloc] initWithButtonTitle:@"查看更多"];
//        _footerView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, 50);
//        _footerView.enterButtonBlock = ^{
//            KNBHomeCompanyListViewController *listVC = [[KNBHomeCompanyListViewController alloc] init];
//            KNBRecruitmentTypeModel *model = [[KNBRecruitmentTypeModel alloc] init];
//            model.catName = @"装修公司";
//            model.typeId = @"1";
//            listVC.model = model;
//            [[[weakSelf getCurrentViewController] navigationController] pushViewController:listVC animated:YES];
//        };
//    }
//    return _footerView;
//}

@end
