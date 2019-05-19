//
//  MeViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/26.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "MeViewController.h"
//views
#import "KNBMeHeaderView.h"
#import "KNBMeTableViewCell.h"
#import "KNBHomeCompanyDetailViewController.h"
#import "KNBMeAboutViewController.h"
#import "KNBMeSetViewController.h"
#import "KNBHomeChatViewController.h"
#import "KNBLoginViewController.h"
#import "KNBMeOrderViewController.h"
#import "KNBOrderViewController.h"
#import "KNBMeModifyInfoViewController.h"
#import "KNBGetCollocationApi.h"
#import "KNBHomeOfferViewController.h"
#import "KNBMeRecruitmentAlertView.h"
#import "KNBRecruitmentModifyDetailApi.h"

@interface MeViewController ()
@property (nonatomic, strong) KNBMeHeaderView *headerView;
@end

@implementation MeViewController

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.headerView.portraitImageView sd_setImageWithURL:[NSURL URLWithString:[KNBUserInfo shareInstance].portrait] placeholderImage:CCPortraitPlaceHolder];
    self.headerView.nameLabel.text = [KNBUserInfo shareInstance].nickName ?: @"未登录";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configuration];
    
    [self addUI];
    
    [self fetchData];
}

#pragma mark - Utils
- (void)configuration {
    [self.naviView removeFromSuperview];
    self.view.backgroundColor = [UIColor knBgColor];
    self.knGroupTableView.tableHeaderView = self.headerView;
    self.knGroupTableView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, KNB_SCREEN_HEIGHT - KNB_TAB_HEIGHT);
    
}

- (void)addUI {
    [self.view addSubview:self.knGroupTableView];
}

- (void)fetchData {
    //解析数据
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"KNBMe" ofType:@"plist"];
    NSMutableArray *dataArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    [self.dataArray removeAllObjects];
    self.dataArray = dataArray;
}

#pragma mark - tableview delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *rowsArray = [self.dataArray objectAtIndex:section];
    return rowsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.section][indexPath.row];
    KNBMeTableViewCell *cell = [KNBMeTableViewCell cellWithTableView:tableView];
    cell.titleLabel.text = dic[@"title"];
    cell.iconImageView.image = KNBImages(dic[@"imageName"]);
    if ([dic[@"title"] isEqualToString:@"我要接单"]) {
        cell.markImageView.hidden = NO;
        cell.rightLabel.hidden = NO;
    } else {
        cell.markImageView.hidden = YES;
        cell.rightLabel.hidden = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KNB_WS(weakSelf);
        if (indexPath.section == 0) {
            if ( indexPath.row == 0) {
                if ([KNBUserInfo shareInstance].isLogin) {
                    KNBRecruitmentModifyDetailApi *api = [[KNBRecruitmentModifyDetailApi alloc] init];
                    KNB_WS(weakSelf);
                    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
                        if (api.requestSuccess) {
                            NSDictionary *dic = request.responseObject[@"list"];
                            KNBHomeServiceModel *serviceModel = [KNBHomeServiceModel changeResponseJSONObject:dic];
                            KNBHomeCompanyDetailViewController *detailVC = [[KNBHomeCompanyDetailViewController alloc] init];
                            detailVC.model = serviceModel;
                            detailVC.isEdit = YES;
                            [weakSelf.navigationController pushViewController:detailVC animated:YES];
                        } else {
                            [KNBMeRecruitmentAlertView showAlertViewRecruitmentBlock:^{
                                KNBOrderViewController *orderVC = [[KNBOrderViewController alloc] init];
                                orderVC.VCType = KNBOrderVCTypeRecruitment;
                                orderVC.isExperience = NO;
                                [weakSelf.navigationController pushViewController:orderVC animated:YES];
                            } experienceBlock:^{
                                KNBOrderViewController *orderVC = [[KNBOrderViewController alloc] init];
                                orderVC.VCType = KNBOrderVCTypeRecruitment;
                                orderVC.isExperience = YES;
                                [weakSelf.navigationController pushViewController:orderVC animated:YES];
                            }];
                        }
                    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
                        [LCProgressHUD showMessage:api.errMessage];
                    }];
                    
                } else {
                    [KNBAlertRemind alterWithTitle:@"" message:@"您还未登录,请先登录" buttonTitles:@[@"去登录",@"取消"] handler:^(NSInteger index, NSString *title) {
                        if ([title isEqualToString:@"去登录"]) {
                            KNBLoginViewController *loginVC = [[KNBLoginViewController alloc] init];
                            loginVC.vcType = KNBLoginTypeLogin;
                            [weakSelf presentViewController:loginVC animated:YES completion:nil];
                        }
                    }];
                }
            }
            if (indexPath.row == 1) {
                NSURL *url = [NSURL URLWithString:@"test://"];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url options:nil completionHandler:nil];
                    
                }else{
                    NSLog(@"没有安装应用");
                    KNBGetCollocationApi *api = [[KNBGetCollocationApi alloc] initWithKey:@"System_setup"];
                    api.hudString = @"";
                    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
                        if (api.requestSuccess) {
                            NSDictionary *dic = request.responseObject[@"list"];
                            NSString *downString = dic[@"Receipt_address"];
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downString] options:nil completionHandler:nil];
                        }
                    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
                    }];
                }
            }
            if (indexPath.row == 2) {
                if ([KNBUserInfo shareInstance].isLogin) {
                    if (isNullStr([KNBUserInfo shareInstance].fac_id)) {
                        [LCProgressHUD showMessage:@"您还未入驻,请先成为入驻商家"];
                    } else {
                        KNBMeOrderViewController *orderVC = [[KNBMeOrderViewController alloc] init];
                        [self.navigationController pushViewController:orderVC animated:YES];
                    }
                } else {
                    KNB_WS(weakSelf);
                    [KNBAlertRemind alterWithTitle:@"" message:@"您还未登录,请先登录" buttonTitles:@[@"去登录",@"取消"] handler:^(NSInteger index, NSString *title) {
                        if ([title isEqualToString:@"去登录"]) {
                            KNBLoginViewController *loginVC = [[KNBLoginViewController alloc] init];
                            loginVC.vcType = KNBLoginTypeLogin;
                            [weakSelf presentViewController:loginVC animated:YES completion:nil];
                        }
                    }];
                }
            }
        }
        if (indexPath.section == 1) {
            NSString *urlStr = @"http://dayuapp.idayu.cn/Home/download.html";
            NSString *name = @"大鱼装修";
            NSString *describeStr = @"大鱼装修";
            [self shareMessages:@[ name, describeStr, urlStr ] isActionType:NO shareButtonBlock:nil];
        }
        if (indexPath.section == 2 && indexPath.row == 0) {
            KNBMeAboutViewController *aboutVC = [[KNBMeAboutViewController alloc] init];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }


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
- (KNBMeHeaderView *)headerView {
    KNB_WS(weakSelf);
    if (!_headerView) {
        _headerView = [[KNBMeHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, KNB_SCREEN_WIDTH * 170/375 + KNB_StatusBar_H + 140);
        _headerView.settingButtonBlock = ^{
            if ([KNBUserInfo shareInstance].isLogin) {
                KNBMeSetViewController *setVC = [[KNBMeSetViewController alloc] init];
                [weakSelf.navigationController pushViewController:setVC animated:YES];
            } else {
                [KNBAlertRemind alterWithTitle:@"" message:@"您还未登录,请先登录" buttonTitles:@[@"去登录",@"取消"] handler:^(NSInteger index, NSString *title) {
                    if ([title isEqualToString:@"去登录"]) {
                        KNBLoginViewController *loginVC = [[KNBLoginViewController alloc] init];
                        loginVC.vcType = KNBLoginTypeLogin;
                        [weakSelf presentViewController:loginVC animated:YES completion:nil];
                    }
                }];
            }

        };
        _headerView.chatButtonBlock = ^{
            KNBHomeChatViewController *chatVC = [[KNBHomeChatViewController alloc] init];
            [weakSelf.navigationController pushViewController:chatVC animated:YES];
        };
        _headerView.loginButtonBlock = ^{
            if ([KNBUserInfo shareInstance].isLogin) {
                KNBMeModifyInfoViewController *infoVC = [[KNBMeModifyInfoViewController alloc] init];
                [weakSelf.navigationController pushViewController:infoVC animated:YES];
            } else {
                KNBLoginViewController *loginVC = [[KNBLoginViewController alloc] init];
                loginVC.vcType = KNBLoginTypeLogin;
                [weakSelf presentViewController:loginVC animated:YES completion:nil];
            }
        };
        _headerView.adButtonBlock = ^{
            KNBHomeOfferViewController *offerVC = [[KNBHomeOfferViewController alloc] init];
            offerVC.faceId = [[KNBUserInfo shareInstance].fac_id integerValue] ?: 0;
            [weakSelf.navigationController pushViewController:offerVC animated:YES];
        };
    }
    return _headerView;
}

@end
