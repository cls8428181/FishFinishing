//
//  KNBMeSetViewController.m
//  FishFinishing
//
//  Created by apple on 2019/4/19.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBMeSetViewController.h"
#import "KNBOrderTextfieldTableViewCell.h"
#import "KNBOrderDownTableViewCell.h"
#import "KNBRecruitmentPortraitTableViewCell.h"
#import "KNBRecruitmentEnterTableViewCell.h"

@interface KNBMeSetViewController ()

@end

@implementation KNBMeSetViewController

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
    self.naviView.title = @"设置";
    [self.naviView addLeftBarItemImageName:@"knb_back_black" target:self sel:@selector(backAction)];
    self.knGroupTableView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor knBgColor];
}

- (void)addUI {
    [self.view addSubview:self.knGroupTableView];
}

- (void)fetchData {
    
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
    KNB_WS(weakSelf);
    if (indexPath.section == 0) {
        cell = [KNBOrderTextfieldTableViewCell cellWithTableView:tableView];
        KNBOrderTextfieldTableViewCell *blockCell = (KNBOrderTextfieldTableViewCell *)cell;
        blockCell.type = KNBOrderTextFieldTypeShopName;
        blockCell.describeTextField.text = [KNBUserInfo shareInstance].userName;
    } else if (indexPath.section == 1) {
        cell = [KNBRecruitmentPortraitTableViewCell cellWithTableView:tableView];
        KNBRecruitmentPortraitTableViewCell *blockCell = (KNBRecruitmentPortraitTableViewCell *)cell;
        [blockCell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[KNBUserInfo shareInstance].portrait] placeholderImage:KNBImages(@"knb_default_user")];
    } else if (indexPath.section == 2) {
        cell = [KNBOrderDownTableViewCell cellWithTableView:tableView];
        KNBOrderDownTableViewCell *blockCell = (KNBOrderDownTableViewCell *)cell;
        blockCell.type = KNBOrderDownTypeMedify;
    } else {
        cell = [KNBRecruitmentEnterTableViewCell cellWithTableView:tableView];
        KNBRecruitmentEnterTableViewCell *blockCell = (KNBRecruitmentEnterTableViewCell *)cell;
        blockCell.type = KNBRecruitmentEnterTypeSet;
        blockCell.selectButtonBlock = ^(UIButton * _Nonnull button) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 3 ? 90 : 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 1;
    } else {
        return 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        [[KNBUserInfo shareInstance] logout];
        [KNB_AppDelegate.navController popToRootViewControllerAnimated:NO];
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



@end
