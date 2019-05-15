//
//  KNBHomeCategoryTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/26.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeCategoryTableViewCell.h"
#import "KNBHomeCategoryCollectionViewCell.h"
#import "KNBRecruitmentTypeModel.h"

@interface KNBHomeCategoryTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
//数据
@property (nonatomic, strong) NSArray *dataArray;
//广告
@property (nonatomic, strong)  UIButton *adButton;
//滑动区域
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation KNBHomeCategoryTableViewCell

#pragma mark - life cycle
+ (instancetype)cellWithTableView:(UITableView *)tableView dataSource:(nonnull NSArray *)dataSource {
    static NSString *ID = @"KNBHomeCategoryTableViewCell";
    KNBHomeCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[KNBHomeCategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dataArray = dataSource;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.collectionView];
//        [self.contentView addSubview:self.adButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    KNB_WS(weakSelf);
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf.contentView);
        make.height.mas_equalTo(100);
    }];
    
//    [self.adButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(12);
//        make.right.bottom.mas_equalTo(-12);
//        make.top.equalTo(weakSelf.collectionView.mas_bottom).mas_offset(0);
//    }];
}

#pragma mark - System Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
//每一个cell是什么
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KNBHomeCategoryCollectionViewCell *cell = [KNBHomeCategoryCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    KNBRecruitmentTypeModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    return cell;
}
//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(60, 75);
}

//cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    !self.selectItemAtIndexBlock ?: self.selectItemAtIndexBlock(indexPath.row);
}

#pragma mark - private method

+ (CGFloat)cellHeight {
    return 120;
}

- (void)reloadCollectionView {
    [self.collectionView reloadData];
}

-(void)adButtonAction {
    !self.adButtonBlock ?: self.adButtonBlock();
}

#pragma mark - lazy load
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 12);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[KNBHomeCategoryCollectionViewCell class]
            forCellWithReuseIdentifier:@"KNBHomeCategoryCollectionViewCell"];
    }
    return _collectionView;
}

//- (UIButton *)adButton {
//    if (!_adButton) {
//        _adButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_adButton setImage:KNBImages(@"knb_home_ad") forState:UIControlStateNormal];
//        [_adButton addTarget:self action:@selector(adButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _adButton;
//}

- (void)setDataArray:(NSArray *)dataArray {
    if (!isNullArray(dataArray)) {
        NSMutableArray *tempArray = [NSMutableArray array];
        KNBRecruitmentTypeModel *model = [[KNBRecruitmentTypeModel alloc] init];
        model.catName = @"量房报价";
        model.img = @"";
        [tempArray addObject:model];
        [tempArray addObjectsFromArray:dataArray];
        _dataArray = tempArray;
    }
}

@end
