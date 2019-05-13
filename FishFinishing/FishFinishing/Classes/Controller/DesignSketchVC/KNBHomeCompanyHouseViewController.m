//
//  KNBHomeCompanyHouseViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/22.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeCompanyHouseViewController.h"
#import "KNBChoiceTableViewCell.h"
#import "KNBRecruitmentTypeModel.h"
#import "KNBOrderUnitApi.h"

@interface KNBHomeCompanyHouseViewController ()
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *fooerView;
@end

@implementation KNBHomeCompanyHouseViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configuration];
    
    [self addUI];
    
    [self fetchData];
}

#pragma mark - Utils
- (void)configuration {
    [self.naviView removeFromSuperview];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)addUI {
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.knbTableView];
}

- (void)fetchData {
    KNBOrderUnitApi *api = [[KNBOrderUnitApi alloc] init];
    api.hudString = @"";
    KNB_WS(weakSelf);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            [weakSelf.dataArray removeAllObjects];
            NSDictionary *dic = request.responseObject[@"list"];
            NSArray *modelArray = [KNBRecruitmentUnitModel changeResponseJSONObject:dic];
            // 给数据源赋值
            KNBRecruitmentUnitModel *allModel = [KNBRecruitmentUnitModel new];
            allModel.name = @"全部";
            allModel.houseId = @"0";
            [weakSelf.dataArray addObject:allModel];
            [weakSelf.dataArray addObjectsFromArray:modelArray];
            weakSelf.knbTableView.frame = CGRectMake(0, 5, KNB_SCREEN_WIDTH, self.dataArray.count * 50);
            [weakSelf.knbTableView reloadData];
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KNBRecruitmentUnitModel *model = self.dataArray[indexPath.row];
    KNBChoiceTableViewCell *cell = [KNBChoiceTableViewCell cellWithTableView:tableView title:isNullStr(model.catName) ? model.name : model.catName];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KNBRecruitmentUnitModel *model = self.dataArray[indexPath.row];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:model,@"model", nil];
    NSNotification *notification = [NSNotification notificationWithName:NSStringFromClass([KNBHomeCompanyHouseViewController class]) object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

#pragma mark - Getters And Setters
/* getter和setter全部都放在最后*/
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
        _headerView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, 5);
    }
    return _headerView;
}

//- (UIView *)fooerView {
//    if (!_fooerView) {
//        _fooerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KNB_SCREEN_WIDTH, 50)];
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, 50);
//        button.backgroundColor = [UIColor colorWithHex:0x1898e3];
//        [button setTitle:@"确定" forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        button.titleLabel.font = [UIFont systemFontOfSize:14];
//        [button addTarget:self action:@selector(enterButtonAction) forControlEvents:UIControlEventTouchUpInside];
//        [_fooerView addSubview:button];
//    }
//    return _fooerView;
//}


@end
