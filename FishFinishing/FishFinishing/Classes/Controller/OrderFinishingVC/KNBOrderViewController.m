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

@interface KNBOrderViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) KNBOrderFooterView *footerView;
//入驻商家模型
@property (nonatomic, strong) KNBRecruitmentModel *recruitmentModel;
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
    if (section == 0) {
        return 1;
    } else {
        if (self.VCType == KNBOrderVCTypeOrderFinishing) {
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
        typeCell.type = self.VCType == KNBOrderVCTypeOrderFinishing ? KNBOrderDownTypeServer : KNBOrderDownTypeRecruitment;
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell = [KNBOrderTextfieldTableViewCell cellWithTableView:tableView];
            KNBOrderTextfieldTableViewCell *typeCell = (KNBOrderTextfieldTableViewCell *)cell;
            if (self.VCType == KNBOrderVCTypeOrderFinishing) {
                typeCell.type = KNBOrderTextFieldTypeArea;
            } else {
                typeCell.type = KNBOrderTextFieldTypeShopName;
            }

        } else {
            if (self.VCType == KNBOrderVCTypeOrderFinishing) {
                cell = [KNBOrderDownTableViewCell cellWithTableView:tableView];
                KNBOrderDownTableViewCell *typeCell = (KNBOrderDownTableViewCell *)cell;
                typeCell.type = KNBOrderDownTypeHouse;
            } else {
                cell = [KNBRecruitmentPortraitTableViewCell cellWithTableView:tableView];
            }
        }
        
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell = [KNBOrderTextfieldTableViewCell cellWithTableView:tableView];
            KNBOrderTextfieldTableViewCell *typeCell = (KNBOrderTextfieldTableViewCell *)cell;
            if (self.VCType == KNBOrderVCTypeOrderFinishing) {
                typeCell.type = KNBOrderTextFieldTypeCommunity;
            } else {
                typeCell.type = KNBOrderTextFieldTypeLocation;
            }
        } else {
            if (self.VCType == KNBOrderVCTypeOrderFinishing) {
                cell = [KNBOrderAddressTableViewCell cellWithTableView:tableView];
            } else {
                if (indexPath.row == 1) {
                    cell = [KNBOrderTextfieldTableViewCell cellWithTableView:tableView];
                    KNBOrderTextfieldTableViewCell *typeCell = (KNBOrderTextfieldTableViewCell *)cell;
                    typeCell.type = KNBOrderTextFieldTypeShopPhone;
                } else {
                    cell = [KNBRecruitmentDomainTableViewCell cellWithTableView:tableView];
                    KNBRecruitmentDomainTableViewCell *typeCell = (KNBRecruitmentDomainTableViewCell *)cell;
                }

            }
        }
        
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            cell = [KNBOrderDownTableViewCell cellWithTableView:tableView];
            KNBOrderDownTableViewCell *typeCell = (KNBOrderDownTableViewCell *)cell;
            typeCell.type = self.VCType == KNBOrderVCTypeOrderFinishing ? KNBOrderDownTypeStyle : KNBOrderDownTypeShowPrice;
        } else {
            cell = [KNBOrderDownTableViewCell cellWithTableView:tableView];
            KNBOrderDownTableViewCell *typeCell = (KNBOrderDownTableViewCell *)cell;
            typeCell.type = KNBOrderDownTypeLevel;
        }
        
    } else {
        if (self.VCType == KNBOrderVCTypeOrderFinishing) {
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
            if (indexPath.section == 4) {
                cell = [KNBRecruitmentDomainTableViewCell cellWithTableView:tableView];
                KNBRecruitmentDomainTableViewCell *typeCell = (KNBRecruitmentDomainTableViewCell *)cell;
                typeCell.type = KNBRecruitmentDomainTypeService;
            } else if (indexPath.section == 5) {
                cell = [KNBRecruitmentDomainTableViewCell cellWithTableView:tableView];
                KNBRecruitmentDomainTableViewCell *typeCell = (KNBRecruitmentDomainTableViewCell *)cell;
                typeCell.type = KNBRecruitmentDomainTypeService;
            } else {
                cell = [KNBRecruitmentEnterTableViewCell cellWithTableView:tableView];
                KNBRecruitmentEnterTableViewCell *typeCell = (KNBRecruitmentEnterTableViewCell *)cell;
                typeCell.selectButtonBlock = ^(UIButton * _Nonnull button) {
                    
                };
            }
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
        if (self.VCType == KNBOrderVCTypeOrderFinishing) {
            [self serverTypeRequest];
        } else {
            [self recruitmentTypeRequest];
        }
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        if (self.VCType == KNBOrderVCTypeOrderFinishing) {
            [BRStringPickerView showStringPickerWithTitle:@"选择户型" dataSource:@[@"1",@"2",@"3"] defaultSelValue:nil resultBlock:^(id selectValue) {
                
            }];
        } else {
            [self changePortrait];
        }
    } else if (indexPath.section == 2) {
        if (self.VCType == KNBOrderVCTypeOrderFinishing) {
            if (indexPath.row == 1) {
                [BRAddressPickerView showAddressPickerWithDefaultSelected:nil resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
                    
                }];
            }
        } else {
            if (indexPath.row == 2) {
                if (self.recruitmentModel.typeModel) {
                    [self bestDomainRequest];
                } else {
                    [LCProgressHUD showMessage:@"请先选择入驻类型"];
                }
            }
        }

    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            if (self.VCType == KNBOrderVCTypeOrderFinishing) {
                [self finishingStyleRequest];
            } else {
                if (self.recruitmentModel.typeModel) {
                    [self showPriceRequest];
                } else {
                    [LCProgressHUD showMessage:@"请先选择入驻类型"];
                }
            }
        } else {
            [BRStringPickerView showStringPickerWithTitle:@"选择档次" dataSource:@[@"1",@"2",@"3"] defaultSelValue:nil resultBlock:^(id selectValue) {
                
            }];
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

#pragma mark - Private Method
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
                    weakSelf.recruitmentModel.typeModel = firstModel;
                    weakSelf.recruitmentModel.typeModel.selectSubModel = lastModel;
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
    KNBRecruitmentDomainApi *api = [[KNBRecruitmentDomainApi alloc] initWithCatId:[self.recruitmentModel.typeModel.typeId integerValue]];
    api.hudString = @"";
    KNB_WS(weakSelf);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            NSDictionary *dic = request.responseObject[@"list"];
            NSMutableArray *modelArray = [KNBRecruitmentTypeModel changeResponseJSONObject:dic];
            NSMutableArray *dataArray = [NSMutableArray array];
            for (int i = 0; i < modelArray.count; i++) {
                KNBRecruitmentTypeModel *model = modelArray[i];
                [dataArray addObject:model.tagName];
            }
            [BRStringPickerView showStringPickerWithTitle:@"选择擅长领域" dataSource:dataArray defaultSelValue:nil resultBlock:^(id selectValue) {
            }];
        } else {
            [weakSelf requestSuccess:NO requestEnd:NO];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [weakSelf requestSuccess:NO requestEnd:NO];
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
                [cell.describeButton setTitle:selectValue forState:UIControlStateNormal];
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
                [cell.describeButton setTitle:selectValue forState:UIControlStateNormal];
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
            [BRStringPickerView showStringPickerWithTitle:@"选择风格" dataSource:titleArray defaultSelValue:nil resultBlock:^(id selectValue) {
                KNBOrderDownTableViewCell *cell = [weakSelf.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                [cell.describeButton setTitle:selectValue forState:UIControlStateNormal];
            }];
            [weakSelf requestSuccess:YES requestEnd:YES];
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
