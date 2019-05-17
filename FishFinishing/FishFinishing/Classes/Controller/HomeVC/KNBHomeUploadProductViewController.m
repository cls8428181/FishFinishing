//
//  KNBHomeUploadProductViewController.m
//  FishFinishing
//
//  Created by apple on 2019/4/23.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBHomeUploadProductViewController.h"
#import "KNBOrderTextfieldTableViewCell.h"
#import "KNBHomeUploadCaseTableViewCell.h"
#import "KNBRecruitmentAddCaseApi.h"
#import "KNBRecruitmentTypeModel.h"
#import "KNBUploadFileApi.h"
#import "KNBHomeUploadCaseFooterView.h"

@interface KNBHomeUploadProductViewController ()
//图片数组
@property (nonatomic, strong) NSMutableArray *imgsArray;
//产品名称
@property (nonatomic, copy) NSString *productNameStr;
//产品价格
@property (nonatomic, copy) NSString *productPriceStr;
//案例描述
@property (nonatomic, copy) NSString *desribeString;
//图片数组
@property (nonatomic, strong) NSMutableArray *heightArray;

@property (nonatomic, strong) KNBHomeUploadCaseFooterView *footerView;
@end

@implementation KNBHomeUploadProductViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configuration];
    
    [self addUI];
}

#pragma mark - Utils
- (void)configuration {
    self.naviView.title = @"产品上传";
    [self.naviView addLeftBarItemImageName:@"knb_back_black" target:self sel:@selector(backAction)];
    [self.naviView addRightBarItemTitle:@"保存" target:self sel:@selector(saveAction)];
    [self.naviView.rightNaviButton setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor knBgColor];
}

- (void)addUI {
    [self.view addSubview:self.knGroupTableView];
    self.knGroupTableView.backgroundColor = [UIColor colorWithHex:0xfafafa];
    self.knGroupTableView.tableFooterView = self.footerView;
}

#pragma mark - tableview delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = [KNBOrderTextfieldTableViewCell cellWithTableView:tableView];
            KNBOrderTextfieldTableViewCell *typeCell = (KNBOrderTextfieldTableViewCell *)cell;
            typeCell.type = KNBOrderTextFieldTypeProductName;
        }  else {
            cell = [KNBOrderTextfieldTableViewCell cellWithTableView:tableView];
            KNBOrderTextfieldTableViewCell *typeCell = (KNBOrderTextfieldTableViewCell *)cell;
            typeCell.type = KNBOrderTextFieldTypeProductPrice;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? [KNBOrderTextfieldTableViewCell cellHeight] :[KNBHomeUploadCaseTableViewCell cellHeight:self.heightArray.count] + 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] init];
    sectionView.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
    return sectionView;
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
                KNBRecruitmentAddCaseApi *api = [[KNBRecruitmentAddCaseApi alloc] initWithTitle:self.productNameStr price:self.productPriceStr imgs:imgsUrl];
                api.hudString = @"";
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
    KNBOrderTextfieldTableViewCell *nameCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    KNBOrderTextfieldTableViewCell *priceCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    self.imgsArray = self.footerView.dataArray;
    if (isNullStr(nameCell.describeTextField.text)) {
        [LCProgressHUD showMessage:@"产品名称为空"];
        return NO;
    }
    if (isNullStr(priceCell.describeTextField.text)) {
        [LCProgressHUD showMessage:@"产品价格为空"];
        return NO;
    }
    if (isNullArray(self.imgsArray)) {
        [LCProgressHUD showMessage:@"请至少上传一张图片"];
        return NO;
    }
    self.productNameStr = nameCell.describeTextField.text;
    self.productPriceStr = priceCell.describeTextField.text;
    self.desribeString = self.footerView.describeText.text;
    return YES;
}

#pragma mark - Getters And Setters
/* getter和setter全部都放在最后*/
- (KNBHomeUploadCaseFooterView *)footerView {
    KNB_WS(weakSelf);
    if (!_footerView) {
        _footerView = [[KNBHomeUploadCaseFooterView alloc] init];
        _footerView.titleLabel.text = @"产品描述:";
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
