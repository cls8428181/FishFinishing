//
//  DesignSketchViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/26.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "DesignSketchViewController.h"
//views
#import "KNBDesignSketchCollectionViewCell.h"
#import "KNBDesignSketchCollectionSectionView.h"
#import "KNBSortView.h"

//controllers
#import "KNBDesignSketchDetailViewController.h"

@interface DesignSketchViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
//滑动区域
@property (nonatomic, strong) UICollectionView *collectionView;
//筛选弹框
@property (nonatomic, strong) KNBSortView *sortView;
//顶部下拉筛选
@property (nonatomic, strong) KNBDesignSketchCollectionSectionView *sectionView;

@end

@implementation DesignSketchViewController

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
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.naviView.mas_bottom).mas_offset(0);
    }];
}

#pragma mark - Utils
- (void)configuration {
    self.naviView.title = @"装修效果图";
    self.naviView.titleNaviLabel.textColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor knBgColor];
    
}

- (void)addUI {
    [self.view addSubview:self.collectionView];
}

- (void)fetchData {
    
}

#pragma mark - collectionview delegate & dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}
//每一个cell是什么
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KNBDesignSketchCollectionViewCell *cell = [KNBDesignSketchCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    return cell;
}
//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(170, 192);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    UICollectionReusableView *reusableView = nil;

//    if (kind == UICollectionElementKindSectionHeader) {
    KNB_WS(weakSelf);
    self.sectionView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"KNBDesignSketchCollectionSectionView" forIndexPath:indexPath];
    self.sectionView.optionCompleteBlock = ^(KNBDesignSketchCollectionSectionView * _Nonnull optionView, KNBOptionViewButtonType type) {
        switch (type) {
            case KNBOptionViewButtonType_Style: {
                if (weakSelf.sortView.height == 0.0) {
                    [weakSelf.sortView showSortViewWithSortTag:0];
                }
                break;
            }
            case KNBOptionViewButtonType_Type: {
                break;
            }
            case KNBOptionViewButtonType_Area: {
                break;
            }
            default:
                break;
        }
    };
    [self.view insertSubview:self.sortView belowSubview:self.sectionView];
//    } else if (kind == UICollectionElementKindSectionFooter) {
//        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"KNBHomeDoctorCellSectionHeaderView" forIndexPath:indexPath];
//    }
    return self.sectionView;
}

//cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    KNBDesignSketchDetailViewController *detailVC = [[KNBDesignSketchDetailViewController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - Event Response
/*
 *  所有button、gestureRecognizer的响应事件都放在这个区域里面，不要到处乱放。
 */

#pragma mark - Getters And Setters
/* getter和setter全部都放在最后*/
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.headerReferenceSize = CGSizeMake(KNB_SCREEN_WIDTH, 50); //头视图的大小
        layout.sectionInset = UIEdgeInsetsMake(10, 12, 10, 12);
//        layout.footerReferenceSize = CGSizeMake(12.5, 140);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
//        [_collectionView registerClass:[KNBHomeDesignSketchSubTableViewCell class] forCellWithReuseIdentifier:@"KNBHomeDesignSketchSubTableViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"KNBDesignSketchCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"KNBDesignSketchCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"KNBDesignSketchCollectionSectionView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"KNBDesignSketchCollectionSectionView"];
//        [_collectionView registerClass:[KNBDesignSketchCollectionSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"KNBDesignSketchCollectionSectionView"];
//                [_collectionView registerClass:[KNBCollectionSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"KNBHomeDoctorCellSectionFooterView"];
    }
    return _collectionView;
}

- (KNBSortView *)sortView {
    if (!_sortView) {
        _sortView = [[KNBSortView alloc] initWithFrame:CGRectMake(0, KNB_NAV_HEIGHT + 50, KNB_SCREEN_WIDTH, 0) sortArr:@[ @"地中海风格", @"美式风格", @"中式风格", @"最受欢迎" ] superView:self.collectionView optionView:_sectionView];
        KNB_WS(weakSelf);
        _sortView.sortClicked = ^(NSInteger sortTag) {
//            weakSelf.selctSortTag = sortTag;
//            [weakSelf getAllDataArrayWithSortTag:sortTag];
//            [weakSelf.sortView showSortViewWithSortTag:sortTag];
//            [weakSelf requestLocalDataWith:1];
        };
    }
    return _sortView;
}

@end
