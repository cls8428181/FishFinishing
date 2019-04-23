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
#import "KNBLoginModifyUserInfoApi.h"
#import "KNBUploadFileApi.h"
#import <Photos/Photos.h>
#import "KNBAlertRemind.h"
#import "KNBLoginViewController.h"

@interface KNBMeSetViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

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
            [[KNBUserInfo shareInstance] logout];
            [self.navigationController popToRootViewControllerAnimated:YES];
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
    if (indexPath.section == 1) {
        [self changePortrait];
    }
    if (indexPath.section == 2) {
        KNBLoginViewController *modifyPasswordVC = [[KNBLoginViewController alloc] init];
        modifyPasswordVC.vcType = KNBLoginTypeFindPassword;
        [self presentViewController:modifyPasswordVC animated:YES completion:nil];
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

#pragma mark - Event Response
/*
 *  所有button、gestureRecognizer的响应事件都放在这个区域里面，不要到处乱放。
 */
- (void)backAction {
    KNBOrderTextfieldTableViewCell *nameCell = (KNBOrderTextfieldTableViewCell *)[self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    KNBRecruitmentPortraitTableViewCell *iconCell = (KNBRecruitmentPortraitTableViewCell *)[self.knGroupTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    //上传图片
    KNBUploadFileApi *fileApi = [[KNBUploadFileApi alloc] initWithImage:iconCell.iconImageView.image token:[KNBUserInfo shareInstance].token];
    [fileApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (fileApi.requestSuccess) {
            NSString *imgString = request.responseObject[@"imgurl"];
            KNBLoginModifyUserInfoApi *api = [[KNBLoginModifyUserInfoApi alloc] initWithToken:[KNBUserInfo shareInstance].token portraitImg:imgString nickName:nameCell.describeTextField.text];
            KNB_WS(weakSelf);
            [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
                if (api.requestSuccess) {
                    NSDictionary *dic = request.responseObject[@"list"];
                    [[KNBUserInfo shareInstance] updateUserInfo:dic];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
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

#pragma mark - Getters And Setters
/* getter和setter全部都放在最后*/

@end
