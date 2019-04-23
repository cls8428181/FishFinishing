//
//  KNBHomeCompanyDetailViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/3.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeCompanyDetailViewController.h"
//views
#import "KNBHomeCompanyHeaderTableViewCell.h"
#import "KNBHomeCompanyServerTableViewCell.h"
#import "KNBHomeCompanyIntroTableViewCell.h"
#import "KNBHomeCompanyCaseTableViewCell.h"
#import "KNBRecruitmentDetailApi.h"
#import "KNBHomeServiceModel.h"
#import "KNBHomeCompanyEditDetailViewController.h"
#import "KNBHomeOfferViewController.h"
#import "KNBHomeDesignViewController.h"
#import "KNBHomeWorkerViewController.h"

@interface KNBHomeCompanyDetailViewController ()
@property (nonatomic, strong) KNBHomeServiceModel *currentModel;
@property (nonatomic, strong) UIButton *enterButton;
@end

@implementation KNBHomeCompanyDetailViewController

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
    [self.naviView addLeftBarItemImageName:@"knb_back_black" target:self sel:@selector(backAction)];
    if (self.isEdit) {
        [self.naviView addRightBarItemImageName:@"knb_me_bianji" target:self sel:@selector(editButtonAction)];
    }
    self.view.backgroundColor = [UIColor knBgColor];
    if (!self.isEdit) {
        self.knGroupTableView.frame = CGRectMake(0, KNB_NAV_HEIGHT, KNB_SCREEN_WIDTH, KNB_SCREEN_HEIGHT - KNB_TAB_HEIGHT - KNB_NAV_HEIGHT);
    }
}

- (void)addUI {
    [self.view addSubview:self.knGroupTableView];
    if (!self.isEdit) {
        [self.view addSubview:self.enterButton];
    }
}

- (void)fetchData {
    KNBRecruitmentDetailApi *api = [[KNBRecruitmentDetailApi alloc] initWithfacId:[self.model.serviceId integerValue]];
    api.hudString = @"";
    KNB_WS(weakSelf);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            NSDictionary *dic = request.responseObject[@"list"];
            KNBHomeServiceModel *model = [KNBHomeServiceModel changeResponseJSONObject:dic];
            weakSelf.currentModel = model;
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [KNBHomeCompanyHeaderTableViewCell cellWithTableView:tableView];
        KNBHomeCompanyHeaderTableViewCell *blockCell = (KNBHomeCompanyHeaderTableViewCell *)cell;
        blockCell.model = self.currentModel;
    } else if (indexPath.section == 1) {
        cell = [KNBHomeCompanyServerTableViewCell cellWithTableView:tableView];
        KNBHomeCompanyServerTableViewCell *blockCell = (KNBHomeCompanyServerTableViewCell *)cell;
        blockCell.model = self.currentModel;
    } else if (indexPath.section == 2) {
        cell = [KNBHomeCompanyIntroTableViewCell cellWithTableView:tableView];
        KNBHomeCompanyIntroTableViewCell *blockCell = (KNBHomeCompanyIntroTableViewCell *)cell;
        blockCell.model = self.currentModel;
    } else {
        cell = [KNBHomeCompanyCaseTableViewCell cellWithTableView:tableView];
        KNBHomeCompanyCaseTableViewCell *blockCell = (KNBHomeCompanyCaseTableViewCell *)cell;
        blockCell.model = self.currentModel;
        blockCell.isEdit = self.isEdit;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [KNBHomeCompanyHeaderTableViewCell cellHeight];
    } else if (indexPath.section == 1) {
        return [KNBHomeCompanyServerTableViewCell cellHeight];
    } else if (indexPath.section == 2) {
        return [KNBHomeCompanyIntroTableViewCell cellHeight];
    } else {
        return [KNBHomeCompanyCaseTableViewCell cellHeight:self.currentModel.caseList.count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return CGFLOAT_MIN;
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Event Response
/*
 *  所有button、gestureRecognizer的响应事件都放在这个区域里面，不要到处乱放。
 */
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editButtonAction {
    KNBHomeCompanyEditDetailViewController *editVC = [[KNBHomeCompanyEditDetailViewController alloc] init];
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)enterButtonAction {
    if ([self.naviView.title isEqualToString:@"设计师"]) {
        KNBHomeDesignViewController *designVC = [[KNBHomeDesignViewController alloc] init];
        designVC.faceId = [self.model.serviceId integerValue];
        [self.navigationController pushViewController:designVC animated:YES];
    } else if ([self.naviView.title isEqualToString:@"装修工人"] || [self.naviView.title isEqualToString:@"装修工长"]) {
        KNBHomeWorkerViewController *workerVC = [[KNBHomeWorkerViewController alloc] init];
        workerVC.faceId = [self.model.serviceId integerValue];
        [self.navigationController pushViewController:workerVC animated:YES];
    } else {
        KNBHomeOfferViewController *offerVC = [[KNBHomeOfferViewController alloc] init];
        offerVC.faceId = [self.model.serviceId integerValue];
        [self.navigationController pushViewController:offerVC animated:YES];
    }
}

#pragma mark - Getters And Setters
/* getter和setter全部都放在最后*/
- (UIButton *)enterButton {
    if (!_enterButton) {
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _enterButton.frame = CGRectMake(0, KNB_SCREEN_HEIGHT - KNB_TAB_HEIGHT, KNB_SCREEN_WIDTH, KNB_TAB_HEIGHT);
        [_enterButton setTitle:[self.naviView.title isEqualToString:@"家居建材"] ? @"立即购买" : @"立即预约" forState:UIControlStateNormal];
        [_enterButton setBackgroundColor:[UIColor colorWithHex:0xf5701b]];
        [_enterButton addTarget:self action:@selector(enterButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterButton;
}
@end
