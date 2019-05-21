//
//  KNBRecruitmentPayViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/9.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBRecruitmentPayViewController.h"
#import "KNBRecruitmentPayFooterView.h"
#import "KNBRecruitmentShowTableViewCell.h"
#import "KNBRecruitmentPayTableViewCell.h"
#import "KNBRecruitmentProtocolTableViewCell.h"
#import "KNPayManager.h"
#import "KNBPayProtocolViewController.h"
#import "KNBUploadFileApi.h"
#import "KNBRecruitmentAddApi.h"

@interface KNBRecruitmentPayViewController ()

@property (nonatomic, strong) KNBRecruitmentPayFooterView *footerView;
//是否是支付宝支付
@property (nonatomic, assign) BOOL isAlipy;
@property (nonatomic, assign) BOOL isProtocol;

@end

@implementation KNBRecruitmentPayViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configuration];
    
    [self addUI];
    
    [self fetchData];
}

#pragma mark - Utils
- (void)configuration {
    self.naviView.title = @"支付";
    [self.naviView addLeftBarItemImageName:@"knb_back_black" target:self sel:@selector(backAction)];
    self.view.backgroundColor = [UIColor knBgColor];
    self.knGroupTableView.tableFooterView = self.footerView;
    self.isAlipy = NO;
    self.isProtocol = YES;
    self.knGroupTableView.backgroundColor = [UIColor whiteColor];
}

- (void)addUI {
    [self.view addSubview:self.knGroupTableView];
}

- (void)fetchData {
    
}

#pragma mark - tableview delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [KNBRecruitmentShowTableViewCell cellWithTableView:tableView];
        KNBRecruitmentShowTableViewCell *typeCell = (KNBRecruitmentShowTableViewCell *)cell;
        typeCell.iconImageView.hidden = NO;
        typeCell.titleLabel.text = @"入驻类型:";
        typeCell.describeLabel.text = self.recruitmentModel.typeModel.catName ?: self.recruitmentModel.serviceModel.parent_cat_name;
    } else if (indexPath.section == 1) {
        cell = [KNBRecruitmentShowTableViewCell cellWithTableView:tableView];
        KNBRecruitmentShowTableViewCell *typeCell = (KNBRecruitmentShowTableViewCell *)cell;
        typeCell.iconImageView.hidden = YES;
        if (self.type == KNBPayVCTypeTop) {
            typeCell.titleLabel.text = @"置顶时间:";
        } else {
            typeCell.titleLabel.text = @"展示时间:";
        }
        NSString *timeString = @"";
        if ([self.recruitmentModel.priceModel.termType isEqualToString:@"year"]) {
            timeString = [NSString stringWithFormat:@"%@年",self.recruitmentModel.priceModel.term];
        } else if ([self.recruitmentModel.priceModel.termType isEqualToString:@"month"]) {
            timeString = [NSString stringWithFormat:@"%@月",self.recruitmentModel.priceModel.term];
        } else {
            timeString = [NSString stringWithFormat:@"%@日",self.recruitmentModel.priceModel.term];
        }
        typeCell.describeLabel.text = timeString;
    } else if (indexPath.section == 2) {
        cell = [KNBRecruitmentShowTableViewCell cellWithTableView:tableView];
        KNBRecruitmentShowTableViewCell *typeCell = (KNBRecruitmentShowTableViewCell *)cell;
        typeCell.iconImageView.hidden = YES;
        typeCell.titleLabel.text = @"费用总计:";
        typeCell.describeLabel.text = [NSString stringWithFormat:@"%@元",self.recruitmentModel.priceModel.price];
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            cell = [KNBRecruitmentPayTableViewCell cellWithTableView:tableView payType:@"支付宝"];
            KNBRecruitmentPayTableViewCell *typeCell = (KNBRecruitmentPayTableViewCell *)cell;
            typeCell.selectButtonBlock = ^(UIButton * _Nonnull button) {
            };

        } else {
            cell = [KNBRecruitmentPayTableViewCell cellWithTableView:tableView payType:@"微信"];
            KNBRecruitmentPayTableViewCell *typeCell = (KNBRecruitmentPayTableViewCell *)cell;
            typeCell.selectButtonBlock = ^(UIButton * _Nonnull button) {

            };
        }
        
    } else {
        KNB_WS(weakSelf);
        cell = [KNBRecruitmentProtocolTableViewCell cellWithTableView:tableView];
        KNBRecruitmentProtocolTableViewCell *typeCell = (KNBRecruitmentProtocolTableViewCell *)cell;
        typeCell.selectButtonBlock = ^(UIButton * _Nonnull button) {
            button.selected = !button.isSelected;
            weakSelf.isProtocol = button.isSelected;
        };
        typeCell.protocolButtonBlock = ^{
            KNBPayProtocolViewController *protocolVC = [[KNBPayProtocolViewController alloc] init];
            [weakSelf.navigationController pushViewController:protocolVC animated:YES];
        };

    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 3 ? 75 :50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? CGFLOAT_MIN : 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView =[[UIView alloc] init];
    sectionView.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
    return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        KNBRecruitmentPayTableViewCell *alipyCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
        KNBRecruitmentPayTableViewCell *wechatCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:3]];
        if (indexPath.row == 0) {
            if (!self.isAlipy) {
                alipyCell.selectButton.selected = YES;
                wechatCell.selectButton.selected = NO;
                self.isAlipy = YES;
            }
        } else {
            alipyCell.selectButton.selected = NO;
            wechatCell.selectButton.selected = YES;
            self.isAlipy = NO;
        }
    }
}

#pragma mark - Event Response
/*
 *  所有button、gestureRecognizer的响应事件都放在这个区域里面，不要到处乱放。
 */
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addRecruitmentRequest {
    //上传图片
    [LCProgressHUD showLoading:@""];
    KNBUploadFileApi *fileApi = [[KNBUploadFileApi alloc] initWithImage:self.recruitmentModel.iconImage ?: CCPortraitPlaceHolder];
    KNB_WS(weakSelf);
    [fileApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (fileApi.requestSuccess) {
            NSString *imgString = request.responseObject[@"imgurl"];
            KNBRecruitmentAddApi *api = [[KNBRecruitmentAddApi alloc] initWithCatId:[weakSelf.recruitmentModel.typeModel.selectSubModel.typeId integerValue] tagId:weakSelf.recruitmentModel.domainId logo:imgString serviceId:weakSelf.recruitmentModel.serviceId Name:weakSelf.recruitmentModel.name phone:weakSelf.recruitmentModel.telephone address:weakSelf.recruitmentModel.address remark:weakSelf.recruitmentModel.remark];
            api.orderid = [[NSUserDefaults standardUserDefaults] objectForKey:@"orderid"];
            api.city_name = weakSelf.recruitmentModel.cityName;
            api.area_name = weakSelf.recruitmentModel.areaName;
            api.address = weakSelf.recruitmentModel.address;
            api.lat = [NSString stringWithFormat:@"%f",weakSelf.recruitmentModel.latitude];
            api.lng = [NSString stringWithFormat:@"%f",weakSelf.recruitmentModel.longitude];
            [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
                if (api.requestSuccess) {
                    [LCProgressHUD hide];
                    [KNB_AppDelegate.navController popToRootViewControllerAnimated:YES];
                    [KNB_TabBarVc turnToControllerIndex:KNB_AppDelegate.tabBarController.lastSelectIndex];
                    [KNBAlertRemind alterWithTitle:@"提示" message:@"您已经提交入驻申请,请等待审核" buttonTitles:@[ @"知道了" ] handler:^(NSInteger index, NSString *title){
                        
                    }];
                } else {
                    [LCProgressHUD showMessage:api.errMessage];
                }
            } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
                [LCProgressHUD showMessage:api.errMessage];
            }];
        } else {
            [LCProgressHUD showMessage:fileApi.errMessage];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [LCProgressHUD showMessage:fileApi.errMessage];
    }];
}

#pragma mark - Getters And Setters
/* getter和setter全部都放在最后*/
- (KNBRecruitmentPayFooterView *)footerView {
    KNB_WS(weakSelf);
    if (!_footerView) {
        _footerView = [[KNBRecruitmentPayFooterView alloc] init];
        _footerView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, 80);
        _footerView.enterButtonBlock = ^{
            if (weakSelf.isProtocol) {
                if (weakSelf.isAlipy) {
                    [KNPayManager payWithOrderId:weakSelf.recruitmentModel.priceModel.costId payPrice:[weakSelf.recruitmentModel.priceModel.price doubleValue] payMethod:KN_PayCodeAlipay chargeType:KNBGetChargeTypeRecruitment completeBlock:^(BOOL success, id errorMsg, NSInteger errorCode) {
                        if (success) {
                            if (weakSelf.type == KNBPayVCTypeRecruitment) {
                                [weakSelf addRecruitmentRequest];
                            } else if (weakSelf.type == KNBPayVCTypeTop) {
                                [KNB_AppDelegate.navController popToRootViewControllerAnimated:YES];
                                [KNB_TabBarVc turnToControllerIndex:KNB_AppDelegate.tabBarController.lastSelectIndex];
                                [KNBAlertRemind alterWithTitle:@"提示" message:@"您的置顶时间已经购买成功" buttonTitles:@[ @"知道了" ] handler:^(NSInteger index, NSString *title){
                                    
                                }];
                            } else {
                                [KNB_AppDelegate.navController popToRootViewControllerAnimated:YES];
                                [KNB_TabBarVc turnToControllerIndex:KNB_AppDelegate.tabBarController.lastSelectIndex];
                                [KNBAlertRemind alterWithTitle:@"提示" message:@"您的正式版已经升级成功" buttonTitles:@[ @"知道了" ] handler:^(NSInteger index, NSString *title){
                                    
                                }];
                            }

                        } else { //取消支付或失败
                            [LCProgressHUD showFailure:errorMsg];
                            if (errorCode == 10021) { //订单已经支付
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                });
                            } else if (errorCode == 5) { //取消支付
                                
                            } else { //支付失败
                                
                            }
                        }
                    }];
                } else {
                    [KNPayManager payWithOrderId:weakSelf.recruitmentModel.priceModel.costId payPrice:[weakSelf.recruitmentModel.priceModel.price doubleValue] payMethod:KN_PayCodeWX chargeType:KNBGetChargeTypeBuyService completeBlock:^(BOOL success, id errorMsg, NSInteger errorCode) {
                        if (success) {
                            if (weakSelf.type == KNBPayVCTypeRecruitment) {
                                [weakSelf addRecruitmentRequest];
                            } else if (weakSelf.type == KNBPayVCTypeTop) {
                                [KNB_AppDelegate.navController popToRootViewControllerAnimated:YES];
                                [KNB_TabBarVc turnToControllerIndex:KNB_AppDelegate.tabBarController.lastSelectIndex];
                                [KNBAlertRemind alterWithTitle:@"提示" message:@"您的置顶时间已经购买成功" buttonTitles:@[ @"知道了" ] handler:^(NSInteger index, NSString *title){
                                    
                                }];
                            } else {
                                [KNB_AppDelegate.navController popToRootViewControllerAnimated:YES];
                                [KNB_TabBarVc turnToControllerIndex:KNB_AppDelegate.tabBarController.lastSelectIndex];
                                [KNBAlertRemind alterWithTitle:@"提示" message:@"您的正式版已经升级成功" buttonTitles:@[ @"知道了" ] handler:^(NSInteger index, NSString *title){
                                    
                                }];
                            }
                        } else { //取消支付或失败
                            [LCProgressHUD showFailure:errorMsg];
                            if (errorCode == 10021) { //订单已经支付
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                });
                            } else if (errorCode == 5) { //取消支付
                                
                            } else { //支付失败

                            }
                        }
                    }];
                }
            } else {
                [LCProgressHUD showMessage:@"请先阅读并接受入驻支付协议"];
            }

        };
    }
    return _footerView;
}


@end
