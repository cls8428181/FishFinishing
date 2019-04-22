//
//  KNBHomeDesignSketchTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/26.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeDesignSketchTableViewCell.h"
//utils
#import <HMSegmentedControl.h>
//views
#import "KNBHomeDesignSketchSubTableViewCell.h"
#import "KNBHomeRecommendCaseModel.h"
#import "KNBHomeCompanyDetailViewController.h"
#import "KNBHomeServiceModel.h"

@interface KNBHomeDesignSketchTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>
//头部滑动视图
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;


@end

@implementation KNBHomeDesignSketchTableViewCell

#pragma mark - life cycle
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBHomeDesignSketchTableViewCell";
    KNBHomeDesignSketchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[KNBHomeDesignSketchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.segmentedControl];
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    KNB_WS(weakSelf);
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(45);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(weakSelf);
        make.top.equalTo(weakSelf.segmentedControl.mas_bottom).mas_offset(1);
        make.width.mas_equalTo(KNB_SCREEN_WIDTH);
    }];
}

#pragma mark - private method

+ (CGFloat)cellHeight {
    return 240;
}

#pragma mark - System Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.modelArray.count;
}
//每一个cell是什么
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KNBHomeRecommendCaseModel *model = self.modelArray[indexPath.row];
    KNBHomeDesignSketchSubTableViewCell *cell = [KNBHomeDesignSketchSubTableViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
    cell.model = model;
    return cell;
}
//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(130, 155);
}

//cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    KNBHomeRecommendCaseModel *model = self.modelArray[indexPath.row];
    KNBHomeServiceModel *serviceModel = [[KNBHomeServiceModel alloc] init];
    serviceModel.serviceId = model.caseId;
    KNBHomeCompanyDetailViewController *detailVC = [[KNBHomeCompanyDetailViewController alloc] init];
    detailVC.model = serviceModel;
    [[[self getCurrentViewController] navigationController] pushViewController:detailVC animated:YES];
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

#pragma mark - lazy load
- (HMSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[ @"风格", @"户型", @"空间"]];
        _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:15.0]};
        _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHex:0x009fe8], NSFontAttributeName : [UIFont systemFontOfSize:15.0]};
        _segmentedControl.selectionIndicatorColor = [UIColor colorWithHex:0x009fe8];
        _segmentedControl.selectionIndicatorHeight = 2.0;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 15);
        KNB_WS(weakSelf);
        [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
            !weakSelf.selectIndexBlock ?: weakSelf.selectIndexBlock(index);
        }];
    }
    return _segmentedControl;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[KNBHomeDesignSketchSubTableViewCell class] forCellWithReuseIdentifier:@"KNBHomeDesignSketchSubTableViewCell"];
    }
    return _collectionView;
}

- (void)setModelArray:(NSArray *)modelArray {
    _modelArray = modelArray;
    [self.collectionView reloadData];
}

@end
