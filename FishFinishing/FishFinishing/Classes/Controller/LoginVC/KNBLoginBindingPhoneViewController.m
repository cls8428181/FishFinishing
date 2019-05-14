//
//  KNBLoginBindingPhoneViewController.m
//  FishFinishing
//
//  Created by apple on 2019/4/25.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBLoginBindingPhoneViewController.h"
#import "KNBBindingMobileTableViewCell.h"
#import "KNBBindingCodeTableViewCell.h"
#import "KNBRecruitmentEnterTableViewCell.h"
#import "KNBLoginSendCodeApi.h"
#import "KNBLoginBindingApi.h"

@interface KNBLoginBindingPhoneViewController ()
@property (nonatomic, strong) NSDictionary *dic;

@end

@implementation KNBLoginBindingPhoneViewController

- (instancetype)initWithDataSource:(NSDictionary *)dic  {
    if (self = [super init]) {
        _dic = dic;
    }
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configuration];
    
    [self addUI];
        
    [self fetchData];
}

#pragma mark - Utils
- (void)configuration {
    self.naviView.title = @"绑定手机";
    [self.naviView addLeftBarItemImageName:@"knb_back_black" target:self sel:@selector(backAction)];
    self.view.backgroundColor = [UIColor knBgColor];
    
}

- (void)addUI {
    [self.view addSubview:self.knGroupTableView];
}

- (void)fetchData {
    
}

#pragma mark - tableview delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    KNB_WS(weakSelf);
    if (indexPath.section == 0) {
        cell = [KNBBindingMobileTableViewCell cellWithTableView:tableView];

    } else if (indexPath.section == 1) {
        cell = [KNBBindingCodeTableViewCell cellWithTableView:tableView];
        KNBBindingCodeTableViewCell *blockCell = (KNBBindingCodeTableViewCell *)cell;
        blockCell.getVerifyCodeBlock = ^{
            [weakSelf getVerifyCodeRequest];
        };
    } else {
        cell = [KNBRecruitmentEnterTableViewCell cellWithTableView:tableView];
        KNBRecruitmentEnterTableViewCell *blockCell = (KNBRecruitmentEnterTableViewCell *)cell;
        blockCell.type = KNBRecruitmentEnterTypeBinding;
        blockCell.selectButtonBlock = ^(UIButton * _Nonnull button) {
            [self bindingPhoneRequest];
        };
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 2 ? [KNBRecruitmentEnterTableViewCell cellHeight] : [KNBBindingMobileTableViewCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

//获取验证码
- (void)getVerifyCodeRequest {
    KNBBindingMobileTableViewCell *mobileCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (isNullStr(mobileCell.detailTextField.text) || !isPhoneNumber(mobileCell.detailTextField.text)) {
        [LCProgressHUD showInfoMsg:@"请输入正确的手机号"];
        [[LCProgressHUD sharedHUD].customView setSize:CGSizeMake(25, 25)];
        return;
    }
    KNBLoginSendCodeApi *codeApi = [[KNBLoginSendCodeApi alloc] initWithMobile:mobileCell.detailTextField.text type:KNBLoginSendCodeTypeBinding];
    
    KNB_WS(weakSelf);
    [codeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *request) {
        if (codeApi.requestSuccess) {
            [LCProgressHUD showSuccess:@"发送成功"];
            [weakSelf verinumViewTimerControll:YES];
        } else {
            [LCProgressHUD showInfoMsg:codeApi.errMessage];
            [[LCProgressHUD sharedHUD].customView setSize:CGSizeMake(25, 25)];
        }
    } failure:^(__kindof YTKBaseRequest *request) {
        [LCProgressHUD showFailure:codeApi.errMessage];
    }];
}
//定时器处理
- (void)verinumViewTimerControll:(BOOL)startTimer {
    KNBBindingCodeTableViewCell *codeCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [codeCell timerControll:startTimer];
}

- (void)bindingPhoneRequest {
    KNBBindingMobileTableViewCell *mobileCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    KNBBindingCodeTableViewCell *codeCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if (isNullStr(mobileCell.detailTextField.text) || !isPhoneNumber(mobileCell.detailTextField.text)) {
        [LCProgressHUD showInfoMsg:@"请输入正确的手机号"];
        [[LCProgressHUD sharedHUD].customView setSize:CGSizeMake(25, 25)];
        return;
    }
    if (isNullStr(codeCell.codeTextField.text)) {
        [LCProgressHUD showInfoMsg:@"验证码不能为空"];
        [[LCProgressHUD sharedHUD].customView setSize:CGSizeMake(25, 25)];
        return;
    }

    KNBLoginBindingApi *api = [[KNBLoginBindingApi alloc] initWithMobile:mobileCell.detailTextField.text code:codeCell.codeTextField.text portrait:self.portrait nickName:self.nickName sex:self.sex openid:self.openId loginType:self.type];
    api.hudString = @"";
    KNB_WS(weakSelf);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            NSDictionary *dic = request.responseObject[@"list"];
            [[KNBUserInfo shareInstance] updateUserInfo:dic];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            !self.bindingComplete ?: self.bindingComplete();
        } else {
            [LCProgressHUD showMessage:api.errMessage];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [LCProgressHUD showMessage:api.errMessage];
    }];
}


#pragma mark - Event Response
/*
 *  所有button、gestureRecognizer的响应事件都放在这个区域里面，不要到处乱放。
 */
- (void)backAction {
    KNBBindingCodeTableViewCell *codeCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [codeCell timerControll:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
