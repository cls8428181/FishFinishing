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

@interface KNBRecruitmentPayViewController ()

@property (nonatomic, strong) KNBRecruitmentPayFooterView *footerView;
//是否是支付宝支付
@property (nonatomic, assign) BOOL isAlipy;

@end

@implementation KNBRecruitmentPayViewController

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
    self.naviView.title = @"入驻支付";
    [self.naviView addLeftBarItemImageName:@"knb_back_black" target:self sel:@selector(backAction)];
    self.view.backgroundColor = [UIColor knBgColor];
    self.knGroupTableView.tableFooterView = self.footerView;
    self.isAlipy = NO;
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
        typeCell.titleLabel.text = @"展示时间:";
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
        typeCell.describeLabel.text = self.recruitmentModel.priceModel.price;
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
        cell = [KNBRecruitmentProtocolTableViewCell cellWithTableView:tableView];
        KNBRecruitmentProtocolTableViewCell *typeCell = (KNBRecruitmentProtocolTableViewCell *)cell;
        typeCell.selectButtonBlock = ^(UIButton * _Nonnull button) {
            button.selected = !button.isSelected;
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
            if (self.isAlipy) {
                alipyCell.selectButton.selected = NO;
                wechatCell.selectButton.selected = YES;
                self.isAlipy = NO;
            }
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

#pragma mark - Getters And Setters
/* getter和setter全部都放在最后*/
- (KNBRecruitmentPayFooterView *)footerView {
    KNB_WS(weakSelf);
    if (!_footerView) {
        _footerView = [[KNBRecruitmentPayFooterView alloc] init];
        _footerView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, 80);
        _footerView.enterButtonBlock = ^{
            if (weakSelf.isAlipy) {
                [KNPayManager payWithOrderId:@"订单编号" payPrice:[weakSelf.recruitmentModel.priceModel.price doubleValue] payMethod:KN_PayCodeAlipay controller:weakSelf chargeType:KNBGetChargeTypeRecruitment completeBlock:^(BOOL success, id errorMsg, NSInteger errorCode) {
                    
                }];
            } else {
                [KNPayManager payWithOrderId:@"订单编号" payPrice:[weakSelf.recruitmentModel.priceModel.price doubleValue] payMethod:KN_PayCodeWX controller:weakSelf chargeType:KNBGetChargeTypeBuyService completeBlock:^(BOOL success, id errorMsg, NSInteger errorCode) {
                    
                }];
            }
        };
    }
    return _footerView;
}


@end
