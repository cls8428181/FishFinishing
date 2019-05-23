//
//  KNBHomeUploadCaseFooterView.m
//  FishFinishing
//
//  Created by apple on 2019/5/7.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeUploadCaseFooterView.h"
#import "KNBHomeCompanyCaseAddCollectionViewCell.h"
#import "KNBHomeUploadCaseCollectionViewCell.h"
#import <Photos/Photos.h>
#import "KNBAlertRemind.h"
#import "UITextView+ZWPlaceHolder.h"

@interface KNBHomeUploadCaseFooterView ()<UICollectionViewDelegate, UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIImageView *textBgView;
@end

@implementation KNBHomeUploadCaseFooterView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.topLineView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.textBgView];
        [self addSubview:self.describeText];
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    KNB_WS(weakSelf);
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(10);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topLineView.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(12);
    }];
    [self.textBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).mas_offset(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(50);
    }];
    [self.describeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).mas_offset(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(40);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(weakSelf.describeText.mas_bottom).mas_offset(15);
        make.bottom.mas_equalTo(-12);
    }];
}

#pragma mark - collectionview delegate & dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count + 1;
}
//每一个cell是什么
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.dataArray.count) {
        KNBHomeCompanyCaseAddCollectionViewCell *cell = [KNBHomeCompanyCaseAddCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
        cell.iconImageView.image = KNBImages(@"knb_upload_tianjia");
        return cell;
    } else {
        UIImage *image = self.dataArray[indexPath.row];
        KNB_WS(weakSelf);
        KNBHomeUploadCaseCollectionViewCell *cell = [KNBHomeUploadCaseCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
        cell.iconImageView.image = image;
        cell.delButtonBlock = ^{
            [weakSelf deleteCaseRequest:indexPath.row];
        };
        return cell;
    }
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(170, 115);
}

//cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.dataArray.count) {
        if ([[KNBUserInfo shareInstance].isExperience isEqualToString:@"1"] && self.imgsCount > 5) {
            [KNBAlertRemind alterWithTitle:@"提示" message:@"体验版最多只能上传 5 张图片,请升级为正式版" buttonTitles:@[@"知道了"] handler:^(NSInteger index, NSString *title) {
                
            }];
        } else {
            [self changePortrait];
        }
    }
}

- (UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {if ([next isKindOfClass:[UIViewController class]]) {
        return (UIViewController *)next;
    }
        next = [next nextResponder];
    } while (next !=nil);
    return nil;
}

- (void)deleteCaseRequest:(NSInteger)index {
    [self.dataArray removeObjectAtIndex:index];
    [self.collectionView reloadData];
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
    [[self getCurrentViewController] presentViewController:alert animated:YES completion:nil];
}

- (void)pushPhotosController {
    UIImagePickerController *PickerImage = [[UIImagePickerController alloc] init];
    PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    PickerImage.allowsEditing = YES;
    PickerImage.delegate = self;
    PickerImage.navigationBar.tintColor = [UIColor colorWithHex:0x333333];
    [[self getCurrentViewController] presentViewController:PickerImage animated:YES completion:nil];
}

- (void)pushCameraController {
    UIImagePickerController *PickerImage = [[UIImagePickerController alloc] init];
    //获取方式:通过相机
    PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
    PickerImage.allowsEditing = YES;
    PickerImage.delegate = self;
    [[self getCurrentViewController] presentViewController:PickerImage animated:YES completion:nil];
}

#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    //定义一个newPhoto，用来存放我们选择的图片。
    KNB_WS(weakSelf);
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [self.dataArray addObject:newPhoto];
    !self.addCaseBlock ?: self.addCaseBlock(self.dataArray);
    [[self getCurrentViewController] dismissViewControllerAnimated:YES completion:^{
        [weakSelf.collectionView reloadData];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - private method
+ (CGFloat)cellHeight:(NSInteger)count {
    return 140 *(count /2 + 1);
}

- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
    }
    return _topLineView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"案例描述:";
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [UIColor colorWithHex:0x333333];
    }
    return _titleLabel;
}

- (UIImageView *)textBgView {
    if (!_textBgView) {
        _textBgView = [[UIImageView alloc] init];
        _textBgView.image = KNBImages(@"knb_me_kuang");
    }
    return _textBgView;
}

- (CCTextView *)describeText {
    if (!_describeText) {
        _describeText = [[CCTextView alloc] init];
        _describeText.zw_placeHolder = @"50字以内";
        _describeText.maxLength = 50;
        _describeText.placeHolderLocation = ZWPlaceHolderLocationCenter;
        _describeText.backgroundColor = [UIColor clearColor];
    }
    return _describeText;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.headerReferenceSize = CGSizeMake(0, 0); //头视图的大小
        layout.sectionInset = UIEdgeInsetsMake(0, 12, 0, 2);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"KNBHomeUploadCaseCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"KNBHomeUploadCaseCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"KNBHomeCompanyCaseAddCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"KNBHomeCompanyCaseAddCollectionViewCell"];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
