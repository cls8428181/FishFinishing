//
//  KNBHomeChatViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/19.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeChatViewController.h"
#import "KNBHomeChatTableViewCell.h"
#import "KNBHomeMessageListApi.h"
#import "KNBHomeChatModel.h"
#import "KNBHomeChatDetailViewController.h"

@interface KNBHomeChatViewController ()

@end

@implementation KNBHomeChatViewController

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
    self.naviView.title = @"消息";
    [self.naviView addLeftBarItemImageName:@"knb_back_black" target:self sel:@selector(backAction)];
    self.view.backgroundColor = [UIColor knBgColor];
    
}

- (void)addUI {
    [self.view addSubview:self.knbTableView];
}

- (void)fetchData {
    KNBHomeMessageListApi *api = [[KNBHomeMessageListApi alloc] initWithPage:1 limit:10];
    api.hudString = @"";
    KNB_WS(weakSelf);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            NSDictionary *dic = request.responseObject[@"list"];
            NSArray *modelArray = [KNBHomeChatModel changeResponseJSONObject:dic];
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KNBHomeChatModel *model = self.dataArray[indexPath.row];
    KNBHomeChatTableViewCell *cell = [KNBHomeChatTableViewCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [KNBHomeChatTableViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KNBHomeChatDetailViewController *detailVC = [[KNBHomeChatDetailViewController alloc] init];
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


@end
