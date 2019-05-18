//
//  KNCityListViewController.m
//  Concubine
//
//  Created by 刘随义 on 16/6/12.
//  Copyright © 2016年 dengyun. All rights reserved.
//

#import "KNBHomeCityListViewController.h"
#import "KNBMainConfigModel.h"
#import "KNBSearchView.h"
#import "KNBCityModel.h"

@interface KNBHomeCityListViewController ()<UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) NSArray *sectionArray;
@property (nonatomic, strong) NSDictionary *cityDataDic;
//顶部当前选择城市
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *currentCityLabel;
@property (nonatomic, strong) UIView *lineView;
//tableview headerview
@property (nonatomic, strong) KNBHomeCityHeaderView *cityHeadView;
@property (nonatomic, strong) NSMutableArray *historyArray;
//搜索
@property (nonatomic, strong) KNBSearchView *searchView;
@property (nonatomic, assign) BOOL isSearchResult;
//搜索数组
@property (nonatomic, strong) NSMutableArray *searchArray;
@end


@implementation KNBHomeCityListViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configuration];
    
    [self addUI];
    
    [self settingConstraints];
}

#pragma mark - Setup UI Constraints
/*
 *  在这里添加UIView的约束布局相关代码
 */
- (void)settingConstraints {
    KNB_WS(weakSelf);
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.equalTo(weakSelf.searchView.mas_bottom).mas_offset(20);
    }];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.topImageView.mas_right).mas_offset(10);
        make.centerY.equalTo(weakSelf.topImageView);
    }];
    [self.currentCityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.topLabel.mas_right).mas_offset(10);
        make.centerY.equalTo(weakSelf.topImageView);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(weakSelf.topLabel.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(10);
    }];
    [self.knbTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(weakSelf.lineView.mas_bottom).mas_offset(0);
    }];
}

#pragma mark - Utils
- (void)configuration {
    [self.naviView removeFromSuperview];
    self.isSearchResult = NO;
    self.knbTableView.rowHeight = 38;
    self.knbTableView.tableHeaderView = self.cityHeadView;
    self.view.backgroundColor = [UIColor whiteColor];
    self.knbTableView.backgroundColor = [UIColor whiteColor];
}

- (void)addUI {
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.topImageView];
    [self.view addSubview:self.topLabel];
    [self.view addSubview:self.currentCityLabel];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.knbTableView];
}

- (void)leftButtonAction:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark----- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isSearchResult) {
        return 1;
    } else {
        return self.sectionArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearchResult) {
        return self.searchArray.count;
    } else {
        NSArray *array = self.cityDataDic[self.sectionArray[section]];
        return array.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //设置cell的textLabel的文本
    if (self.isSearchResult) {
        cell.textLabel.text = self.searchArray[indexPath.row][@"name"];
    } else {
        NSArray *cityArr = self.cityDataDic[self.sectionArray[indexPath.section]];
        cell.textLabel.text = cityArr[indexPath.row][@"name"];
    }

    cell.textLabel.textColor = [UIColor knLightGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:12.0];
    return cell;
}

#pragma mark----- UITableViewDelegation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *cityDic = nil;
    if (self.isSearchResult) {
        cityDic = self.searchArray[indexPath.row];
    } else {
        NSArray *cityArr = self.cityDataDic[self.sectionArray[indexPath.section]];
        cityDic = cityArr[indexPath.row];
    }
    !self.cityBlock ?: self.cityBlock(cityDic[@"name"], cityDic[@"id"]);
    KNBCityModel *cityModel = [KNBCityModel changeResponseJSONObject:cityDic];
    [KNBCityModel saveWithModel:cityModel resultBlock:^(BOOL success) {
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    label.textColor = [UIColor knLightGrayColor];
    label.backgroundColor = [UIColor knBgColor];
    label.text = [NSString stringWithFormat:@"    %@", self.sectionArray[section]];
    label.font = [UIFont systemFontOfSize:13];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isSearchResult) {
        return CGFLOAT_MIN;
    } else {
        return 20.0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionArray[section];
}

//设置tableView的右边索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    tableView.sectionIndexColor = [UIColor knLightGrayColor];
    return self.sectionArray;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.isSearchResult = YES;
    for (int i = 0; i < self.sectionArray.count; i++) {
        NSArray *cityArr = self.cityDataDic[self.sectionArray[i]];
        for (int j = 0; j < cityArr.count; j++) {
            NSDictionary *cityDic = cityArr[j];
            if ([cityDic[@"name"] containsString:searchBar.text]) {
                [self.searchArray addObject:cityDic];
            }
        }
    }
    [self.knbTableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (isNullStr(searchBar.text) && isNullStr(searchText)) {
        [self.searchView.searchBar resignFirstResponder];
        [self.searchArray removeAllObjects];
        self.isSearchResult = NO;
        self.knbTableView.tableHeaderView = self.cityHeadView;
        [self.knbTableView reloadData];
    } else {
        self.isSearchResult = YES;
        self.knbTableView.tableHeaderView = nil;
        [self.searchArray removeAllObjects];
        for (int i = 0; i < self.sectionArray.count; i++) {
            NSArray *cityArr = self.cityDataDic[self.sectionArray[i]];
            for (int j = 0; j < cityArr.count; j++) {
                NSDictionary *cityDic = cityArr[j];
                if ([cityDic[@"name"] containsString:searchText]) {
                    [self.searchArray addObject:cityDic];
                }
            }
        }
        [self.knbTableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchView.searchBar resignFirstResponder];
    [self.searchArray removeAllObjects];
    self.isSearchResult = NO;
    [self.knbTableView reloadData];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchView.searchBar resignFirstResponder];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
}


#pragma mark----- Setter && Getter
- (NSDictionary *)cityDataDic {
    if (!_cityDataDic) {
        NSString *areasPath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
        NSData *areasData = [[NSData alloc] initWithContentsOfFile:areasPath];
        NSDictionary *areas = [NSJSONSerialization JSONObjectWithData:areasData options:0 error:nil];
        _cityDataDic = areas[@"data"];
    }
    return _cityDataDic;
}

- (NSArray *)sectionArray {
    if (!_sectionArray) {
        NSArray *keyArray = [self.cityDataDic allKeys];
        _sectionArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2 options:NSLiteralSearch];
        }];
    }
    return _sectionArray;
}

- (KNBHomeCityHeaderView *)cityHeadView {
    if (!_cityHeadView) {
        _cityHeadView = [[KNBHomeCityHeaderView alloc] init];
        _cityHeadView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, [KNBHomeCityHeaderView cityHeaderViewHeight]);
        KNB_WS(weakSelf);
        _cityHeadView.selectComplete = ^(KNBCityModel *cityModel) {
            !weakSelf.cityBlock ?: weakSelf.cityBlock(cityModel.name, cityModel.code);
            [KNBCityModel saveWithModel:cityModel resultBlock:^(BOOL success) {
            }];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
    }
    return _cityHeadView;
}

- (void)setCurrentCity:(NSString *)currentCity {
    _currentCity = currentCity;
    self.currentCityLabel.text = currentCity;
}

- (KNBSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[KNBSearchView alloc] initWithFrame:CGRectMake(0, 0, KNB_SCREEN_WIDTH, KNB_NAV_HEIGHT) isNavView:YES isHaveBackButton:YES isHaveCancleButton:NO style:KNBSearchViewStyleWhite];
        _searchView.searchBar.placeholder = @"搜索城市";
        _searchView.searchBar.delegate = self;
        KNB_WS(weakSelf);
        _searchView.backBlock = ^() {
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        };
    }
    return _searchView;
}

- (NSMutableArray *)searchArray {
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] init];
        _topImageView.image = KNBImages(@"knb_me_dingwei");
    }
    return _topImageView;
}

- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.text = @"当前定位城市";
    }
    return _topLabel;
}

- (UILabel *)currentCityLabel {
    if (!_currentCityLabel) {
        _currentCityLabel = [[UILabel alloc] init];
        _currentCityLabel.text = self.currentCity;
    }
    return _currentCityLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor knf2f2f2Color];
    }
    return _lineView;
}

- (NSMutableArray *)historyArray {
    if (!_historyArray) {
        _historyArray = [NSMutableArray array];
    }
    return _historyArray;
}

@end
