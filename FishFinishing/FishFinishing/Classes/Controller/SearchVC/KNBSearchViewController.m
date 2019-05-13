//
//  KNBSearchViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/22.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBSearchViewController.h"
#import "KNBSearchView.h"
#import "KNBRecruitmentCaseListApi.h"
#import "KNBDesignSketchModel.h"
#import "KNBDesignSketchDetailViewController.h"
#import "KNBDesignSketchCollectionViewCell.h"

@interface KNBSearchViewController () <KNBSearchViewDelegate, UIGestureRecognizerDelegate, UISearchBarDelegate,UICollectionViewDelegate, UICollectionViewDataSource>
//滑动区域
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) KNBSearchView *searchView;
@property (nonatomic, strong) UIView *headerView;
//网络请求
@property (nonatomic, strong) KNBRecruitmentCaseListApi *api;

@end

@implementation KNBSearchViewController
#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if ([self.knbTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.knbTableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    if ([self.knbTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.knbTableView setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configuration];
    
    [self addUI];
    
    [self settingConstraints];
}

#pragma mark - Utils
- (void)configuration {
    [self.naviView addRightBarItemTitle:@"  取消" target:self sel:@selector(cancelAction)];
    self.view.backgroundColor = [UIColor knBgColor];
}

- (void)addUI {
    [self.naviView removeFromSuperview];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.searchView];
    [self.view bringSubviewToFront:self.searchView];
//    UITapGestureRecognizer *tap =
//    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSerchBarWhenTapBackground:)];
//    tap.delegate = self;
//    [self.view addGestureRecognizer:tap];
}

- (void)settingConstraints {
    KNB_WS(weakSelf);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.searchView.mas_bottom).mas_offset(0);
    }];
}


- (void)fetchData:(NSString *)searchStr {
    KNB_WS(weakSelf);
    if (isNullStr(searchStr)) {
        [self.dataArray removeAllObjects];
        [self.collectionView reloadData];
    } else {
        self.api.search = searchStr;
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

#pragma mark - SearchController Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
}
- (void)searchView:(KNBSearchView *)searchView startSearchWithSearchText:(NSString *)searchText {
}

- (void)searchViewSearchBarTextDidChange:(NSString *)searchText {
    [self fetchData:searchText];
}

- (void)refreshSearchView:(NSString *)searchText {
    NSString *searchStr = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self.collectionView reloadData];
}

- (CGFloat)labelAdaptive:(NSString *)string {
    float maxWidth = self.view.frame.size.width - 20;
    CGRect textRect = [string boundingRectWithSize:CGSizeMake(maxWidth, 8000) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14.0] } context:nil];
    textRect.size.height = ceilf(textRect.size.height);
    return textRect.size.height + 5;
}

- (NSString *)changeString:(NSString *)str appendStr:(NSString *)appendStr {
    if (str.length > 0) {
        str = [NSString stringWithFormat:@"%@,%@", str, appendStr];
    } else {
        str = appendStr;
    }
    return str;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchView.searchBar resignFirstResponder];
}

- (void)hideSerchBarWhenTapBackground:(id)sender {
    [self.searchView.searchBar resignFirstResponder];
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//        return NO;
//    }
//    return YES;
//}

#pragma mark - Event Response
- (void)cancelAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getters And Setters
/* getter和setter全部都放在最后*/
- (KNBSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[KNBSearchView alloc] initWithFrame:CGRectMake(0, 0, KNB_SCREEN_WIDTH, KNB_NAV_HEIGHT) isNavView:YES isHaveBackButton:NO isHaveCancleButton:YES style:KNBSearchViewStyleWhite];
        _searchView.searchBar.placeholder = @"请输入搜索内容";
        KNB_WS(weakSelf);
        _searchView.backBlock = ^() {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        _searchView.delegate = self;
        [_searchView.searchBar becomeFirstResponder];
    }
    return _searchView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
//        layout.headerReferenceSize = CGSizeMake(KNB_SCREEN_WIDTH, 50); //头视图的大小
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
        _api.hudString = @"";
    }
    return _api;
}

@end
