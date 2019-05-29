//
//  KNBHomeCompanyDetailFooterView.m
//  FishFinishing
//
//  Created by apple on 2019/5/20.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeCompanyDetailFooterView.h"
#import "KNBHomeCompanyCaseSubCollectionViewCell.h"
#import "KNBDesignSketchDetailViewController.h"
#import "KNBDesignSketchModel.h"
#import "KNBRecruitmentDelCaseApi.h"
#import "KNBHomeCompanyCaseAddCollectionViewCell.h"
#import "KNBHomeCompanyUploadCaseViewController.h"
#import "KNBHomeUploadProductViewController.h"
#import "KNBOrderCheckCaseNumApi.h"

@interface KNBHomeCompanyDetailFooterView ()<UICollectionViewDelegate, UICollectionViewDataSource>
//滑动区域
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation KNBHomeCompanyDetailFooterView
- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.topLineView];
        [self addSubview:self.topLabel];
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    KNB_WS(weakSelf);
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakSelf);
        make.height.mas_equalTo(10);
    }];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.top.equalTo(weakSelf.topLineView.mas_bottom).mas_offset(17);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf);
        make.top.equalTo(weakSelf.topLineView.mas_bottom).mas_offset(40);
    }];
}

#pragma mark - collectionview delegate & dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.isEdit ? self.dataArray.count + 1 : self.dataArray.count;
}
//每一个cell是什么
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.dataArray.count && self.isEdit) {
        KNBHomeCompanyCaseAddCollectionViewCell *cell = [KNBHomeCompanyCaseAddCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
        return cell;
    } else {
        KNBHomeServiceModel *model = self.dataArray[indexPath.row];
        KNB_WS(weakSelf);
        KNBHomeCompanyCaseSubCollectionViewCell *cell = [KNBHomeCompanyCaseSubCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
        cell.isProduct = [self.model.share_id isEqualToString:@"0"];
        cell.isEdit = self.isEdit;
        cell.model = model;
        [cell setServiceName:self.model.name ServiceIcon:self.model.logo];
        cell.deleteButtonBlock = ^{
            [weakSelf deleteCaseRequest:indexPath.row];
        };
        return cell;
    }
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(180, 215);
}

//cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    KNB_WS(weakSelf);
    if (indexPath.row == self.dataArray.count && self.isEdit) {
        KNBOrderCheckCaseNumApi *api = [[KNBOrderCheckCaseNumApi alloc] init];
        api.hudString = @"";
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
            if (api.requestSuccess) {
                if ([weakSelf.model.share_id isEqualToString:@"0"]) {
                    KNBHomeUploadProductViewController *productVC = [[KNBHomeUploadProductViewController alloc] init];
                    productVC.imgsCount = weakSelf.dataArray.count;
                    productVC.saveSuccessBlock = ^{
                        !weakSelf.addCaseBlock ?: weakSelf.addCaseBlock();
                    };
                    [[[weakSelf getCurrentViewController] navigationController] pushViewController:productVC animated:YES];
                } else {
                    KNBHomeCompanyUploadCaseViewController *addCaseVC = [[KNBHomeCompanyUploadCaseViewController alloc] init];
                    addCaseVC.imgsCount = self.dataArray.count;
                    addCaseVC.saveSuccessBlock = ^{
                        !weakSelf.addCaseBlock ?: weakSelf.addCaseBlock();
                    };
                    [[[weakSelf getCurrentViewController] navigationController] pushViewController:addCaseVC animated:YES];
                }
            } else {
                [LCProgressHUD showMessage:api.errMessage];
            }
        } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
            [LCProgressHUD showMessage:api.errMessage];
        }];
    } else {
        KNBHomeServiceModel *cellModel = self.dataArray[indexPath.row];
        if (([cellModel.status isEqualToString:@"1"] && self.isEdit) || !self.isEdit) {
            KNBDesignSketchModel *model  = [[KNBDesignSketchModel alloc] init];
            model.caseId = cellModel.serviceId;
            model.name = self.model.name;
            model.img = self.model.logo;
            KNBDesignSketchDetailViewController *detailVC = [[KNBDesignSketchDetailViewController alloc] init];
            detailVC.model = model;
            [[[self getCurrentViewController] navigationController] pushViewController:detailVC animated:YES];
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
    KNBHomeServiceModel *cellModel = self.dataArray[index];
    KNBRecruitmentDelCaseApi *api = [[KNBRecruitmentDelCaseApi alloc] initWithCaseId:[cellModel.serviceId integerValue]];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.dataArray];
            [tempArray removeObjectAtIndex:index];
            self.dataArray = tempArray;
            [self.collectionView reloadData];
        } else {
            [LCProgressHUD showMessage:@"删除案例失败,请重试"];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [LCProgressHUD showMessage:@"删除案例失败,请重试"];
    }];
}

#pragma mark - lazy load
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 10;
        layout.headerReferenceSize = CGSizeMake(0, 0); //头视图的大小
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"KNBHomeCompanyCaseSubCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"KNBHomeCompanyCaseSubCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"KNBHomeCompanyCaseAddCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"KNBHomeCompanyCaseAddCollectionViewCell"];
    }
    return _collectionView;
}

- (void)setModel:(KNBHomeServiceModel *)model {
    _model = model;
    self.dataArray = model.caseList;
    
    if ([model.share_id isEqualToString:@"0"]) {
        self.topLabel.text = @"产品展示";
    } else {
        self.topLabel.text = @"案例作品";
    }
    
    [self.collectionView reloadData];
}

- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.textColor = [UIColor kn333333Color];
        _topLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    }
    return _topLabel;
}

- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [UIColor knf2f2f2Color];
    }
    return _topLineView;
}
@end
