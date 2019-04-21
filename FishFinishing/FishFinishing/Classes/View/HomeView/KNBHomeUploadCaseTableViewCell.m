//
//  KNBHomeUploadCaseTableViewCell.m
//  FishFinishing
//
//  Created by apple on 2019/4/19.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBHomeUploadCaseTableViewCell.h"
#import "KNBHomeCompanyCaseAddCollectionViewCell.h"
#import "KNBHomeUploadCaseCollectionViewCell.h"
#import <Photos/Photos.h>
#import "KNBAlertRemind.h"

@interface KNBHomeUploadCaseTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *placeholder;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation KNBHomeUploadCaseTableViewCell

#pragma mark - life cycle
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBHomeUploadCaseTableViewCell";
    KNBHomeUploadCaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[KNBHomeUploadCaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithHex:0xfafafa];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.describeText];
        [self.describeText addSubview:self.placeholder];
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    KNB_WS(weakSelf);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(12);
    }];
    [self.describeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).mas_offset(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(50);
    }];
    [self.placeholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.describeText);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.equalTo(weakSelf.describeText.mas_bottom).mas_offset(15);
        make.right.bottom.mas_equalTo(-12);
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
        cell.iconImageView.image = KNBImages(@"knb_me_tianjia_white");
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
        [self changePortrait];
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

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"案例描述:";
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [UIColor colorWithHex:0x333333];
    }
    return _titleLabel;
}

- (UITextView *)describeText {
    if (!_describeText) {
        _describeText = [[UITextView alloc] init];
    }
    return _describeText;
}

- (UILabel *)placeholder {
    if (!_placeholder) {
        _placeholder = [[UILabel alloc] init];
        _placeholder.text = @"50字以内";
        _placeholder.font = [UIFont systemFontOfSize:12];
        _placeholder.textColor = [UIColor colorWithHex:0xb3b3b3];
        _placeholder.contentMode = UIViewContentModeTop;
    }
    return _placeholder;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.headerReferenceSize = CGSizeMake(0, 0); //头视图的大小
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor colorWithHex:0xfafafa];
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
