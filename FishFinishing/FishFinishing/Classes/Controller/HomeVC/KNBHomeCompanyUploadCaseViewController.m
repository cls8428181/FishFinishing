//
//  KNBHomeCompanyUploadCaseViewController.m
//  FishFinishing
//
//  Created by apple on 2019/4/19.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBHomeCompanyUploadCaseViewController.h"
#import "KNBOrderDownTableViewCell.h"
#import "KNBOrderTextfieldTableViewCell.h"
#import "KNBHomeUploadCaseTableViewCell.h"
#import "KNBRecruitmentAddCaseApi.h"
#import "KNBRecruitmentTypeModel.h"
#import "KNBOrderUnitApi.h"
#import "KNBOrderStyleApi.h"
#import "BRChoicePickerView.h"
#import "BRStringPickerView.h"
#import "KNBUploadFileApi.h"
#import "KNBHomeUploadCaseFooterView.h"

@interface KNBHomeCompanyUploadCaseViewController ()<UITextFieldDelegate,UITextViewDelegate>
//图片数组
@property (nonatomic, strong) NSMutableArray *imgsArray;
//标题
@property (nonatomic, copy) NSString *titleString;
//面积
@property (nonatomic, copy) NSString *areaString;
//户型
@property (nonatomic, assign) NSInteger houseId;
@property (nonatomic, copy) NSString *houseInfo;
//风格
@property (nonatomic, strong) KNBRecruitmentTypeModel *styleModel;
//案例描述
@property (nonatomic, copy) NSString *desribeString;

@property (nonatomic, strong) KNBHomeUploadCaseFooterView *footerView;
//记录最后一个输入框
@property (nonatomic, strong) UITextField *lastTextField;
@property (nonatomic, assign) NSInteger maxLength;

@end

@implementation KNBHomeCompanyUploadCaseViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configuration];
    
    [self addUI];
}

#pragma mark - Utils
- (void)configuration {
    self.naviView.title = @"案例上传";
    [self.naviView addLeftBarItemImageName:@"knb_back_black" target:self sel:@selector(backAction)];
    [self.naviView addRightBarItemTitle:@"保存" target:self sel:@selector(saveAction)];
    [self.naviView.rightNaviButton setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor knBgColor];
    self.maxLength = 50;
}

- (void)addUI {
    [self.view addSubview:self.knGroupTableView];
    self.knGroupTableView.backgroundColor = [UIColor whiteColor];
    self.knGroupTableView.tableFooterView = self.footerView;
}

#pragma mark - tableview delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = [KNBOrderTextfieldTableViewCell cellWithTableView:tableView];
            KNBOrderTextfieldTableViewCell *typeCell = (KNBOrderTextfieldTableViewCell *)cell;
            typeCell.type = KNBOrderTextFieldTypeTitle;
            typeCell.describeTextField.delegate = self;
            if (!isNullStr(self.titleString)) {
                typeCell.describeTextField.text = self.titleString;
            }
        } else if (indexPath.row == 1) {
            cell = [KNBOrderTextfieldTableViewCell cellWithTableView:tableView];
            KNBOrderTextfieldTableViewCell *typeCell = (KNBOrderTextfieldTableViewCell *)cell;
            typeCell.type = KNBOrderTextFieldTypeArea;
            typeCell.describeTextField.delegate = self;
            if (!isNullStr(self.areaString)) {
                typeCell.describeTextField.text = self.areaString;
            }
        } else if (indexPath.row == 2) {
            cell = [KNBOrderDownTableViewCell cellWithTableView:tableView];
            KNBOrderDownTableViewCell *typeCell = (KNBOrderDownTableViewCell *)cell;
            typeCell.type = KNBOrderDownTypeHouse;
            if (!isNullStr(self.houseInfo)) {
                [typeCell setButtonTitle:self.houseInfo];
            }
        } else {
            cell = [KNBOrderDownTableViewCell cellWithTableView:tableView];
            KNBOrderDownTableViewCell *typeCell = (KNBOrderDownTableViewCell *)cell;
            typeCell.type = KNBOrderDownTypeStyle;
            if (!isNullStr(self.styleModel.catName)) {
                [typeCell setButtonTitle:self.styleModel.catName];
            }
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [KNBOrderDownTableViewCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] init];
    sectionView.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
    return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            [self unitRequest];
        }
        if (indexPath.row == 3) {
            [self finishingStyleRequest];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.lastTextField resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    KNBOrderTextfieldTableViewCell *titleCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    KNBOrderTextfieldTableViewCell *areaCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if ([textField isEqual:titleCell.describeTextField]) {
        self.titleString = textField.text;
    }
    if ([textField isEqual:areaCell.describeTextField]) {
        self.areaString = textField.text;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.lastTextField = textField;
}

//请求户型数据
- (void)unitRequest {
    KNBOrderUnitApi *api = [[KNBOrderUnitApi alloc] init];
    api.hudString = @"";
    KNB_WS(weakSelf);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            NSDictionary *dic = request.responseObject[@"list"];
            NSArray *modelArray = [KNBRecruitmentUnitModel changeResponseJSONObject:dic];
            NSMutableArray *titleArray = [NSMutableArray array];
            for (KNBRecruitmentUnitModel *model in modelArray) {
                [titleArray addObject:model.name];
            }
            [BRStringPickerView showStringPickerWithTitle:@"选择户型" dataSource:titleArray defaultSelValue:nil resultBlock:^(id selectValue) {
                KNBOrderDownTableViewCell *cell = [weakSelf.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                [cell setButtonTitle:selectValue];
                weakSelf.houseInfo = selectValue;
                for (KNBRecruitmentUnitModel *model in modelArray) {
                    if ([model.name isEqualToString:selectValue]) {
                        weakSelf.houseId = [model.houseId integerValue];
                    }
                }
            }];
        } else {
            [weakSelf requestSuccess:NO requestEnd:NO];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [weakSelf requestSuccess:NO requestEnd:NO];
    }];
    
}
//请求装修风格数据
- (void)finishingStyleRequest {
    KNBOrderStyleApi *api = [[KNBOrderStyleApi alloc] init];
    api.hudString = @"";
    KNB_WS(weakSelf);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            NSDictionary *dic = request.responseObject[@"list"];
            NSMutableArray *modelArray = [KNBRecruitmentTypeModel changeResponseJSONObject:dic];
            NSMutableArray *titleArray = [NSMutableArray array];
            for (KNBRecruitmentTypeModel *model in modelArray) {
                [titleArray addObject:model.catName];
            }
            [BRStringPickerView showStringPickerWithTitle:@"选择风格" dataSource:titleArray defaultSelValue:nil resultBlock:^(id selectValue) {
                KNBOrderDownTableViewCell *cell = [weakSelf.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                [cell setButtonTitle:selectValue];
                for (KNBRecruitmentTypeModel *model in modelArray) {
                    if ([model.catName isEqualToString:selectValue]) {
                        weakSelf.styleModel = model;
                    }
                }
            }];
        } else {
            [weakSelf requestSuccess:NO requestEnd:NO];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [weakSelf requestSuccess:NO requestEnd:NO];
    }];
}

#pragma mark - Event Response
/*
 *  所有button、gestureRecognizer的响应事件都放在这个区域里面，不要到处乱放。
 */
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveAction {
    if ([self checkInfoComplete]) {
        
        //上传图片
        [LCProgressHUD showLoading:@""];
        [KNBUploadFileApi uploadWithRequests:self.imgsArray token:[KNBUserInfo shareInstance].token complete:^(NSArray *fileUrls) {
            if (!isNullArray(fileUrls)) {
                NSString *imgsUrl = @"";
                for (NSString *imgUrl in fileUrls) {
                    imgsUrl = [imgsUrl stringByAppendingString:imgUrl];
                    imgsUrl = [imgsUrl stringByAppendingString:@","];
                }
                imgsUrl = [imgsUrl substringToIndex:[imgsUrl length]-1];
                KNBRecruitmentAddCaseApi *api = [[KNBRecruitmentAddCaseApi alloc] initWithTitle:self.titleString styleId:[self.styleModel.typeId integerValue] acreage:[self.areaString doubleValue] apartmentId:self.houseId imgs:imgsUrl];
                api.remark = self.desribeString;
                KNB_WS(weakSelf);
                [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
                    if (api.requestSuccess) {
                        [LCProgressHUD hide];
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                        !weakSelf.saveSuccessBlock ?: weakSelf.saveSuccessBlock();
                    } else {
                        [LCProgressHUD showMessage:@"保存失败,请重新保存"];
                    }
                } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
                    [LCProgressHUD showMessage:@"保存失败,请重新保存"];
                }];
            }
        } failure:^(NSArray *failRequests, NSArray *successFileUrls) {
            [LCProgressHUD showMessage:@"图片上传失败"];
        }];
    }
}

- (BOOL)checkInfoComplete {
    KNBOrderTextfieldTableViewCell *titleCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    KNBOrderTextfieldTableViewCell *areaCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    KNBOrderDownTableViewCell *houseCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    KNBOrderDownTableViewCell *styleCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    self.imgsArray = self.footerView.dataArray;
    if (isNullStr(titleCell.describeTextField.text)) {
        [LCProgressHUD showMessage:@"题标为空"];
        return NO;
    }
    if (isNullStr(areaCell.describeTextField.text)) {
        [LCProgressHUD showMessage:@"面积为空"];
        return NO;
    }
    if ([houseCell.describeButton.titleLabel.text isEqualToString:@"请选择户型"]) {
        [LCProgressHUD showMessage:@"户型为空"];
        return NO;
    }
    if ([styleCell.describeButton.titleLabel.text isEqualToString:@"请选择风格"]) {
        [LCProgressHUD showMessage:@"风格为空"];
        return NO;
    }
    if (isNullArray(self.imgsArray)) {
        [LCProgressHUD showMessage:@"请至少上传一张图片"];
        return NO;
    }
    self.titleString = titleCell.describeTextField.text;
    self.areaString = areaCell.describeTextField.text;
    self.desribeString = self.footerView.describeText.text;
    return YES;
}

#pragma mark - Getters And Setters
/* getter和setter全部都放在最后*/
- (KNBHomeUploadCaseFooterView *)footerView {
    KNB_WS(weakSelf);
    if (!_footerView) {
        _footerView = [[KNBHomeUploadCaseFooterView alloc] init];
        _footerView.titleLabel.text = @"案例描述:";
        _footerView.imgsCount = weakSelf.imgsCount;
        _footerView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, [KNBHomeUploadCaseTableViewCell cellHeight:self.imgsArray.count] + 100);
        _footerView.addCaseBlock = ^(NSMutableArray * _Nonnull imgsArray) {
            weakSelf.knGroupTableView.tableFooterView.height = [KNBHomeUploadCaseTableViewCell cellHeight:imgsArray.count] + 100;
            [weakSelf.knGroupTableView setTableFooterView:weakSelf.footerView];
        };
    }
    return _footerView;
}
@end
