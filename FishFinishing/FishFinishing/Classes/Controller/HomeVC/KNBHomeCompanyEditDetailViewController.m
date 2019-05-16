//
//  KNBHomeCompanyEditDetailViewController.m
//  FishFinishing
//
//  Created by apple on 2019/4/19.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBHomeCompanyEditDetailViewController.h"
#import "KNBOrderDownTableViewCell.h"
#import "KNBOrderTextfieldTableViewCell.h"
#import "KNBOrderAddressTableViewCell.h"
#import "KNBAddressPickerView.h"
#import "BRStringPickerView.h"
#import "BRLinkagePickerView.h"
#import "KNBRecruitmentTypeApi.h"
#import "KNBRecruitmentTypeModel.h"
#import "KNBOrderServerTypeApi.h"
#import "KNBRecruitmentDomainApi.h"
#import "KNBRecruitmentCostApi.h"
#import "KNBRecruitmentModel.h"
#import "KNBHomeServiceModel.h"
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
#import "KNBRecruitmentModifyDetailApi.h"
#import "KNBRecruitmentModifyFacilitatorApi.h"
#import "UITextView+ZWPlaceHolder.h"
#import "KNBUploadFileApi.h"
#import "MPFindNearAddressVC.h"

@interface KNBHomeCompanyEditDetailViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
//入驻商家模型
@property (nonatomic, strong) KNBRecruitmentModel *recruitmentModel;
//记录最后一个输入框
@property (nonatomic, strong) UITextField *lastTextField;
@end

@implementation KNBHomeCompanyEditDetailViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configuration];
    
    [self addUI];
    
    [self fetchData];
}

#pragma mark - Utils
- (void)configuration {
    self.naviView.title = @"入驻编辑";
    [self.naviView addLeftBarItemImageName:@"knb_back_black" target:self sel:@selector(backAction)];
    [self.naviView addRightBarItemTitle:@"保存" target:self sel:@selector(saveAction)];
    [self.naviView.rightNaviButton setTitleColor:[UIColor colorWithHex:0x009fe8] forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor knBgColor];
    
    self.knGroupTableView.backgroundColor = [UIColor whiteColor];
}

- (void)addUI {
    [self.view addSubview:self.knGroupTableView];
}

- (void)fetchData {
//    KNBRecruitmentModifyDetailApi *api = [[KNBRecruitmentModifyDetailApi alloc] init];
//    api.hudString = @"";
//    KNB_WS(weakSelf);
//    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
//        if (api.requestSuccess) {
//            NSDictionary *dic = request.responseObject[@"list"];
//            KNBHomeServiceModel *model = [KNBHomeServiceModel changeResponseJSONObject:dic];
////            weakSelf.recruitmentModel = model;
//            [weakSelf requestSuccess:YES requestEnd:YES];
//        } else {
//            [weakSelf requestSuccess:NO requestEnd:NO];
//        }
//    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
//        [weakSelf requestSuccess:NO requestEnd:NO];
//    }];
}

#pragma mark - tableview delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 2;
    } else if (section == 2) {
        return 3;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [KNBOrderDownTableViewCell cellWithTableView:tableView];
        KNBOrderDownTableViewCell *typeCell = (KNBOrderDownTableViewCell *)cell;
        typeCell.type = KNBOrderDownTypeRecruitment;
        [typeCell setButtonTitle:self.model.parent_cat_name];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell = [KNBOrderTextfieldTableViewCell cellWithTableView:tableView];
            KNBOrderTextfieldTableViewCell *typeCell = (KNBOrderTextfieldTableViewCell *)cell;
            typeCell.type = KNBOrderTextFieldTypeShopName;
            typeCell.describeTextField.delegate = self;
            typeCell.describeTextField.text = self.model.name;
        } else {
            cell = [KNBRecruitmentPortraitTableViewCell cellWithTableView:tableView];
            KNBRecruitmentPortraitTableViewCell *typeCell = (KNBRecruitmentPortraitTableViewCell *)cell;
            [typeCell.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.logo] placeholderImage:KNBImages(@"knb_default_user")];
        }
        
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell = [KNBOrderTextfieldTableViewCell cellWithTableView:tableView];
            KNBOrderTextfieldTableViewCell *typeCell = (KNBOrderTextfieldTableViewCell *)cell;
            typeCell.type = KNBOrderTextFieldTypeLocation;
            typeCell.describeTextField.userInteractionEnabled = NO;
            typeCell.describeTextField.text = self.model.address;
            
        } else if (indexPath.row == 1) {
            cell = [KNBOrderTextfieldTableViewCell cellWithTableView:tableView];
            KNBOrderTextfieldTableViewCell *typeCell = (KNBOrderTextfieldTableViewCell *)cell;
            typeCell.type = KNBOrderTextFieldTypeShopPhone;
            typeCell.describeTextField.delegate = self;
            typeCell.describeTextField.text = self.model.telephone;
        } else {
            cell = [KNBRecruitmentDomainTableViewCell cellWithTableView:tableView];
            KNBRecruitmentDomainTableViewCell *typeCell = (KNBRecruitmentDomainTableViewCell *)cell;
            typeCell.type = KNBRecruitmentDomainTypeDefault;
            NSArray *tagsArray = [self.model.tag componentsSeparatedByString:@","];
            [typeCell setTagsViewDataSource:tagsArray];
        }
    } else if (indexPath.section == 3) {
        cell = [KNBRecruitmentDomainTableViewCell cellWithTableView:tableView];
        KNBRecruitmentDomainTableViewCell *typeCell = (KNBRecruitmentDomainTableViewCell *)cell;
        typeCell.type = KNBRecruitmentDomainTypeService;
        NSMutableArray *tagsArray = [NSMutableArray array];
        for (KNBHomeServiceModel *model in self.model.serviceList) {
            [tagsArray addObject:model.service_name];
        }
        [typeCell setTagsViewDataSource:tagsArray];
    } else {
        cell = [KNBRecruitmentIntroTableViewCell cellWithTableView:tableView];
        KNBRecruitmentIntroTableViewCell *typeCell = (KNBRecruitmentIntroTableViewCell *)cell;
        typeCell.contentTextView.text = self.model.remark;
        typeCell.contentTextView.placeholder = @"请输入备注";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 4) {
        return [KNBRecruitmentIntroTableViewCell cellHeight];
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
    if (indexPath.section == 0) {
//        [self recruitmentTypeRequest];
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
        !isNullStr(self.model.parent_cat_name) ? [self bestDomainRequest] : [LCProgressHUD showMessage:@"请先选择入驻类型"];

    } else if (indexPath.section == 3) {
        [self chooseServiceRequest];
        
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
    KNBRecruitmentDomainApi *api = [[KNBRecruitmentDomainApi alloc] initWithCatId:[self.model.parent_cat_id integerValue]];
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
            [weakSelf requestSuccess:NO requestEnd:NO];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [weakSelf requestSuccess:NO requestEnd:NO];
    }];
    
}

//请求选择服务数据
- (void)chooseServiceRequest {
    KNBOrderServerTypeApi *api = [[KNBOrderServerTypeApi alloc] initWithCatId:[self.model.parent_cat_id integerValue]];
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
                KNBRecruitmentDomainTableViewCell *cell = [weakSelf.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
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

- (void)saveAction {

    KNBRecruitmentIntroTableViewCell *introCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
    self.recruitmentModel.remark = introCell.contentTextView.text;
    if (self.recruitmentModel.iconImage) {
        //上传图片
        [LCProgressHUD showLoading:@""];
        KNBUploadFileApi *fileApi = [[KNBUploadFileApi alloc] initWithImage:self.recruitmentModel.iconImage ?: KNBImages(@"knb_default_user")];
        KNB_WS(weakSelf);
        [fileApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
            if (fileApi.requestSuccess) {
                NSString *imgString = request.responseObject[@"imgurl"];
                KNBRecruitmentModifyFacilitatorApi *api = [[KNBRecruitmentModifyFacilitatorApi alloc] init];
                api.logo = imgString;
                if (!isNullStr(weakSelf.recruitmentModel.name)) {
                    api.name = weakSelf.recruitmentModel.name;
                }
                if (!isNullStr(weakSelf.recruitmentModel.address)) {
                    api.address = weakSelf.recruitmentModel.address;
                }
                if (!isNullStr(weakSelf.recruitmentModel.telephone)) {
                    api.telephone = weakSelf.recruitmentModel.telephone;
                }
                if (!isNullStr(weakSelf.recruitmentModel.remark)) {
                    api.remark = weakSelf.recruitmentModel.remark;
                }
                if (!isNullArray(weakSelf.recruitmentModel.domainList)) {
                    api.tag_id = weakSelf.recruitmentModel.domainId;
                }
                if (!isNullArray(weakSelf.recruitmentModel.serviceList)) {
                    api.service_id = weakSelf.recruitmentModel.serviceId;
                }
                if (!isNullStr(weakSelf.recruitmentModel.address)) {
                    api.area_name = weakSelf.recruitmentModel.areaName;
                    api.lat = [NSString stringWithFormat:@"%f",weakSelf.recruitmentModel.latitude];
                    api.lng = [NSString stringWithFormat:@"%f",weakSelf.recruitmentModel.longitude];
                    api.address = weakSelf.recruitmentModel.address;
                }
                [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
                    if (api.requestSuccess) {
                        [LCProgressHUD hide];
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                        [KNBAlertRemind alterWithTitle:@"提示" message:@"您已经提交修改申请,请等待审核" buttonTitles:@[ @"知道了" ] handler:^(NSInteger index, NSString *title){
                            
                        }];
                    } else {
                        [LCProgressHUD showMessage:api.errMessage];
                    }
                } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
                    [LCProgressHUD showMessage:api.errMessage];
                }];
            } else {
                [LCProgressHUD showMessage:fileApi.errMessage];
            }
        } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
            [LCProgressHUD showMessage:fileApi.errMessage];
        }];
    } else {
        KNBRecruitmentModifyFacilitatorApi *api = [[KNBRecruitmentModifyFacilitatorApi alloc] init];
        if (!isNullStr(self.recruitmentModel.name)) {
            api.name = self.recruitmentModel.name;
        }
        if (!isNullStr(self.recruitmentModel.address)) {
            api.address = self.recruitmentModel.address;
        }
        if (!isNullStr(self.recruitmentModel.telephone)) {
            api.telephone = self.recruitmentModel.telephone;
        }
        if (!isNullStr(self.recruitmentModel.remark)) {
            api.remark = self.recruitmentModel.remark;
        }
        if (!isNullArray(self.recruitmentModel.domainList)) {
            api.tag_id = self.recruitmentModel.domainId;
        }
        if (!isNullArray(self.recruitmentModel.serviceList)) {
            api.service_id = self.recruitmentModel.serviceId;
        }
        api.hudString = @"";
        KNB_WS(weakSelf);
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
            if (api.requestSuccess) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [KNBAlertRemind alterWithTitle:@"提示" message:@"您已经提交修改申请,请等待审核" buttonTitles:@[ @"知道了" ] handler:^(NSInteger index, NSString *title){
                    
                }];
            } else {
                [LCProgressHUD showMessage:api.errMessage];
            }
        } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
            [LCProgressHUD showMessage:api.errMessage];
        }];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.lastTextField resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    KNBOrderTextfieldTableViewCell *nameCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    KNBOrderTextfieldTableViewCell *addressCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    KNBOrderTextfieldTableViewCell *mobileCell = [self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1   inSection:2]];
    
    if ([textField isEqual:nameCell.describeTextField]) {
        self.recruitmentModel.name = textField.text;
    }
    if ([textField isEqual:addressCell.describeTextField]) {
        self.recruitmentModel.address = textField.text;
    }
    if ([textField isEqual:mobileCell.describeTextField]) {
        self.recruitmentModel.telephone = textField.text;
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.lastTextField = textField;
}

#pragma mark - Getters And Setters
/* getter和setter全部都放在最后*/
- (KNBRecruitmentModel *)recruitmentModel {
    if (!_recruitmentModel) {
        _recruitmentModel = [[KNBRecruitmentModel alloc] init];
    }
    return _recruitmentModel;
}

- (void)setModel:(KNBHomeServiceModel *)model {
    _model = model;
    [self.knGroupTableView reloadData];
}

@end
