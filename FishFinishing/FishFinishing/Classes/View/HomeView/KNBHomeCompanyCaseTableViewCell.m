//
//  KNBHomeCompanyCaseTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/3.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeCompanyCaseTableViewCell.h"
#import "KNBHomeCompanyCaseSubCollectionViewCell.h"
#import "KNBDesignSketchDetailViewController.h"
#import "KNBDesignSketchModel.h"
#import "KNBRecruitmentDelCaseApi.h"
#import "KNBHomeCompanyCaseAddCollectionViewCell.h"
#import "KNBHomeCompanyUploadCaseViewController.h"
#import "KNBHomeUploadProductViewController.h"
#import "KNBOrderCheckCaseNumApi.h"

@interface KNBHomeCompanyCaseTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
//滑动区域
@property (nonatomic, strong) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation KNBHomeCompanyCaseTableViewCell

#pragma mark - life cycle
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBHomeCompanyCaseTableViewCell";
    KNBHomeCompanyCaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    KNB_WS(weakSelf);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf);
        make.top.mas_equalTo(40);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView addSubview:self.collectionView];
}

#pragma mark - private method
+ (CGFloat)cellHeight:(NSInteger)count isEdit:(BOOL)isEdit {
    if (count == 0) {
        return 200;
    }
    if (count %2 == 0) {
        if (isEdit) {
            return 220 *(count /2 + 1);
        } else {
            return 220 *count /2;
        }
    } else {
        return 220 *(count /2 + 1);
    }

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
        cell.model = model;
        cell.isEdit = self.isEdit;
        cell.deleteButtonBlock = ^{
            [weakSelf deleteCaseRequest:indexPath.row];
        };
        return cell;
    }
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(180, 180);
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
        KNBDesignSketchModel *model  = [[KNBDesignSketchModel alloc] init];
        model.caseId = cellModel.serviceId;
        model.name = self.model.name;
        model.img = self.model.logo;
        KNBDesignSketchDetailViewController *detailVC = [[KNBDesignSketchDetailViewController alloc] init];
        detailVC.model = model;
        [[[self getCurrentViewController] navigationController] pushViewController:detailVC animated:YES];
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
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.headerReferenceSize = CGSizeMake(0, 0); //头视图的大小
        //        layout.footerReferenceSize = CGSizeMake(12.5, 140);
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
        self.topLabel.text = @"产品";
    } else {
        self.topLabel.text = @"案例";
    }
    
    [self.collectionView reloadData];
}
@end
