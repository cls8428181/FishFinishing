//
//  KNBHomeCompanyExperienceViewController.m
//  FishFinishing
//
//  Created by apple on 2019/5/5.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeCompanyExperienceViewController.h"
#import "KNBHomeExperienceHeaderView.h"
#import "KNBHomeExperienceFooterView.h"
#import "KNBRecruitmentCostApi.h"
#import "KNBRecruitmentTypeModel.h"
#import "KNBRecruitmentModel.h"
#import "KNBHomeBuyTopCollectionViewCell.h"
#import "KNBRecruitmentPayViewController.h"
#import "NSDate+BTAddition.h"
#import "KNBHomeBannerApi.h"
#import "KNBHomeBannerModel.h"
#import "KNBRecruitmentPayViewController.h"
#import "KNBMeAboutViewController.h"

@interface KNBHomeCompanyExperienceViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
//滑动区域
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) KNBHomeExperienceHeaderView *headerView;
@property (nonatomic, strong) KNBHomeExperienceFooterView *footerView;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) KNBRecruitmentModel *recruitmentModel;
@end

@implementation KNBHomeCompanyExperienceViewController
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
        make.top.mas_equalTo(KNB_NAV_HEIGHT);
    }];
}

#pragma mark - Utils
- (void)configuration {
    if ([self.model.is_experience isEqualToString:@"1"]) {
        self.naviView.title = @"体验版升级";
    } else {
        self.naviView.title = @"正式版续费";
    }
    [self.naviView addLeftBarItemImageName:@"knb_back_black" target:self sel:@selector(backAction)];
    self.view.backgroundColor = [UIColor colorWithHex:0xfafafa];
    self.collectionView.backgroundColor = [UIColor colorWithHex:0xfafafa];
    
}

- (void)addUI {
    [self.view addSubview:self.collectionView];
}

- (void)fetchData {
    KNBRecruitmentCostApi *api = [[KNBRecruitmentCostApi alloc] initWithCatId:[self.model.cat_id integerValue] costType:1];
    api.package_type = 2;
    api.hudString = @"";
    KNB_WS(weakSelf);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            [weakSelf.dataArray removeAllObjects];
            NSDictionary *dic = request.responseObject[@"list"];
            NSMutableArray *modelArray = [KNBRecruitmentCostModel changeResponseJSONObject:dic];
            [weakSelf.dataArray addObjectsFromArray:modelArray];
            [weakSelf.collectionView reloadData];
        } else {
            [weakSelf requestSuccess:NO requestEnd:NO];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [weakSelf requestSuccess:NO requestEnd:NO];
    }];
    
    KNBHomeBannerApi *bannerApi = [[KNBHomeBannerApi alloc] initWithVari:@"promotion_advent_img" cityName:[KNGetUserLoaction shareInstance].cityName];
    bannerApi.hudString = @"";
    [bannerApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (bannerApi.requestSuccess) {
            NSDictionary *dic = request.responseObject[@"list"];
            NSArray *modelArray = [KNBHomeBannerModel changeResponseJSONObject:dic];
            weakSelf.headerView.bannerModel = modelArray.firstObject;
            weakSelf.headerView.serviceModel = weakSelf.model;
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
    }];
}

#pragma mark - collectionview delegate & dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
//每一个cell是什么
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KNBRecruitmentCostModel *model = self.dataArray[indexPath.row];
    KNBHomeBuyTopCollectionViewCell *cell = [KNBHomeBuyTopCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    cell.model = model;
    return cell;
}

//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(85, 125);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    KNB_WS(weakSelf);
    // 如果是头视图
    if (kind == UICollectionElementKindSectionHeader) {
        // 从重用池里面取
        self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"KNBHomeExperienceHeaderView" forIndexPath:indexPath];
        if ([self.model.is_experience isEqualToString:@"1"]) {
            self.headerView.markLabel.text = @"体验版";
        } else {
            self.headerView.markLabel.text = @"正式版";
        }
        return _headerView;
    }else{
        self.footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"KNBHomeExperienceFooterView" forIndexPath:indexPath];
        if ([self.model.is_experience isEqualToString:@"1"]) {
            [self.footerView.upgradeButton setTitle:@"立即升级" forState:UIControlStateNormal];
        } else {
            [self.footerView.upgradeButton setTitle:@"立即续费" forState:UIControlStateNormal];
        }
        self.footerView.upgradeButtonBlock = ^{
            if (weakSelf.recruitmentModel.priceModel) {
                KNBRecruitmentPayViewController *payVC = [[KNBRecruitmentPayViewController alloc] init];
                payVC.recruitmentModel = weakSelf.recruitmentModel;
                payVC.type = KNBPayVCTypeExperience;
                [weakSelf.navigationController pushViewController:payVC animated:YES];
            } else {
                [KNBAlertRemind alterWithTitle:@"提示" message:@"请选择一个价格套餐" buttonTitles:@[ @"知道了" ] handler:^(NSInteger index, NSString *title){
                    
                }];
            }

        };
        self.footerView.serviceButtonBlock = ^{
            KNBMeAboutViewController *aboutVC = [[KNBMeAboutViewController alloc] init];
            [weakSelf.navigationController pushViewController:aboutVC animated:YES];
        };
        return _footerView;
    }
    
}

//cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //遍历viewModel的数组，如果点击的行数对应的viewModel相同，将isSelected变为Yes，反之为No
    for (int i = 0; i<[self.dataArray count]; i++) {
        KNBRecruitmentCostModel *costModel = self.dataArray[i];
        if (i!=indexPath.row) {
            costModel.isSelected = NO;
        }else if (i == indexPath.row){
            costModel.isSelected = YES;
            self.recruitmentModel.priceModel = costModel;
        }
    }
    [collectionView reloadData];
}

#pragma mark - Event Response
/*
 *  所有button、gestureRecognizer的响应事件都放在这个区域里面，不要到处乱放。
 */
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getters And Setters
/* getter和setter全部都放在最后*/
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = (KNB_SCREEN_WIDTH - 335)/2;
        layout.minimumLineSpacing = 13;
        layout.headerReferenceSize = CGSizeMake(KNB_SCREEN_WIDTH, 360); //头视图的大小
        layout.footerReferenceSize = CGSizeMake(KNB_SCREEN_WIDTH, 193); //头视图的大小
        layout.sectionInset = UIEdgeInsetsMake(18, 40, 24, 40);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"KNBHomeBuyTopCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"KNBHomeBuyTopCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"KNBHomeExperienceHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"KNBHomeExperienceHeaderView"];
        [_collectionView registerNib:[UINib nibWithNibName:@"KNBHomeExperienceFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"KNBHomeExperienceFooterView"];
    }
    return _collectionView;
}

- (void)setModel:(KNBHomeServiceModel *)model {
    _model = model;
    self.recruitmentModel.serviceModel = model;
}

- (KNBRecruitmentModel *)recruitmentModel {
    if (!_recruitmentModel) {
        _recruitmentModel = [[KNBRecruitmentModel alloc] init];
    }
    return _recruitmentModel;
}

@end
