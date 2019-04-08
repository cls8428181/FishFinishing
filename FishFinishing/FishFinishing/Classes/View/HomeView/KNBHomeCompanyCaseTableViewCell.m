//
//  KNBHomeCompanyCaseTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/3.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeCompanyCaseTableViewCell.h"
#import "KNBHomeDesignSketchSubTableViewCell.h"

@interface KNBHomeCompanyCaseTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
//滑动区域
@property (nonatomic, strong) UICollectionView *collectionView;

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
+ (CGFloat)cellHeight {
    return 385;
}

#pragma mark - collectionview delegate & dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}
//每一个cell是什么
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KNBHomeDesignSketchSubTableViewCell *cell = [KNBHomeDesignSketchSubTableViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    return cell;
}
//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(170, 160);
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    //    UICollectionReusableView *reusableView = nil;
//
//    //    if (kind == UICollectionElementKindSectionHeader) {
//    KNB_WS(weakSelf);
//    self.sectionView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"KNBDesignSketchCollectionSectionView" forIndexPath:indexPath];
//    self.sectionView.optionCompleteBlock = ^(KNBDesignSketchCollectionSectionView * _Nonnull optionView, KNBOptionViewButtonType type) {
//        switch (type) {
//            case KNBOptionViewButtonType_Style: {
//                if (weakSelf.sortView.height == 0.0) {
//                    [weakSelf.sortView showSortViewWithSortTag:0];
//                }
//                break;
//            }
//            case KNBOptionViewButtonType_Type: {
//                break;
//            }
//            case KNBOptionViewButtonType_Area: {
//                break;
//            }
//            default:
//                break;
//        }
//    };
//    [self.view insertSubview:self.sortView belowSubview:self.sectionView];
//    //    } else if (kind == UICollectionElementKindSectionFooter) {
//    //        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"KNBHomeDoctorCellSectionHeaderView" forIndexPath:indexPath];
//    //    }
//    return self.sectionView;
//}

//cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - lazy load
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.headerReferenceSize = CGSizeMake(KNB_SCREEN_WIDTH, 50); //头视图的大小
        //        layout.footerReferenceSize = CGSizeMake(12.5, 140);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //        [_collectionView registerClass:[KNBHomeDesignSketchSubTableViewCell class] forCellWithReuseIdentifier:@"KNBHomeDesignSketchSubTableViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"KNBHomeDesignSketchSubTableViewCell" bundle:nil] forCellWithReuseIdentifier:@"KNBHomeDesignSketchSubTableViewCell"];
//        [_collectionView registerNib:[UINib nibWithNibName:@"KNBDesignSketchCollectionSectionView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"KNBDesignSketchCollectionSectionView"];
        //        [_collectionView registerClass:[KNBDesignSketchCollectionSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"KNBDesignSketchCollectionSectionView"];
        //                [_collectionView registerClass:[KNBCollectionSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"KNBHomeDoctorCellSectionFooterView"];
    }
    return _collectionView;
}

@end
