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
    [self.naviView removeFromSuperview];
    self.knbTableView.tableFooterView = self.fooerView;
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
            NSDictionary *dic = request.responseObject[@"list"];
            NSArray *modelArray = [KNBRecruitmentUnitModel changeResponseJSONObject:dic];
            // 给数据源赋值
            NSMutableArray *dataArray = [NSMutableArray array];
            for (KNBRecruitmentUnitModel *model in modelArray) {
                [dataArray addObject:model.name];
            }
            self.dataArray = dataArray;
            self.knbTableView.frame = CGRectMake(0, 5, KNB_SCREEN_WIDTH, self.dataArray.count * 50 + 50);
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
    
    KNBChoiceTableViewCell *cell = [KNBChoiceTableViewCell cellWithTableView:tableView title:self.dataArray[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

#pragma mark - Event Response
/*
 *  所有button、gestureRecognizer的响应事件都放在这个区域里面，不要到处乱放。
 */
- (void)enterButtonAction {
    NSInteger bedroomNum = 0;
    NSInteger hallNum = 0;
    NSInteger kitchenNum = 0;
    NSInteger toiletNum = 0;
    NSInteger balconyNum = 0;
    for (int i = 0; i < self.dataArray.count; i++) {
        KNBChoiceTableViewCell *cell = [self.knbTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if ( [cell.titleLabel.text isEqualToString:@"卧室"]) {
            bedroomNum = bedroomNum + [cell.numTextField.text integerValue];
        } else if ( [cell.titleLabel.text isEqualToString:@"客厅"] ||  [cell.titleLabel.text isEqualToString:@"餐厅"]) {
            hallNum = hallNum + [cell.numTextField.text integerValue];
        }else if ( [cell.titleLabel.text isEqualToString:@"厨房"]) {
            kitchenNum = kitchenNum + [cell.numTextField.text integerValue];
        } else if ( [cell.titleLabel.text isEqualToString:@"卫生间"]) {
            toiletNum = toiletNum + [cell.numTextField.text integerValue];
        } else {
            balconyNum = balconyNum + [cell.numTextField.text integerValue];
        }
    }
    NSArray *tempArray = @[
                           @(bedroomNum),
                           @(hallNum),
                           @(kitchenNum),
                           @(toiletNum),
                           @(balconyNum)];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:tempArray,@"houseArray", nil];
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

- (UIView *)fooerView {
    if (!_fooerView) {
        _fooerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KNB_SCREEN_WIDTH, 50)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, 50);
        button.backgroundColor = [UIColor colorWithHex:0x1898e3];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(enterButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_fooerView addSubview:button];
    }
    return _fooerView;
}


@end
