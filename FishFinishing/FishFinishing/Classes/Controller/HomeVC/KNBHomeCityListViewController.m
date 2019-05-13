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

@interface KNBHomeCityListViewController ()<UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) NSArray *sectionArray;

@property (nonatomic, strong) NSDictionary *cityDataDic;

@property (nonatomic, strong) KNBHomeCityHeaderView *cityHeadView;

@property (nonatomic, strong) KNBSearchView *searchView;

@property (nonatomic, assign) BOOL isSearchResult;
//搜索数组
@property (nonatomic, strong) NSMutableArray *searchArray;
@end


@implementation KNBHomeCityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.naviView removeFromSuperview];
    [self.view addSubview:self.searchView];
    self.knbTableView.rowHeight = 38;
    [self.view addSubview:self.knbTableView];
    self.isSearchResult = NO;
    if (self.headerType == KNHomeCityHeaderCustom) {
        self.knbTableView.tableHeaderView = self.cityHeadView;
    } else {
        CGFloat topHeigh = self.cityHeadView.cityHeaderViewHeight;
        self.knbTableView.frame = CGRectMake(0, KNB_NAV_HEIGHT + topHeigh, KNB_SCREEN_WIDTH, KNB_SCREEN_HEIGHT - KNB_NAV_HEIGHT - topHeigh);
        [self.view addSubview:self.cityHeadView];
    }
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

    if (self.cityBlock) {
        self.cityBlock(cityDic[@"name"], cityDic[@"id"]);
    }
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
        _cityHeadView = [[KNBHomeCityHeaderView alloc] initWithViewType:self.headerType];
        _cityHeadView.currentCityName = self.currentCity;
        KNB_WS(weakSelf);
        _cityHeadView.allCityBlock = ^() {
            if (weakSelf.cityBlock) {
                weakSelf.cityBlock(@"全部城市", @"");
            }
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
    }
    return _cityHeadView;
}

- (void)setCurrentCity:(NSString *)currentCity {
    _currentCity = currentCity;
    self.cityHeadView.currentCityName = currentCity;
}

- (KNBSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[KNBSearchView alloc] initWithFrame:CGRectMake(0, 0, KNB_SCREEN_WIDTH, KNB_NAV_HEIGHT  ) isNavView:YES isHaveBackButton:YES isHaveCancleButton:NO style:KNBSearchViewStyleWhite];
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

@end
