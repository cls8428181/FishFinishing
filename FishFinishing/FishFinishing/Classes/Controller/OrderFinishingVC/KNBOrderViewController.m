//
//  KNBOrderViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/8.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBOrderViewController.h"
#import "KNBOrderDownTableViewCell.h"
#import "KNBOrderTextfieldTableViewCell.h"
#import "KNBOrderAddressTableViewCell.h"
#import "KNBOrderFooterView.h"
#import "BRAddressPickerView.h"
#import "BRStringPickerView.h"
#import "KNBRecruitmentPayViewController.h"

@interface KNBOrderViewController ()
@property (nonatomic, strong) KNBOrderFooterView *footerView;
@end

@implementation KNBOrderViewController
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
    self.naviView.title = self.VCType == KNBOrderVCTypeOrderFinishing ? @"预约" : @"商家入驻";
    [self.naviView addLeftBarItemImageName:@"knb_back_black" target:self sel:@selector(backAction)];
    self.view.backgroundColor = [UIColor knBgColor];
    self.knGroupTableView.tableFooterView = self.footerView;
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
    if (section == 0) {
        return 1;
    } else {
        if (_VCType == KNBOrderVCTypeOrderFinishing) {
            return 2;
        } else {
            if (section == 1) {
                return 2;
            } else if (section == 2) {
                return 3;
            } else {
                return 1;
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [KNBOrderDownTableViewCell cellWithTableView:tableView];
        KNBOrderDownTableViewCell *typeCell = (KNBOrderDownTableViewCell *)cell;
        typeCell.type = KNBOrderDownTypeServer;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell = [KNBOrderTextfieldTableViewCell cellWithTableView:tableView];
            KNBOrderTextfieldTableViewCell *typeCell = (KNBOrderTextfieldTableViewCell *)cell;
            typeCell.type = KNBOrderTextFieldTypeArea;
        } else {
            cell = [KNBOrderDownTableViewCell cellWithTableView:tableView];
            KNBOrderDownTableViewCell *typeCell = (KNBOrderDownTableViewCell *)cell;
            typeCell.type = KNBOrderDownTypeHouse;
        }
        
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell = [KNBOrderTextfieldTableViewCell cellWithTableView:tableView];
            KNBOrderTextfieldTableViewCell *typeCell = (KNBOrderTextfieldTableViewCell *)cell;
            typeCell.type = KNBOrderTextFieldTypeCommunity;

        } else {
            cell = [KNBOrderAddressTableViewCell cellWithTableView:tableView];
        }
        
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            cell = [KNBOrderDownTableViewCell cellWithTableView:tableView];
            KNBOrderDownTableViewCell *typeCell = (KNBOrderDownTableViewCell *)cell;
            typeCell.type = KNBOrderDownTypeStyle;

        } else {
            cell = [KNBOrderDownTableViewCell cellWithTableView:tableView];
            KNBOrderDownTableViewCell *typeCell = (KNBOrderDownTableViewCell *)cell;
            typeCell.type = KNBOrderDownTypeLevel;
        }
        
    } else {
        if (indexPath.row == 0) {
            cell = [KNBOrderTextfieldTableViewCell cellWithTableView:tableView];
            KNBOrderTextfieldTableViewCell *typeCell = (KNBOrderTextfieldTableViewCell *)cell;
            typeCell.type = KNBOrderTextFieldTypeName;

        } else {
            cell = [KNBOrderTextfieldTableViewCell cellWithTableView:tableView];
            KNBOrderTextfieldTableViewCell *typeCell = (KNBOrderTextfieldTableViewCell *)cell;
            typeCell.type = KNBOrderTextFieldTypePhone;

        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
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
    if (indexPath.section == 0) {
        [BRStringPickerView showStringPickerWithTitle:@"选择服务" dataSource:@[@"1",@"2",@"3"] defaultSelValue:nil resultBlock:^(id selectValue) {
            
        }];
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        [BRStringPickerView showStringPickerWithTitle:@"选择户型" dataSource:@[@"1",@"2",@"3"] defaultSelValue:nil resultBlock:^(id selectValue) {
            
        }];
    } else if (indexPath.section == 2 && indexPath.row == 1) {
        [BRAddressPickerView showAddressPickerWithDefaultSelected:nil resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
            
        }];
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            [BRStringPickerView showStringPickerWithTitle:@"选择风格" dataSource:@[@"1",@"2",@"3"] defaultSelValue:nil resultBlock:^(id selectValue) {
                
            }];
        } else {
            [BRStringPickerView showStringPickerWithTitle:@"选择档次" dataSource:@[@"1",@"2",@"3"] defaultSelValue:nil resultBlock:^(id selectValue) {
                
            }];
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
- (KNBOrderFooterView *)footerView {
    if (!_footerView) {
        KNB_WS(weakSelf);
        _footerView = [[KNBOrderFooterView alloc] initWithButtonTitle:_VCType ==  KNBOrderVCTypeOrderFinishing ? @"免费预约" : @"提交入驻"];
        _footerView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, 80);
        _footerView.enterButtonBlock = ^{
            if (weakSelf.VCType == KNBOrderVCTypeOrderFinishing) {
                
            } else {
                KNBRecruitmentPayViewController *payVC = [[KNBRecruitmentPayViewController alloc] init];
                [weakSelf.navigationController pushViewController:payVC animated:YES];
            }
        };
    }
    return _footerView;
}

@end
