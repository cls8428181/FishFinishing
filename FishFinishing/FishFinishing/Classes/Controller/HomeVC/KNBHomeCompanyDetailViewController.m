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
#import "KNBRecruitmentDetailApi.h"
#import "KNBHomeServiceModel.h"
#import "KNBHomeCompanyEditDetailViewController.h"
#import "KNBHomeOfferViewController.h"
#import "KNBHomeDesignViewController.h"
#import "KNBHomeWorkerViewController.h"
#import "KNBHomeBuyTopViewController.h"
#import "KNBHomeCompanyExperienceViewController.h"
#import "KNBRecruitmentModifyDetailApi.h"
#import "KNBOrderModifyPowerApi.h"
#import "UIButton+Style.h"
#import "KNBHomeCompanyDetailFooterView.h"

@interface KNBHomeCompanyDetailViewController ()
@property (nonatomic, strong) KNBHomeServiceModel *currentModel;
@property (nonatomic, strong) UIImageView *bottomBgView;
@property (nonatomic, strong) UIButton *phoneButton;
@property (nonatomic, strong) UIButton *enterButton;
@property (nonatomic, strong) KNBHomeCompanyDetailFooterView *footerView;
//遮罩
@property (nonatomic, strong) UIView *coverView;
@end

@implementation KNBHomeCompanyDetailViewController

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
    if (self.isEdit) {
        [self.naviView addRightBarItemImageName:@"knb_me_bianji" target:self sel:@selector(editButtonAction)];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.knGroupTableView.backgroundColor = [UIColor whiteColor];
    self.naviView.title = self.model.parent_cat_name;
    if (!self.isEdit) {
        self.knGroupTableView.frame = CGRectMake(0, KNB_NAV_HEIGHT, KNB_SCREEN_WIDTH, KNB_SCREEN_HEIGHT - KNB_TAB_HEIGHT - KNB_NAV_HEIGHT);
    }
    self.knGroupTableView.estimatedRowHeight = 170;
}

- (void)addUI {
    [self.view addSubview:self.knGroupTableView];
    if (!self.isEdit) {
        [self.view addSubview:self.bottomBgView];
        [self.view addSubview:self.enterButton];
        [self.view addSubview:self.phoneButton];
    }
    [self.view addSubview:self.coverView];
}

- (void)fetchData {
    if (self.isEdit) {
        KNBRecruitmentModifyDetailApi *api = [[KNBRecruitmentModifyDetailApi alloc] init];
        KNB_WS(weakSelf);
        api.hudString = @"";
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
            if (api.requestSuccess) {
                [UIView animateWithDuration:1 animations:^{
                    weakSelf.coverView.alpha = 0;
                }];
                NSDictionary *dic = request.responseObject[@"list"];
                KNBHomeServiceModel *model = [KNBHomeServiceModel changeResponseJSONObject:dic];
                weakSelf.currentModel = model;
                weakSelf.currentModel.isEdit = YES;
                [weakSelf reloadFooterView];
                [weakSelf requestSuccess:YES requestEnd:YES];
            } else {
                weakSelf.currentModel = weakSelf.model;
                [weakSelf requestSuccess:YES requestEnd:YES];
            }
        } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
            weakSelf.currentModel = weakSelf.model;
            [weakSelf requestSuccess:YES requestEnd:YES];
        }];
    } else {
        KNBRecruitmentDetailApi *api = [[KNBRecruitmentDetailApi alloc] initWithfacId:self.model ? [self.model.serviceId integerValue] : [[KNBUserInfo shareInstance].fac_id integerValue]];
        KNB_WS(weakSelf);
        api.hudString = @"";
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
            if (api.requestSuccess) {
                [UIView animateWithDuration:1 animations:^{
                    weakSelf.coverView.alpha = 0;
                }];
                NSDictionary *dic = request.responseObject[@"list"];
                KNBHomeServiceModel *model = [KNBHomeServiceModel changeResponseJSONObject:dic];
                weakSelf.currentModel = model;
                [weakSelf reloadFooterView];
                [weakSelf requestSuccess:YES requestEnd:YES];
            } else {
                weakSelf.currentModel = weakSelf.model;
                [weakSelf requestSuccess:YES requestEnd:YES];
            }
        } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
            weakSelf.currentModel = weakSelf.model;
            [weakSelf requestSuccess:YES requestEnd:YES];
        }];
    }
}

- (void)reloadFooterView {
    self.footerView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, self.currentModel.caseListHeight);
    self.knGroupTableView.tableFooterView = self.footerView;
    self.footerView.model = self.currentModel;
    self.footerView.isEdit = self.isEdit;
    [self.footerView.collectionView reloadData];
}

#pragma mark - tableview delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    KNB_WS(weakSelf);
    if (indexPath.section == 0) {
        cell = [KNBHomeCompanyHeaderTableViewCell cellWithTableView:tableView];
        KNBHomeCompanyHeaderTableViewCell *blockCell = (KNBHomeCompanyHeaderTableViewCell *)cell;
        blockCell.isEdit = self.isEdit;
        blockCell.model = self.currentModel;
        blockCell.adButtonBlock = ^{
            KNBHomeCompanyExperienceViewController *experienceVC = [[KNBHomeCompanyExperienceViewController alloc] init];
            experienceVC.model = weakSelf.model;
            [weakSelf.navigationController pushViewController:experienceVC animated:YES];
        };
    } else if (indexPath.section == 1) {
        cell = [KNBHomeCompanyServerTableViewCell cellWithTableView:tableView];
        KNBHomeCompanyServerTableViewCell *blockCell = (KNBHomeCompanyServerTableViewCell *)cell;
        blockCell.isEdit = self.isEdit;
        blockCell.model = self.currentModel;
        blockCell.topButtonBlock = ^{
            KNBHomeBuyTopViewController *topVC = [[KNBHomeBuyTopViewController alloc] init];
            topVC.model = weakSelf.model;
            [weakSelf.navigationController pushViewController:topVC animated:YES];
        };
        blockCell.gotoEditBlock = ^{
            [weakSelf editButtonAction];
        };
        blockCell.gotoOrderBlock = ^{
            [weakSelf enterButtonAction];
        };
    } else {
        cell = [KNBHomeCompanyIntroTableViewCell cellWithTableView:tableView];
        KNBHomeCompanyIntroTableViewCell *blockCell = (KNBHomeCompanyIntroTableViewCell *)cell;
        blockCell.model = self.currentModel;
        blockCell.isEdit = self.isEdit;
        blockCell.openIntroBlock = ^{
            KNBHomeCompanyIntroTableViewCell *weakCell = [tableView cellForRowAtIndexPath:indexPath];
            weakCell.model.isOpen = !weakCell.model.isOpen;
            weakSelf.currentModel.isOpen = weakCell.model.isOpen;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [KNBHomeCompanyHeaderTableViewCell cellHeight:self.isEdit];
    } else if (indexPath.section == 1) {
        return [KNBHomeCompanyServerTableViewCell cellHeight:self.isEdit];
    } else {
        return self.currentModel.remarkHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return CGFLOAT_MIN;
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
    return view;
}

#pragma mark - Event Response
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editButtonAction {
    KNBOrderModifyPowerApi *api = [[KNBOrderModifyPowerApi alloc] init];
    api.hudString = @"";
    KNB_WS(weakSelf);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            KNBHomeCompanyEditDetailViewController *editVC = [[KNBHomeCompanyEditDetailViewController alloc] init];
            editVC.model = weakSelf.currentModel;
            [weakSelf.navigationController pushViewController:editVC animated:YES];
        } else {
            [LCProgressHUD showMessage:api.errMessage];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [LCProgressHUD showMessage:api.errMessage];
    }];

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

- (void)phoneButtonAction {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.model.telephone];
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:str];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        //OpenSuccess = 选择 呼叫 为 1  选择 取消 为0
        NSLog(@"OpenSuccess=%d",success);
        
    }];
}

#pragma mark - Getters And Setters
/* getter和setter全部都放在最后*/
- (UIButton *)enterButton {
    if (!_enterButton) {
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (KNB_ISIPHONEX) {
            _enterButton.frame = CGRectMake(KNB_SCREEN_WIDTH/2 + 13, KNB_SCREEN_HEIGHT - KNB_TAB_HEIGHT + 12, KNB_SCREEN_WIDTH/2 - 26, 34);
        } else {
            _enterButton.frame = CGRectMake(KNB_SCREEN_WIDTH/2 + 13, KNB_SCREEN_HEIGHT - KNB_TAB_HEIGHT + 8, KNB_SCREEN_WIDTH/2 - 26, 34);
        }

        [_enterButton setTitle:[self.naviView.title isEqualToString:@"家居建材"] ? @"立即购买" : @"立即预约" forState:UIControlStateNormal];
        [_enterButton addTarget:self action:@selector(enterButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _enterButton.layer.masksToBounds = YES;
        _enterButton.layer.cornerRadius = 17;
//        if ([self.naviView.title containsString:@"家居"] || [self.naviView.title containsString:@"建材"]) {
//            _enterButton.enabled = NO;
//            [_enterButton setBackgroundColor:[UIColor knLightGrayColor]];
//        } else {
            _enterButton.enabled = YES;
            [_enterButton setBackgroundColor:[UIColor knf5701bColor]];
//        }
    }
    return _enterButton;
}

- (UIImageView *)bottomBgView {
    if (!_bottomBgView) {
        _bottomBgView = [[UIImageView alloc] init];
        _bottomBgView.frame = CGRectMake(-10, KNB_SCREEN_HEIGHT - KNB_TAB_HEIGHT - 10, KNB_SCREEN_WIDTH + 20, KNB_TAB_HEIGHT + 10);
        _bottomBgView.image = KNBImages(@"knb_service_bottombg");
    }
    return _bottomBgView;
}

- (UIButton *)phoneButton {
    if (!_phoneButton) {
        _phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _phoneButton.frame = CGRectMake((KNB_SCREEN_WIDTH/2 - 60)/2, KNB_SCREEN_HEIGHT - KNB_TAB_HEIGHT, 60, 60);
        [_phoneButton setTitle:@"电话" forState:UIControlStateNormal];
        _phoneButton.titleLabel.font = KNBFont(13);
        [_phoneButton setTitleColor:[UIColor kn333333Color] forState:UIControlStateNormal];
        [_phoneButton setImage:KNBImages(@"knb_service_dianhua") forState:UIControlStateNormal];
        [_phoneButton addTarget:self action:@selector(phoneButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_phoneButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:6];
    }
    return _phoneButton;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.frame = CGRectMake(0, KNB_NAV_HEIGHT, KNB_SCREEN_WIDTH, KNB_SCREEN_HEIGHT - KNB_NAV_HEIGHT);
        _coverView.backgroundColor = [UIColor whiteColor];
    }
    return _coverView;
}

- (KNBHomeCompanyDetailFooterView *)footerView {
    KNB_WS(weakSelf);
    if (!_footerView) {
        _footerView = [[KNBHomeCompanyDetailFooterView alloc] init];
        _footerView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, self.currentModel.caseListHeight);
        _footerView.addCaseBlock = ^{
            [weakSelf fetchData];
        };
        _footerView.model = self.currentModel;
        _footerView.isEdit = self.isEdit;
    }
    return _footerView;
}

@end
