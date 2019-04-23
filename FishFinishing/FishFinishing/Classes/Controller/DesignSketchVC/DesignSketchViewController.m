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
#import "KNBRecruitmentCaseListApi.h"
//controllers
#import "KNBDesignSketchDetailViewController.h"
#import "KNBDesignSketchModel.h"
#import "CQTopBarViewController.h"
#import "KNBHomeCompanyTagsViewController.h"
#import "KNBHomeCompanyHouseViewController.h"
#import "KNBHomeCompanyAreaViewController.h"

@interface DesignSketchViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
//滑动区域
@property (nonatomic, strong) UICollectionView *collectionView;
//顶部下拉筛选
@property (nonatomic, strong) KNBDesignSketchCollectionSectionView *sectionView;
@property (nonatomic, strong) CQTopBarViewController *topBar;
//网络请求
@property (nonatomic, strong) KNBRecruitmentCaseListApi *api;

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
    if (self.isTabbar) {
        [self.naviView removeLeftBarItem];
    }
    self.naviView.titleNaviLabel.textColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor knBgColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TagsNotificationAction:) name:NSStringFromClass([KNBHomeCompanyTagsViewController class]) object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HouseNotificationAction:) name:NSStringFromClass([KNBHomeCompanyHouseViewController class]) object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AreaNotificationAction:) name:NSStringFromClass([KNBHomeCompanyAreaViewController class]) object:nil];

    self.topBar = [[CQTopBarViewController alloc] init];
    self.topBar.segmentFrame = CGRectMake(0, KNB_NAV_HEIGHT, KNB_SCREEN_WIDTH, 50);
    self.topBar.sectionTitles = @[@"风格",@"户型",@"面积"];
    self.topBar.isDesign = YES;
    self.topBar.pageViewClasses = @[[KNBHomeCompanyTagsViewController class],[KNBHomeCompanyHouseViewController class],[KNBHomeCompanyAreaViewController class]];
    self.topBar.segmentlineColor = [UIColor whiteColor];
    self.topBar.segmentImage = @"knb_home_icon_down";
    self.topBar.selectSegmentImage = @"knb_home_icon_up";
    self.topBar.selectedTitleTextColor = [UIColor colorWithHex:0x0096e6];
    [self addChildViewController:self.topBar];
    [self.view addSubview:self.topBar.view];
    [self.topBar.footerView addSubview:self.collectionView];
    self.knbTableView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, KNB_SCREEN_HEIGHT - KNB_NAV_HEIGHT - 50);
    [self.view bringSubviewToFront:self.naviView];
    
}

- (void)addUI {
}

- (void)fetchData {

    KNB_WS(weakSelf);
    [self.api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (weakSelf.api.requestSuccess) {
            [weakSelf.dataArray removeAllObjects];
            NSDictionary *dic = request.responseObject[@"list"];
            NSArray *modelArray = [KNBDesignSketchModel changeResponseJSONObject:dic];
            [weakSelf.dataArray addObjectsFromArray:modelArray];
            [weakSelf.collectionView reloadData];
        } else {
            [weakSelf requestSuccess:NO requestEnd:NO];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [weakSelf requestSuccess:NO requestEnd:NO];
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
    KNBDesignSketchModel *model = self.dataArray[indexPath.row];
    KNBDesignSketchCollectionViewCell *cell = [KNBDesignSketchCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    cell.model = model;
    return cell;
}
//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(170, 192);
}

//cell的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    KNBDesignSketchModel *model = self.dataArray[indexPath.row];
    KNBDesignSketchDetailViewController *detailVC = [[KNBDesignSketchDetailViewController alloc] init];
    detailVC.model = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - Event Response
/*
 *  所有button、gestureRecognizer的响应事件都放在这个区域里面，不要到处乱放。
 */
- (void)TagsNotificationAction:(NSNotification *)notification {
    KNBRecruitmentTypeModel *model = notification.userInfo[@"model"];
    [self.topBar topBarReplaceObjectsAtIndexes:0 withObjects:model.catName];
    self.api.style_id = [model.typeId integerValue];
    [self fetchData];
}

- (void)HouseNotificationAction:(NSNotification *)notification {
    NSArray *tempArray = notification.userInfo[@"houseArray"];
    NSString *houseStr = @"";
    NSString *apartment = @"";
    apartment = [apartment stringByAppendingString:@"["];
    if ([tempArray[0] integerValue] != 0) {
        houseStr = [houseStr stringByAppendingString:[NSString stringWithFormat:@"%ld室、",[tempArray[0] integerValue]]];
        apartment = [apartment stringByAppendingString:[NSString stringWithFormat:@"[1,%ld],",[tempArray[0] integerValue]]];
    }
    if ([tempArray[1] integerValue] != 0) {
        houseStr = [houseStr stringByAppendingString:[NSString stringWithFormat:@"%ld厅、",[tempArray[1] integerValue]]];
        apartment = [apartment stringByAppendingString:[NSString stringWithFormat:@"[2,%ld],",[tempArray[1] integerValue]]];
    }
    if ([tempArray[2] integerValue] != 0) {
        houseStr = [houseStr stringByAppendingString:[NSString stringWithFormat:@"%ld厨、",[tempArray[2] integerValue]]];
        apartment = [apartment stringByAppendingString:[NSString stringWithFormat:@"[3,%ld],",[tempArray[2] integerValue]]];
    }
    if ([tempArray[3] integerValue] != 0) {
        houseStr = [houseStr stringByAppendingString:[NSString stringWithFormat:@"%ld卫、",[tempArray[3] integerValue]]];
        apartment = [apartment stringByAppendingString:[NSString stringWithFormat:@"[4,%ld],",[tempArray[3] integerValue]]];
    }
    if ([tempArray[4] integerValue] != 0) {
        houseStr = [houseStr stringByAppendingString:[NSString stringWithFormat:@"%ld阳台",[tempArray[4] integerValue]]];
        apartment = [apartment stringByAppendingString:[NSString stringWithFormat:@"[5,%ld]",[tempArray[0] integerValue]]];
    }
    if ([[houseStr substringFromIndex:[houseStr length]-1] isEqualToString:@"、"]) {
        houseStr = [houseStr substringToIndex:[houseStr length]-1];
    }
    if ([[apartment substringFromIndex:[apartment length]-1] isEqualToString:@","]) {
        apartment = [apartment substringToIndex:[apartment length]-1];
    }
    apartment = [apartment stringByAppendingString:@"]"];
    [self.topBar topBarReplaceObjectsAtIndexes:1 withObjects:houseStr];
    self.api.apartment = apartment;
    [self fetchData];
}

- (void)AreaNotificationAction:(NSNotification *)notification {
    NSString *titleString = notification.userInfo[@"text"];
    [self.topBar topBarReplaceObjectsAtIndexes:2 withObjects:titleString];
    if ([titleString containsString:@"全部"]) {
        self.api.min_area = 0.00;
        self.api.max_area = 999.00;
    } else if ([titleString containsString:@"以上"]) {
        self.api.min_area = 120.00;
        self.api.max_area = 999.00;
    } else {
        NSArray *strArray = [titleString componentsSeparatedByString:@"-"];
        self.api.min_area = [strArray.firstObject doubleValue];
        self.api.max_area = [strArray.lastObject doubleValue];
    }
    [self fetchData];
}


#pragma mark - Getters And Setters
/* getter和setter全部都放在最后*/
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        layout.headerReferenceSize = CGSizeMake(KNB_SCREEN_WIDTH, 50); //头视图的大小
        layout.sectionInset = UIEdgeInsetsMake(10, 12, 10, 12);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"KNBDesignSketchCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"KNBDesignSketchCollectionViewCell"];
    }
    return _collectionView;
}

- (KNBRecruitmentCaseListApi *)api {
    if (!_api) {
        _api = [[KNBRecruitmentCaseListApi alloc] init];
        _api.city_name = [KNGetUserLoaction shareInstance].cityName;
        _api.hudString = @"";
    }
    return _api;
}

@end
