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
#import "KNBAddressPickerView.h"
#import "BRStringPickerView.h"
#import "BRLinkagePickerView.h"
#import "KNBRecruitmentPayViewController.h"
#import "KNBRecruitmentTypeApi.h"
#import "KNBRecruitmentTypeModel.h"
#import "KNBOrderServerTypeApi.h"
#import "KNBRecruitmentDomainApi.h"
#import "KNBRecruitmentCostApi.h"
#import "KNBRecruitmentModel.h"
#import "KNBRecruitmentPortraitTableViewCell.h"
#import "KNBRecruitmentEnterTableViewCell.h"
#import "KNBRecruitmentDomainTableViewCell.h"
#import <Photos/Photos.h>
#import "KNBAlertRemind.h"
#import "KNBRecruitmentIntroTableViewCell.h"
#import "BRTagsPickerView.h"
#import "KNBOrderModel.h"
#import "KNBOrderAreaApi.h"
#import "KNBOrderStyleApi.h"
#import "BRChoicePickerView.h"
#import "KNBOrderUnitApi.h"
#import "KNBHomeBespokeApi.h"
#import "KNBRecruitmentPayViewController.h"
#import "UITextView+ZWPlaceHolder.h"
#import "KNBUploadFileApi.h"
#import "MPFindNearAddressVC.h"

@interface KNBOrderViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
//入驻商家模型
@property (nonatomic, strong) KNBRecruitmentModel *recruitmentModel;
//免费预约模型
@property (nonatomic, strong) KNBOrderModel *orderModel;
//记录最后一个输入框
@property (nonatomic, strong) UITextField *lastTextField;
@end

@implementation KNBOrderViewController
#pragma mark - life cycle

- (instancetype)init {
    if (self = [super init]) {
        _isStyleEnable = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configuration];
    
    [self addUI];
}

#pragma mark - Utils
- (void)configuration {
    self.naviView.title = self.VCType == KNBOrderVCTypeOrderFinishing ? @"预约" : @"商家入驻";
    [self.naviView addLeftBarItemImageName:@"knb_back_black" target:self sel:@selector(backAction)];
    self.view.backgroundColor = [UIColor knBgColor];
    self.knGroupTableView.backgroundColor = [UIColor whiteColor];
}

- (void)addUI {
    [self.view addSubview:self.knGroupTableView];
}

#pragma mark - tableview delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.VCType == KNBOrderVCTypeOrderFinishing ? 6 : 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.VCType == KNBOrderVCTypeOrderFinishing) {//免费预约
        if (section == 0 || section == 5) {
            return 1;
        } else {
            return 2;
        }
    } else {//商家入驻
        if (section == 1) {
            return 2;
        } else if (section == 2) {
            return 3;
        } else {
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    KNB_WS(weakSelf);
    if (self.VCType == KNBOrderVCTypeOrderFinishing) {//免费预约
        if (indexPath.section == 0) {
            cell = [KNBOrderDownTableViewCell cellWithTableView:tableView];
            KNBOrderDownTableViewCell *typeCell = (KNBOrderDownTableViewCell *)cell;
            typeCell.type =KNBOrderDownTypeServer;
            if (self.recruitmentModel.typeModel) {
                [typeCell setButtonTitle:[NSString stringWithFormat:@"%@ %@",self.recruitmentModel.typeModel.catName,self.recruitmentModel.typeModel.selectSubModel.catName]];
            }
            if (!self.isStyleEnable) {
                [typeCell setButtonTitle:[NSString stringWithFormat:@"%@ %@",self.model.parent_cat_name,self.model.cat_name]];
            }
                    
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell = [KNBOrderTextfieldTableViewCell cellWithTableView:tableView];
                KNBOrderTextfieldTableViewCell *typeCell = (KNBOrderTextfieldTableViewCell *)cell;
                typeCell.type = KNBOrderTextFieldTypeArea;
                typeCell.describeTextField.delegate = self;
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
                typeCell.describeTextField.delegate = self;
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
            
        } else if (indexPath.section == 4) {
            if (indexPath.row == 0) {
                cell = [KNBOrderTextfieldTableViewCell cellWithTableView:tableView];
                KNBOrderTextfieldTableViewCell *typeCell = (KNBOrderTextfieldTableViewCell *)cell;
                typeCell.type = KNBOrderTextFieldTypeName;
                typeCell.describeTextField.delegate = self;
            } else {
                cell = [KNBOrderTextfieldTableViewCell cellWithTableView:tableView];
                KNBOrderTextfieldTableViewCell *typeCell = (KNBOrderTextfieldTableViewCell *)cell;
                typeCell.type = KNBOrderTextFieldTypePhone;
                typeCell.describeTextField.text = [KNBUserInfo shareInstance].mobile;
                typeCell.userInteractionEnabled = NO;
            }
        } else {
            cell = [KNBRecruitmentEnterTableViewCell cellWithTableView:tableView];
            KNBRecruitmentEnterTableViewCell *typeCell = (KNBRecruitmentEnterTableViewCell *)cell;
            typeCell.type = KNBRecruitmentEnterTypeOrder;
            typeCell.selectButtonBlock = ^(UIButton * _Nonnull button) {
                [weakSelf enterOrderFinishing];
            };
        }
    } else {//商家入驻
        if (indexPath.section == 0) {
            cell = [KNBOrderDownTableViewCell cellWithTableView:tableView];
            KNBOrderDownTableViewCell *typeCell = (KNBOrderDownTableViewCell *)cell;
            typeCell.type = KNBOrderDownTypeRecruitment;
            if (self.recruitmentModel.typeModel) {
                [typeCell setButtonTitle:[NSString stringWithFormat:@"%@ %@",self.recruitmentModel.typeModel.catName,self.recruitmentModel.typeModel.selectSubModel.catName]];
            }
            
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell = [KNBOrderTextfieldTableViewCell cellWithTableView:tableView];
                KNBOrderTextfieldTableViewCell *typeCell = (KNBOrderTextfieldTableViewCell *)cell;
                typeCell.type = KNBOrderTextFieldTypeShopName;
                typeCell.describeTextField.delegate = self;

                if (!isNullStr(self.recruitmentModel.name)) {
                    typeCell.describeTextField.text = self.recruitmentModel.name;
                }
            } else {
                cell = [KNBRecruitmentPortraitTableViewCell cellWithTableView:tableView];
            }
            
        } else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                cell = [KNBOrderTextfieldTableViewCell cellWithTableView:tableView];
                KNBOrderTextfieldTableViewCell *typeCell = (KNBOrderTextfieldTableViewCell *)cell;
                typeCell.type = KNBOrderTextFieldTypeLocation;
                typeCell.describeTextField.userInteractionEnabled = NO;

                if (!isNullStr(self.recruitmentModel.address)) {
                    typeCell.describeTextField.text = self.recruitmentModel.address;
                }
            } else if (indexPath.row == 1) {
                cell = [KNBOrderTextfieldTableViewCell cellWithTableView:tableView];
                KNBOrderTextfieldTableViewCell *typeCell = (KNBOrderTextfieldTableViewCell *)cell;
                typeCell.type = KNBOrderTextFieldTypeShopPhone;
                typeCell.describeTextField.delegate = self;

                if (!isNullStr(self.recruitmentModel.telephone)) {
                    typeCell.describeTextField.text = self.recruitmentModel.telephone;
                }
            } else {
                cell = [KNBRecruitmentDomainTableViewCell cellWithTableView:tableView];
                KNBRecruitmentDomainTableViewCell *typeCell = (KNBRecruitmentDomainTableViewCell *)cell;
                typeCell.type = KNBRecruitmentDomainTypeDefault;
            }
            
        } else if (indexPath.section == 3) {
            cell = [KNBOrderDownTableViewCell cellWithTableView:tableView];
            KNBOrderDownTableViewCell *typeCell = (KNBOrderDownTableViewCell *)cell;
            typeCell.type = KNBOrderDownTypeShowPrice;
            if (self.recruitmentModel.priceModel) {
                [typeCell setButtonTitle:self.recruitmentModel.priceModel.name];
            }
        } else if (indexPath.section == 4) {
            cell = [KNBRecruitmentDomainTableViewCell cellWithTableView:tableView];
            KNBRecruitmentDomainTableViewCell *typeCell = (KNBRecruitmentDomainTableViewCell *)cell;
            typeCell.type = KNBRecruitmentDomainTypeService;
        } else if (indexPath.section == 5) {
            cell = [KNBRecruitmentIntroTableViewCell cellWithTableView:tableView];
            KNBRecruitmentIntroTableViewCell *typeCell = (KNBRecruitmentIntroTableViewCell *)cell;
            typeCell.contentTextView.zw_placeHolder  = @"请输入您的商家简介";
        } else {
            cell = [KNBRecruitmentEnterTableViewCell cellWithTableView:tableView];
            KNBRecruitmentEnterTableViewCell *typeCell = (KNBRecruitmentEnterTableViewCell *)cell;
            typeCell.type = KNBRecruitmentEnterTypeRecruitment;
            typeCell.selectButtonBlock = ^(UIButton * _Nonnull button) {
                [weakSelf enterRecruitment];
            };
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.VCType == KNBOrderVCTypeRecruitment) {
        if (indexPath.section == 5) {
            return [KNBRecruitmentIntroTableViewCell cellHeight];
        }
        if (indexPath.section == 6) {
            return 88;
        }
    }
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
    KNB_WS(weakSelf);

    if (self.VCType == KNBOrderVCTypeOrderFinishing) {//免费预约
        if (indexPath.section == 0 && self.isStyleEnable) {
            [self recruitmentTypeRequest];
            
        } else if (indexPath.section == 1 && indexPath.row == 1) {
            [self unitRequest];
            
        } else if (indexPath.section == 2 && indexPath.row == 1) {
            [KNBAddressPickerView showAddressPickerWithDefaultSelected:@[] resultBlock:^(KNBAddressModel *province, KNBAddressModel *city, KNBAddressModel *area) {
                KNBOrderAddressTableViewCell *cell = [weakSelf.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
                [cell setProvinceName:province.name cityName:city.name areaName:area.name];
                weakSelf.orderModel.province_id = [province.code integerValue];
                weakSelf.orderModel.city_id = [city.code integerValue];
                weakSelf.orderModel.area_id = [area.code integerValue];
            }];
        } else if (indexPath.section == 3) {
            if (indexPath.row == 0) {
                [self finishingStyleRequest];
            } else {
                [BRStringPickerView showStringPickerWithTitle:@"选择档次" dataSource:@[@"高",@"中",@"低"] defaultSelValue:nil resultBlock:^(id selectValue) {
                    KNBOrderDownTableViewCell *cell = [weakSelf.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:3]];
                    [cell setButtonTitle:selectValue];
                    weakSelf.orderModel.level = selectValue;
                }];
            }
        }
    } else {//商家入驻
        if (indexPath.section == 0) {
            [self recruitmentTypeRequest];
            
        } else if (indexPath.section == 1 && indexPath.row == 1) {
            [self changePortrait];
        } else if (indexPath.section == 2 && indexPath.row == 0) {
            MPFindNearAddressVC *vc = [MPFindNearAddressVC new];
            [vc setReturnBlock:^(NSString *city,NSString *area,NSString *name,NSString *address,CGFloat latitude,CGFloat longitude,NSString *phone,UIImage *img){
                if (name) {
                    self.recruitmentModel.cityName = city;
                    self.recruitmentModel.areaName = area;
                    self.recruitmentModel.address = [NSString stringWithFormat:@"%@%@",name,address];
                    self.recruitmentModel.latitude = latitude;
                    self.recruitmentModel.longitude = longitude;
                    KNBOrderTextfieldTableViewCell *addressCell = [tableView cellForRowAtIndexPath:indexPath];
                    addressCell.describeTextField.text = [NSString stringWithFormat:@"%@%@",name,address];
                }
                
            }];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.section == 2 && indexPath.row == 2) {
            self.recruitmentModel.typeModel ? [self bestDomainRequest] : [LCProgressHUD showMessage:@"请先选择入驻类型"];
            
        } else if (indexPath.section == 3 && indexPath.row == 0) {
            self.recruitmentModel.typeModel ? [self showPriceRequest] : [LCProgressHUD showMessage:@"请先选择入驻类型"];

        } else if (indexPath.section == 4) {
            self.recruitmentModel.typeModel ? [self chooseServiceRequest] : [LCProgressHUD showMessage:@"请先选择入驻类型"];
        }
    }
}

#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    NSIndexPath *iconIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    KNBRecruitmentPortraitTableViewCell *iconCell = (KNBRecruitmentPortraitTableViewCell *)[self.knGroupTableView cellForRowAtIndexPath:iconIndexPath];
    
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    iconCell.iconImageView.image = newPhoto;
    self.recruitmentModel.iconImage = newPhoto;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 商家入驻数据请求
//请求入驻类型数据
- (void)recruitmentTypeRequest {
    KNBRecruitmentTypeApi *api = [[KNBRecruitmentTypeApi alloc] init];
    api.hudString = @"";
    KNB_WS(weakSelf);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            NSDictionary *dic = request.responseObject[@"list"];
            NSMutableArray *modelArray = [KNBRecruitmentTypeModel changeResponseJSONObject:dic];
            [BRLinkagePickerView showLinkageStringPickerWithTitle:@"选择类型" dataSource:modelArray defaultSelValue:nil resultBlock:^(id  _Nonnull selectValue) {
                KNBOrderDownTableViewCell *cell = [weakSelf.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                if (!isNullArray(selectValue)) {
                    KNBRecruitmentTypeModel *firstModel = [selectValue firstObject];
                    KNBRecruitmentTypeModel *lastModel = [selectValue lastObject];
                    [cell setButtonTitle:[NSString stringWithFormat:@"%@ %@",firstModel.catName,lastModel.catName]];
                    if (weakSelf.VCType == KNBOrderVCTypeOrderFinishing) {
                        weakSelf.orderModel.typeModel = firstModel;
                        weakSelf.orderModel.typeModel.selectSubModel = lastModel;
                    } else {
                        weakSelf.recruitmentModel.typeModel = firstModel;
                        weakSelf.recruitmentModel.typeModel.selectSubModel = lastModel;
                    }
                }
            } cancelBlock:^{
                
            }];
        } else {
            [LCProgressHUD showMessage:api.errMessage];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [LCProgressHUD showMessage:api.errMessage];
    }];
}

//请求擅长领域数据
- (void)bestDomainRequest {
    KNBRecruitmentDomainApi *api = [[KNBRecruitmentDomainApi alloc] initWithCatId:[self.recruitmentModel.typeModel.typeId integerValue]];
    api.hudString = @"";
    KNB_WS(weakSelf);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            NSDictionary *dic = request.responseObject[@"list"];
            NSMutableArray *modelArray = [KNBRecruitmentDomainModel changeResponseJSONObject:dic];
            NSMutableArray *dataArray = [NSMutableArray array];
            for (int i = 0; i < modelArray.count; i++) {
                KNBRecruitmentDomainModel *model = modelArray[i];
                [dataArray addObject:model.tagName];
            }
            [BRTagsPickerView showTagsPickerWithTitle:@"擅长领域" dataSource:dataArray defaultSelValue:nil resultBlock:^(id selectValue) {
                KNBRecruitmentDomainTableViewCell *cell = [weakSelf.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:2]];
                NSMutableArray *domainArray = [NSMutableArray array];
                for (int i = 0; i < modelArray.count; i++) {
                    KNBRecruitmentDomainModel *model = modelArray[i];
                    for (int j = 0; j < [selectValue count]; j++) {
                        NSString *selectString = [selectValue objectAtIndex:j];
                        if ([model.tagName isEqualToString:selectString]) {
                            [domainArray addObject:model];
                        }
                    }
                }
                [cell setTagsViewDataSource:selectValue];
                weakSelf.recruitmentModel.domainList = domainArray;
            } cancelBlock:^{
                
            } maximumNumberBlock:^{
                [LCProgressHUD showMessage:@"您最多只能选择三个标签哦"];
            }];
        } else {
            [LCProgressHUD showMessage:api.errMessage];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [LCProgressHUD showMessage:api.errMessage];
    }];
}

//请求选择服务数据
- (void)chooseServiceRequest {
    KNBOrderServerTypeApi *api = [[KNBOrderServerTypeApi alloc] initWithCatId:[self.recruitmentModel.typeModel.typeId integerValue]];
    api.hudString = @"";
    KNB_WS(weakSelf);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            NSDictionary *dic = request.responseObject[@"list"];
            NSMutableArray *modelArray = [KNBRecruitmentTypeModel changeResponseJSONObject:dic];
            NSMutableArray *titleArray = [NSMutableArray array];
            for (KNBRecruitmentTypeModel *model in modelArray) {
                [titleArray addObject:model.serviceName];
            }
            [BRTagsPickerView showTagsPickerWithTitle:@"服务选择" dataSource:titleArray defaultSelValue:nil resultBlock:^(id selectValue) {
                KNBRecruitmentDomainTableViewCell *cell = [weakSelf.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
                NSMutableArray *serviceArray = [NSMutableArray array];
                for (int i = 0; i < modelArray.count; i++) {
                    KNBRecruitmentTypeModel *model = modelArray[i];
                    for (int j = 0; j < [selectValue count]; j++) {
                        NSString *selectString = [selectValue objectAtIndex:j];
                        if ([model.serviceName isEqualToString:selectString]) {
                            [serviceArray addObject:model];
                        }
                    }
                }
                
                [cell setTagsViewDataSource:selectValue];
                weakSelf.recruitmentModel.serviceList = serviceArray;

            } cancelBlock:^{
                
            } maximumNumberBlock:^{
                [LCProgressHUD showMessage:@"您最多只能选择三个标签哦"];
            }];
        } else {
            [LCProgressHUD showMessage:api.errMessage];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [LCProgressHUD showMessage:api.errMessage];
    }];
}

//请求入驻费用数据
- (void)showPriceRequest {
    KNBRecruitmentCostApi *api = [[KNBRecruitmentCostApi alloc] initWithCatId:[self.recruitmentModel.typeModel.selectSubModel.typeId integerValue] costType:1];
    api.hudString = @"";
    KNB_WS(weakSelf);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            NSDictionary *dic = request.responseObject[@"list"];
            NSMutableArray *modelArray = [KNBRecruitmentCostModel changeResponseJSONObject:dic];
            NSMutableArray *dataArray = [NSMutableArray array];
            for (int i = 0; i < modelArray.count; i++) {
                KNBRecruitmentCostModel *model = modelArray[i];
                [dataArray addObject:[NSString stringWithFormat:@"%@",model.name]];
            }
            [BRStringPickerView showStringPickerWithTitle:@"选择费用" dataSource:dataArray defaultSelValue:nil resultBlock:^(id selectValue) {
                KNBOrderDownTableViewCell *cell = [weakSelf.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
                [cell setButtonTitle:selectValue];
                for (KNBRecruitmentCostModel *model in modelArray) {
                    if ([model.name isEqualToString:selectValue]) {
                        weakSelf.recruitmentModel.priceModel = model;
                    }
                }
            }];
        } else {
            [LCProgressHUD showMessage:api.errMessage];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [LCProgressHUD showMessage:api.errMessage];
    }];
}

//立即入驻
- (void)enterRecruitment {
    [self.lastTextField resignFirstResponder];
    KNBRecruitmentIntroTableViewCell *introCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:5]];
    self.recruitmentModel.remark = introCell.contentTextView.text;
    if (!self.recruitmentModel.typeModel) {
        [LCProgressHUD showMessage:@"服务类型不能为空"];
        return;
    }
    if (isNullStr(self.recruitmentModel.name)) {
        [LCProgressHUD showMessage:@"商家名称不能为空"];
        return;
    }
    if (!self.recruitmentModel.iconImage) {
        [LCProgressHUD showMessage:@"请选择一张头像"];
        return;
    }
    if (isNullStr(self.recruitmentModel.address)) {
        [LCProgressHUD showMessage:@"地址不能为空"];
        return;
    }
    if (isNullStr(self.recruitmentModel.telephone)) {
        [LCProgressHUD showMessage:@"商家电话不能为空"];
        return;
    }
    if (isNullArray(self.recruitmentModel.domainList)) {
        [LCProgressHUD showMessage:@"擅长领域不能为空"];
        return;
    }
    if (isNullArray(self.recruitmentModel.serviceList)) {
        [LCProgressHUD showMessage:@"服务选择不能为空"];
        return;
    }
    if (isNullStr(self.recruitmentModel.remark)) {
        [LCProgressHUD showMessage:@"简介不能为空"];
        return;
    }
    NSString *openString = [[NSUserDefaults standardUserDefaults] objectForKey:@"OpenPayment"];
    if ([openString isEqualToString:@"1"]) {
        KNBRecruitmentPayViewController *payVC = [[KNBRecruitmentPayViewController alloc] init];
        payVC.recruitmentModel = self.recruitmentModel;
        payVC.type = KNBPayVCTypeRecruitment;
        [self.navigationController pushViewController:payVC animated:YES];
    } else {
        [KNBAlertRemind alterWithTitle:@"提示" message:@"您的入驻申请已提交, 请联系管理员审核" buttonTitles:@[@"知道了"] handler:^(NSInteger index, NSString *title) {
            
        }];
    }
}

#pragma mark - 免费预约数据请求
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
                KNBOrderDownTableViewCell *cell = [weakSelf.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                [cell setButtonTitle:selectValue];
                weakSelf.orderModel.house_info = selectValue;
            }];
        } else {
            [LCProgressHUD showMessage:api.errMessage];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [LCProgressHUD showMessage:api.errMessage];
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
                KNBOrderDownTableViewCell *cell = [weakSelf.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
                [cell setButtonTitle:selectValue];
                weakSelf.orderModel.style = selectValue;
            }];
        } else {
            [LCProgressHUD showMessage:api.errMessage];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [LCProgressHUD showMessage:api.errMessage];
    }];
}

- (void)changePortrait {
    KNB_WS(weakSelf);
    /**
     *  弹出提示框
     */
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            //获取相册权限
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status == PHAuthorizationStatusAuthorized) {
                        [weakSelf pushPhotosController];
                    } else {
                        [KNBAlertRemind alterWithTitle:@"请打开设置开启相册权限后再试" message:@"" buttonTitles:@[ @"我知道了" ] handler:nil];
                    }
                });
            }];
        } else {
            [KNBAlertRemind alterWithTitle:@"您的设备不支持相册" message:@"" buttonTitles:@[ @"我知道了" ] handler:nil];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            NSString *mediaType = AVMediaTypeVideo;
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
            if (authStatus == AVAuthorizationStatusAuthorized || authStatus == AVAuthorizationStatusNotDetermined) {
                [weakSelf pushCameraController];
            } else {
                [KNBAlertRemind alterWithTitle:@"请打开设置开启相机权限后再试" message:@"" buttonTitles:@[ @"我知道了" ] handler:nil];
            }
        } else {
            [KNBAlertRemind alterWithTitle:@"您的设备不支持相机" message:@"" buttonTitles:@[ @"我知道了" ] handler:nil];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)pushPhotosController {
    UIImagePickerController *PickerImage = [[UIImagePickerController alloc] init];
    PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    PickerImage.allowsEditing = YES;
    PickerImage.delegate = self;
    PickerImage.navigationBar.tintColor = [UIColor colorWithHex:0x333333];
    [self presentViewController:PickerImage animated:YES completion:nil];
}

- (void)pushCameraController {
    UIImagePickerController *PickerImage = [[UIImagePickerController alloc] init];
    //获取方式:通过相机
    PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
    PickerImage.allowsEditing = YES;
    PickerImage.delegate = self;
    [self presentViewController:PickerImage animated:YES completion:nil];
}

//免费预约
- (void)enterOrderFinishing {
    [self.lastTextField resignFirstResponder];
    if (!self.orderModel.typeModel && self.isStyleEnable) {
        [LCProgressHUD showMessage:@"服务类型不能为空"];
        return;
    }
    if (isNullStr(self.orderModel.area_info)) {
        [LCProgressHUD showMessage:@"面积不能为空"];
        return;
    }
    if (isNullStr(self.orderModel.house_info)) {
        [LCProgressHUD showMessage:@"户型不能为空"];
        return;
    }
    if (isNullStr(self.orderModel.community)) {
        [LCProgressHUD showMessage:@"小区名称不能为空"];
        return;
    }
    if (!self.orderModel.city_id || !self.orderModel.area_id) {
        [LCProgressHUD showMessage:@"地址不能为空"];
        return;
    }
    if (isNullStr(self.orderModel.style)) {
        [LCProgressHUD showMessage:@"风格不能为空"];
        return;
    }
    if (isNullStr(self.orderModel.level)) {
        [LCProgressHUD showMessage:@"装修档次不能为空"];
        return;
    }
    if (isNullStr(self.orderModel.name)) {
        [LCProgressHUD showMessage:@"姓名不能为空"];
        return;
    }
    KNB_WS(weakSelf);
    KNBOrderTextfieldTableViewCell *mobileCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:4]];
    self.orderModel.mobile = mobileCell.describeTextField.text;
    KNBHomeBespokeApi *api = [[KNBHomeBespokeApi alloc] initWithFacId:0 facName:@"" catId:self.isStyleEnable ? [self.orderModel.typeModel.selectSubModel.typeId integerValue] : [self.model.cat_id integerValue] userId:@"" areaInfo:self.orderModel.area_info houseInfo:self.orderModel.house_info community:self.orderModel.community provinceId:self.orderModel.province_id cityId:self.orderModel.city_id areaId:self.orderModel.area_id decorateStyle:self.orderModel.style decorateGrade:self.orderModel.level name:self.orderModel.name mobile:self.orderModel.mobile decorateCat:@"" type:2];
    api.hudString = @"";
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            [KNBAlertRemind alterWithTitle:@"提示" message:@"您已经预约成功" buttonTitles:@[@"我知道了"] handler:^(NSInteger index, NSString *title) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            [LCProgressHUD showMessage:api.errMessage];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [LCProgressHUD showMessage:api.errMessage];
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.lastTextField resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.VCType == KNBOrderVCTypeOrderFinishing) {
        KNBOrderTextfieldTableViewCell *araeCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        KNBOrderTextfieldTableViewCell *communityCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
        KNBOrderTextfieldTableViewCell *nameCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
        if ([textField isEqual:araeCell.describeTextField]) {
            self.orderModel.area_info = textField.text;
        }
        if ([textField isEqual:communityCell.describeTextField]) {
            self.orderModel.community = textField.text;
        }
        if ([textField isEqual:nameCell.describeTextField]) {
            self.orderModel.name = textField.text;
        }
    } else {
        KNBOrderTextfieldTableViewCell *nickCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        KNBOrderTextfieldTableViewCell *addressCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
        KNBOrderTextfieldTableViewCell *mobileCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
        if ([textField isEqual:nickCell.describeTextField]) {
            self.recruitmentModel.name = textField.text;
        }
        if ([textField isEqual:addressCell.describeTextField]) {
            self.recruitmentModel.address = textField.text;
        }
        if ([textField isEqual:mobileCell.describeTextField]) {
            self.recruitmentModel.telephone = textField.text;
        }
        if ([textField isEqual:mobileCell.describeTextField]) {
            self.orderModel.mobile = textField.text;
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.lastTextField = textField;
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
- (KNBRecruitmentModel *)recruitmentModel {
    if (!_recruitmentModel) {
        _recruitmentModel = [[KNBRecruitmentModel alloc] init];
    }
    return _recruitmentModel;
}

- (KNBOrderModel *)orderModel {
    if (!_orderModel) {
        _orderModel = [[KNBOrderModel alloc] init];
    }
    return _orderModel;
}

@end
