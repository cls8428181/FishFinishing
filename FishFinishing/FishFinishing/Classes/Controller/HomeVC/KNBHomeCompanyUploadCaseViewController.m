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

@interface KNBHomeCompanyUploadCaseViewController ()
//图片数组
@property (nonatomic, strong) NSMutableArray *imgsArray;
@property (nonatomic, strong) NSMutableArray *imgsUrlArray;
//面积
@property (nonatomic, copy) NSString *areaString;
//户型
@property (nonatomic, copy) NSString *houseString;
//风格
@property (nonatomic, strong) KNBRecruitmentTypeModel *styleModel;
//案例描述
@property (nonatomic, copy) NSString *desribeString;
//图片参数
@property (nonatomic, copy) NSString *imgString;
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
    [self.naviView addRightBarItemImageName:@"knb_me_baocun" target:self sel:@selector(saveAction)];
    self.view.backgroundColor = [UIColor knBgColor];
}

- (void)addUI {
    [self.view addSubview:self.knGroupTableView];
    self.knGroupTableView.backgroundColor = [UIColor colorWithHex:0xfafafa];
}

#pragma mark - tableview delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 3 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = [KNBOrderTextfieldTableViewCell cellWithTableView:tableView];
            KNBOrderTextfieldTableViewCell *typeCell = (KNBOrderTextfieldTableViewCell *)cell;
            typeCell.type = KNBOrderTextFieldTypeArea;
        } else if (indexPath.row == 1) {
            cell = [KNBOrderDownTableViewCell cellWithTableView:tableView];
            KNBOrderDownTableViewCell *typeCell = (KNBOrderDownTableViewCell *)cell;
            typeCell.type = KNBOrderDownTypeHouse;
        } else {
            cell = [KNBOrderDownTableViewCell cellWithTableView:tableView];
            KNBOrderDownTableViewCell *typeCell = (KNBOrderDownTableViewCell *)cell;
            typeCell.type = KNBOrderDownTypeStyle;
        }
    } else {
        cell = [KNBHomeUploadCaseTableViewCell cellWithTableView:tableView];

    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? [KNBOrderDownTableViewCell cellHeight] :[KNBHomeUploadCaseTableViewCell cellHeight:self.imgsArray.count] + 100;
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
        if (indexPath.row == 1) {
            [self unitRequest];
        }
        if (indexPath.row == 2) {
            [self finishingStyleRequest];
        }
    }
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
            [BRChoicePickerView showTagsPickerWithTitle:@"选择户型" dataSource:modelArray resultBlock:^(id selectValue) {
                NSArray *tempArray = (NSArray *)selectValue;
                KNBOrderDownTableViewCell *cell = [weakSelf.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                [cell setButtonTitle:[NSString stringWithFormat:@"%ld室、%ld厅、%ld厨、%ld卫、%ld阳台",
                                      [tempArray[0] integerValue],
                                      [tempArray[1] integerValue],
                                      [tempArray[2] integerValue],
                                      [tempArray[3] integerValue],
                                      [tempArray[4] integerValue]
                                      ]];
                weakSelf.houseString = [NSString stringWithFormat:@"%ld室%ld厅%ld厨%ld卫%ld阳台",
                                                  [tempArray[0] integerValue],
                                                  [tempArray[1] integerValue],
                                                  [tempArray[2] integerValue],
                                                  [tempArray[3] integerValue],
                                                  [tempArray[4] integerValue]
                                                  ];
            } cancelBlock:^{
                
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
                KNBOrderDownTableViewCell *cell = [weakSelf.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                [cell setButtonTitle:selectValue];
                weakSelf.styleModel.catName = selectValue;
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
        KNBRecruitmentAddCaseApi *api = [[KNBRecruitmentAddCaseApi alloc] initWithToken:[KNBUserInfo shareInstance].token title:self.desribeString styleId:[self.styleModel.typeId integerValue] acreage:[self.areaString doubleValue] apartment:self.houseString imgs:self.imgString];
        api.hudString = @"";
        KNB_WS(weakSelf);
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
            if (api.requestSuccess) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                !weakSelf.saveSuccessBlock ?: weakSelf.saveSuccessBlock();
            } else {
                [LCProgressHUD showMessage:@"保存失败,请重新保存"];
            }
        } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
            [LCProgressHUD showMessage:@"保存失败,请重新保存"];
        }];
    }
}

- (BOOL)checkInfoComplete {
    KNBOrderTextfieldTableViewCell *areaCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    KNBOrderDownTableViewCell *houseCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    KNBHomeUploadCaseTableViewCell *caseCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if (isNullStr(areaCell.describeTextField.text) || isNullStr(houseCell.describeButton.titleLabel.text) || isNullStr(caseCell.describeText.text)) {
        return NO;
    }
    self.areaString = areaCell.describeTextField.text;
    self.houseString = houseCell.describeButton.titleLabel.text;
    self.desribeString = caseCell.describeText.text;
    return YES;
}

#pragma mark - Getters And Setters
/* getter和setter全部都放在最后*/
- (NSString *)imgString {
    NSString *string = nil;
    for (NSString *img in self.imgsUrlArray) {
        string = [string stringByAppendingString:img];
        string = [string stringByAppendingString:@","];
    }
    return [string substringToIndex:[string length]-1];
}


@end
