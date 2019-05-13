//
//  KNBMeOrderViewController.m
//  FishFinishing
//
//  Created by apple on 2019/4/24.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBMeOrderViewController.h"
#import "KNBMeOrderTableViewCell.h"
#import "KNBMeOrderModel.h"
#import "KNBMeOrderApi.h"
#import "KNBMeOrderAlertView.h"
#import "KNBMeOrderOtherTableViewCell.h"

@interface KNBMeOrderViewController ()

@end

@implementation KNBMeOrderViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configuration];
    
    [self addUI];
        
    [self fetchData];
}

#pragma mark - Utils
- (void)configuration {
    self.naviView.title = @"预约订单";
    [self.naviView addLeftBarItemImageName:@"knb_back_black" target:self sel:@selector(backAction)];
    self.view.backgroundColor = [UIColor knBgColor];
    
}

- (void)addUI {
    [self.view addSubview:self.knbTableView];
}

- (void)fetchData {
    KNBMeOrderApi *api = [[KNBMeOrderApi alloc] init];
    api.hudString = @"";
    KNB_WS(weakSelf);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            [weakSelf.dataArray removeAllObjects];
            NSDictionary *dic = request.responseObject[@"list"];
            NSArray *modelArray = [KNBMeOrderModel changeResponseJSONObject:dic];
            [weakSelf.dataArray addObjectsFromArray:modelArray];
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KNBMeOrderModel *model = self.dataArray[indexPath.row];
    UITableViewCell *cell = nil;
    if ([model.type isEqualToString:@"1"]) {
        cell = [KNBMeOrderOtherTableViewCell cellWithTableView:tableView];
        KNBMeOrderOtherTableViewCell *typeCell = (KNBMeOrderOtherTableViewCell *)cell;
        typeCell.model = model;
    } else {
        cell = [KNBMeOrderTableViewCell cellWithTableView:tableView];
        KNBMeOrderTableViewCell *typeCell = (KNBMeOrderTableViewCell *)cell;
        typeCell.model = model;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [KNBMeOrderTableViewCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KNB_WS(weakSelf);
    KNBMeOrderModel *model = self.dataArray[indexPath.row];
    [KNBMeOrderAlertView showAlertViewWithModel:model CompleteBlock:^{
        [weakSelf fetchData];
    } deleteActionBlock:^{
        [weakSelf fetchData];
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


@end
