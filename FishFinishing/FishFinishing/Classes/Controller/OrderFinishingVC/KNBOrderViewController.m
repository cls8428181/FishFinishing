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
#import "KNBRecruitmentPriceModel.h"
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

@interface KNBOrderViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) KNBOrderFooterView *footerView;
//入驻商家模型
@property (nonatomic, strong) KNBRecruitmentModel *recruitmentModel;
//免费预约模型
@property (nonatomic, strong) KNBOrderModel *orderModel;
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
    self.knGroupTableView.backgroundColor = [UIColor whiteColor];
}

- (void)addUI {
    [self.view addSubview:self.knGroupTableView];
}

- (void)fetchData {
    
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
                KNBOrderAddressTableViewCell *typeCell = (KNBOrderAddressTableViewCell *)cell;
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
            } else {
                cell = [KNBOrderTextfieldTableViewCell cellWithTableView:tableView];
                KNBOrderTextfieldTableViewCell *typeCell = (KNBOrderTextfieldTableViewCell *)cell;
                typeCell.type = KNBOrderTextFieldTypePhone;
            }
        } else {
            cell = [KNBRecruitmentEnterTableViewCell cellWithTableView:tableView];
            KNBRecruitmentEnterTableViewCell *typeCell = (KNBRecruitmentEnterTableViewCell *)cell;
            typeCell.type = KNBRecruitmentEnterTypeOrder;
            typeCell.selectButtonBlock = ^(UIButton * _Nonnull button) {
                
            };
        }
    } else {//商家入驻
        if (indexPath.section == 0) {
            cell = [KNBOrderDownTableViewCell cellWithTableView:tableView];
            KNBOrderDownTableViewCell *typeCell = (KNBOrderDownTableViewCell *)cell;
            typeCell.type = KNBOrderDownTypeRecruitment;
            
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell = [KNBOrderTextfieldTableViewCell cellWithTableView:tableView];
                KNBOrderTextfieldTableViewCell *typeCell = (KNBOrderTextfieldTableViewCell *)cell;
                typeCell.type = KNBOrderTextFieldTypeShopName;
            } else {
                cell = [KNBRecruitmentPortraitTableViewCell cellWithTableView:tableView];
            }
            
        } else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                cell = [KNBOrderTextfieldTableViewCell cellWithTableView:tableView];
                KNBOrderTextfieldTableViewCell *typeCell = (KNBOrderTextfieldTableViewCell *)cell;
                typeCell.type = KNBOrderTextFieldTypeLocation;
            } else if (indexPath.row == 1) {
                cell = [KNBOrderTextfieldTableViewCell cellWithTableView:tableView];
                KNBOrderTextfieldTableViewCell *typeCell = (KNBOrderTextfieldTableViewCell *)cell;
                typeCell.type = KNBOrderTextFieldTypeShopPhone;
            } else {
                cell = [KNBRecruitmentDomainTableViewCell cellWithTableView:tableView];
                KNBRecruitmentDomainTableViewCell *typeCell = (KNBRecruitmentDomainTableViewCell *)cell;
            }
            
        } else if (indexPath.section == 3) {
            cell = [KNBOrderDownTableViewCell cellWithTableView:tableView];
            KNBOrderDownTableViewCell *typeCell = (KNBOrderDownTableViewCell *)cell;
            typeCell.type = KNBOrderDownTypeShowPrice;
        } else if (indexPath.section == 4) {
            cell = [KNBRecruitmentDomainTableViewCell cellWithTableView:tableView];
            KNBRecruitmentDomainTableViewCell *typeCell = (KNBRecruitmentDomainTableViewCell *)cell;
            typeCell.type = KNBRecruitmentDomainTypeService;
        } else if (indexPath.section == 5) {
            cell = [KNBRecruitmentIntroTableViewCell cellWithTableView:tableView];
            KNBRecruitmentIntroTableViewCell *typeCell = (KNBRecruitmentIntroTableViewCell *)cell;
        } else {
            cell = [KNBRecruitmentEnterTableViewCell cellWithTableView:tableView];
            KNBRecruitmentEnterTableViewCell *typeCell = (KNBRecruitmentEnterTableViewCell *)cell;
            typeCell.type = KNBRecruitmentEnterTypeRecruitment;
            typeCell.selectButtonBlock = ^(UIButton * _Nonnull button) {
                if (weakSelf.VCType == KNBOrderVCTypeOrderFinishing) {
                    [weakSelf enterOrderFinishing];
                } else {
                    [weakSelf enterRecruitment];
                }
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
        if (indexPath.section == 0) {
            [self recruitmentTypeRequest];
            
        } else if (indexPath.section == 1 && indexPath.row == 1) {
            [self unitRequest];
        } else if (indexPath.section == 2 && indexPath.row == 1) {
            [KNBAddressPickerView showAddressPickerWithDefaultSelected:nil resultBlock:^(KNBCityModel *province, KNBCityModel *city, KNBCityModel *area) {
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
                [BRStringPickerView showStringPickerWithTitle:@"选择档次" dataSource:@[@"低",@"中",@"高",@"豪华"] defaultSelValue:nil resultBlock:^(id selectValue) {
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
            
        } else if (indexPath.section == 2 && indexPath.row == 2) {
            self.recruitmentModel.typeModel ? [self bestDomainRequest] : [LCProgressHUD showMessage:@"请先选择入驻类型"];
            
        } else if (indexPath.section == 3 && indexPath.row == 0) {
            self.recruitmentModel.typeModel ? [self showPriceRequest] : [LCProgressHUD showMessage:@"请先选择入驻类型"];

        } else if (indexPath.section == 4) {
            [self chooseServiceRequest];
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
            [weakSelf requestSuccess:NO requestEnd:NO];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [weakSelf requestSuccess:NO requestEnd:NO];
    }];
}

//请求擅长领域数据
- (void)bestDomainRequest {
//    KNBRecruitmentDomainApi *api = [[KNBRecruitmentDomainApi alloc] initWithCatId:[self.recruitmentModel.typeModel.typeId integerValue]];
//    api.hudString = @"";
    KNB_WS(weakSelf);
//    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
//        if (api.requestSuccess) {
//            NSDictionary *dic = request.responseObject[@"list"];
//            NSMutableArray *modelArray = [KNBRecruitmentTypeModel changeResponseJSONObject:dic];
//            NSMutableArray *dataArray = [NSMutableArray array];
//            for (int i = 0; i < modelArray.count; i++) {
//                KNBRecruitmentTypeModel *model = modelArray[i];
//                [dataArray addObject:model.tagName];
//            }
//            [BRStringPickerView showStringPickerWithTitle:@"选择擅长领域" dataSource:dataArray defaultSelValue:nil resultBlock:^(id selectValue) {
//            }];
//        } else {
//            [weakSelf requestSuccess:NO requestEnd:NO];
//        }
//    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
//        [weakSelf requestSuccess:NO requestEnd:NO];
//    }];
    [BRTagsPickerView showTagsPickerWithTitle:@"擅长领域" dataSource:@[@"装修",@"漂亮",@"大的方",@"漂亮漂亮",@"大漂亮漂亮方"] defaultSelValue:nil resultBlock:^(id selectValue) {
        KNBRecruitmentDomainTableViewCell *cell = [weakSelf.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:2]];
        [cell setTagsViewDataSource:selectValue];
    } cancelBlock:^{
        
    } maximumNumberBlock:^{
        [LCProgressHUD showMessage:@"您最多只能选择三个标签哦"];
    }];
    
}

//请求选择服务数据
- (void)chooseServiceRequest {
    //    KNBRecruitmentDomainApi *api = [[KNBRecruitmentDomainApi alloc] initWithCatId:[self.recruitmentModel.typeModel.typeId integerValue]];
    //    api.hudString = @"";
    KNB_WS(weakSelf);
    //    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
    //        if (api.requestSuccess) {
    //            NSDictionary *dic = request.responseObject[@"list"];
    //            NSMutableArray *modelArray = [KNBRecruitmentTypeModel changeResponseJSONObject:dic];
    //            NSMutableArray *dataArray = [NSMutableArray array];
    //            for (int i = 0; i < modelArray.count; i++) {
    //                KNBRecruitmentTypeModel *model = modelArray[i];
    //                [dataArray addObject:model.tagName];
    //            }
    //            [BRStringPickerView showStringPickerWithTitle:@"选择擅长领域" dataSource:dataArray defaultSelValue:nil resultBlock:^(id selectValue) {
    //            }];
    //        } else {
    //            [weakSelf requestSuccess:NO requestEnd:NO];
    //        }
    //    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
    //        [weakSelf requestSuccess:NO requestEnd:NO];
    //    }];
    [BRTagsPickerView showTagsPickerWithTitle:@"服务选择" dataSource:@[@"装修",@"漂亮",@"大的方",@"漂亮漂亮",@"大漂亮漂亮方"] defaultSelValue:nil resultBlock:^(id selectValue) {
        KNBRecruitmentDomainTableViewCell *cell = [weakSelf.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
        [cell setTagsViewDataSource:selectValue];
    } cancelBlock:^{
        
    } maximumNumberBlock:^{
        [LCProgressHUD showMessage:@"您最多只能选择三个标签哦"];
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
                
                [dataArray addObject:[NSString stringWithFormat:@"%@元/年",model.price]];
            }
            [BRStringPickerView showStringPickerWithTitle:@"选择费用" dataSource:dataArray defaultSelValue:nil resultBlock:^(id selectValue) {
                KNBOrderDownTableViewCell *cell = [weakSelf.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
                [cell setButtonTitle:selectValue];
            }];
        } else {
            [weakSelf requestSuccess:NO requestEnd:NO];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [weakSelf requestSuccess:NO requestEnd:NO];
    }];
}

//请求服务类型数据
- (void)serverTypeRequest {
    KNBOrderServerTypeApi *api = [[KNBOrderServerTypeApi alloc] init];
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
            [BRStringPickerView showStringPickerWithTitle:@"选择服务" dataSource:titleArray defaultSelValue:nil resultBlock:^(id selectValue) {
                KNBOrderDownTableViewCell *cell = [weakSelf.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                [cell setButtonTitle:selectValue];
            }];
        } else {
            [weakSelf requestSuccess:NO requestEnd:NO];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [weakSelf requestSuccess:NO requestEnd:NO];
    }];
}

//立即入驻
- (void)enterRecruitment {
    KNBRecruitmentPayViewController *payVC = [[KNBRecruitmentPayViewController alloc] init];
    [self.navigationController pushViewController:payVC animated:YES];
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
            [BRChoicePickerView showTagsPickerWithTitle:@"选择户型" dataSource:modelArray resultBlock:^(id selectValue) {
                NSArray *tempArray = (NSArray *)selectValue;
                KNBOrderDownTableViewCell *cell = [weakSelf.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                [cell setButtonTitle:[NSString stringWithFormat:@"%ld室、%ld厅、%ld厨、%ld卫、%ld阳台",
                                      [tempArray[0] integerValue],
                                      [tempArray[1] integerValue],
                                      [tempArray[2] integerValue],
                                      [tempArray[3] integerValue],
                                      [tempArray[4] integerValue]
                                      ]];
                weakSelf.orderModel.house_info = [NSString stringWithFormat:@"%ld室%ld厅%ld厨%ld卫%ld阳台",
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
                KNBOrderDownTableViewCell *cell = [weakSelf.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
                [cell setButtonTitle:selectValue];
                weakSelf.orderModel.style = selectValue;
            }];
        } else {
            [weakSelf requestSuccess:NO requestEnd:NO];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [weakSelf requestSuccess:NO requestEnd:NO];
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
    KNBOrderTextfieldTableViewCell *araeCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    KNBOrderTextfieldTableViewCell *communityCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    KNBOrderTextfieldTableViewCell *nameCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
    KNBOrderTextfieldTableViewCell *mobileCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:4]];
    self.orderModel.area_info = araeCell.describeTextField.text;
    self.orderModel.community = communityCell.describeTextField.text;
    self.orderModel.name = nameCell.describeTextField.text;
    self.orderModel.mobile = mobileCell.describeTextField.text;
    if (!self.orderModel.typeModel) {
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
    if (isNullStr(self.orderModel.mobile)) {
        [LCProgressHUD showMessage:@"电话不能为空"];
        return;
    }
    KNBHomeBespokeApi *api = [[KNBHomeBespokeApi alloc] initWithfacId:@"0" facName:[NSNull null] catId:self.orderModel.typeModel.selectSubModel.typeId userId:@"" areaInfo:self.orderModel.area_info houseInfo:self.orderModel.house_info community:self.orderModel.community provinceId:self.orderModel.province_id cityId:self.orderModel.city_id areaId:self.orderModel.area_id decorateStyle:self.orderModel.style decorateGrade:self.orderModel.level name:self.orderModel.name mobile:self.orderModel.mobile decorateCat:[NSNull null]];
    api.hudString = @"";
    KNB_WS(weakSelf);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            [LCProgressHUD showMessage:@"您已经预约成功"];
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

- (KNBRecruitmentModel *)recruitmentModel {
    if (!_recruitmentModel) {
        _recruitmentModel = [[KNBRecruitmentModel alloc] init];
    }
    return _recruitmentModel;
}

@end
