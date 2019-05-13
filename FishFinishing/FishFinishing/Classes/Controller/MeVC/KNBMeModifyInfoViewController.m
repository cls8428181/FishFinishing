//
//  KNBMeModifyInfoViewController.m
//  FishFinishing
//
//  Created by apple on 2019/4/29.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBMeModifyInfoViewController.h"
#import "KNBLoginModifyUserInfoApi.h"
#import "KNBUploadFileApi.h"
#import <Photos/Photos.h>

@interface KNBMeModifyInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIButton *iconButton;
@property (nonatomic, strong) UILabel *iconLabel;
@property (nonatomic, strong) UILabel *nickTitleLabel;
@property (nonatomic, strong) UITextField *nickTextField;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *enterButton;
@end

@implementation KNBMeModifyInfoViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configuration];
    
    [self addUI];
    
    [self settingConstraints];
}

#pragma mark - Setup UI Constraints
/*
 *  在这里添加UIView的约束布局相关代码
 */
- (void)settingConstraints {
    KNB_WS(weakSelf);
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(KNB_NAV_HEIGHT);
        make.height.mas_equalTo(10);
    }];
    [self.iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.topLineView.mas_bottom).mas_offset(50);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    [self.iconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.iconButton.mas_bottom).mas_offset(10);
    }];
    [self.nickTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.equalTo(weakSelf.iconLabel.mas_bottom).mas_offset(30);
        make.width.mas_equalTo(50);
    }];
    [self.nickTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nickTitleLabel.mas_right).mas_offset(10);
        make.right.mas_equalTo(-13);
        make.centerY.mas_equalTo(weakSelf.nickTitleLabel);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.top.equalTo(weakSelf.nickTextField.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(1);
    }];
    [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(40);
        make.top.equalTo(weakSelf.lineView.mas_bottom).mas_offset(50);
        make.centerX.mas_equalTo(weakSelf.view);
    }];
}

#pragma mark - Utils
- (void)configuration {
    self.naviView.title = @"修改个人信息";
    [self.naviView addLeftBarItemImageName:@"knb_back_black" target:self sel:@selector(backAction)];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)addUI {
    [self.view addSubview:self.topLineView];
    [self.view addSubview:self.iconButton];
    [self.view addSubview:self.iconLabel];
    [self.view addSubview:self.nickTitleLabel];
    [self.view addSubview:self.nickTextField];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.enterButton];
}

#pragma mark - Event Response
/*
 *  所有button、gestureRecognizer的响应事件都放在这个区域里面，不要到处乱放。
 */
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)iconButtonAction {
    [self changePortrait];
}

- (void)enterButtonAction {
    //上传图片
    [LCProgressHUD showLoading:@""];
    KNBUploadFileApi *fileApi = [[KNBUploadFileApi alloc] initWithImage:self.iconButton.imageView.image];
    KNB_WS(weakSelf);
    [fileApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (fileApi.requestSuccess) {
            NSString *imgString = request.responseObject[@"imgurl"];
            KNBLoginModifyUserInfoApi *api = [[KNBLoginModifyUserInfoApi alloc] initWithPortraitImg:imgString nickName:weakSelf.nickTextField.text];
            KNB_WS(weakSelf);
            [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
                if (api.requestSuccess) {
                    [LCProgressHUD hide];
                    NSDictionary *dic = request.responseObject[@"list"];
                    [[KNBUserInfo shareInstance] updateUserInfo:dic];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    !weakSelf.modifyComplete ?: weakSelf.modifyComplete();
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

#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self.iconButton setImage:newPhoto forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)changePortrait {
    KNB_WS(weakSelf);
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
- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [UIColor knBgColor];
    }
    return _topLineView;
}

- (UIButton *)iconButton {
    if (!_iconButton) {
        _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iconButton sd_setImageWithURL:[NSURL URLWithString:[KNBUserInfo shareInstance].portrait] forState:UIControlStateNormal placeholderImage:KNBImages(@"knb_default_user")];
        [_iconButton addTarget:self action:@selector(iconButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _iconButton.layer.masksToBounds = YES;
        _iconButton.layer.cornerRadius = 50;
    }
    return _iconButton;
}

- (UILabel *)iconLabel {
    if (!_iconLabel) {
        _iconLabel = [[UILabel alloc] init];
        _iconLabel.text = @"点击头像更换";
        _iconLabel.font = [UIFont systemFontOfSize:14];
    }
    return _iconLabel;
}

- (UILabel *)nickTitleLabel {
    if (!_nickTitleLabel) {
        _nickTitleLabel = [[UILabel alloc] init];
        _nickTitleLabel.text = @"昵称:";
        _nickTitleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nickTitleLabel;
}

- (UITextField *)nickTextField {
    if (!_nickTextField) {
        _nickTextField = [[UITextField alloc] init];
        _nickTextField.placeholder = @"请输入昵称";
        _nickTextField.text = [KNBUserInfo shareInstance].nickName;
        _nickTextField.textAlignment = NSTextAlignmentLeft;
        _nickTextField.font = [UIFont systemFontOfSize:14];
    }
    return _nickTextField;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
    }
    return _lineView;
}

- (UIButton *)enterButton {
    if (!_enterButton) {
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterButton setTitle:@"确定" forState:UIControlStateNormal];
        [_enterButton setBackgroundColor:[UIColor colorWithHex:0x1898e3]];
        _enterButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _enterButton.layer.masksToBounds = YES;
        _enterButton.layer.cornerRadius = 20;
        [_enterButton addTarget:self action:@selector(enterButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterButton;
}

@end
