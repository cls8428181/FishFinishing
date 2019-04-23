//
//  KNBSearchViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/22.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBSearchViewController.h"
#import "KNBSearchView.h"

@interface KNBSearchViewController () <KNBSearchViewDelegate, UIGestureRecognizerDelegate, UISearchBarDelegate>
@property (nonatomic, strong) KNBSearchView *searchView;

@property (nonatomic, strong) UIView *headerView;

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
}

#pragma mark - Utils
- (void)configuration {
    [self.naviView addRightBarItemTitle:@"  取消" target:self sel:@selector(cancelAction)];
    self.view.backgroundColor = [UIColor knBgColor];
}

- (void)addUI {
    [self.view addSubview:self.knbTableView];
    [self.naviView removeFromSuperview];
    [self.view addSubview:self.searchView];
    [self.view bringSubviewToFront:self.searchView];
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSerchBarWhenTapBackground:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

#pragma mark - tableview delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    view.backgroundColor = [UIColor colorWithHex:0xf0f0f6];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    [self.searchView.searchBar resignFirstResponder];
}

#pragma mark - SearchController Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
}
- (void)searchView:(KNBSearchView *)searchView startSearchWithSearchText:(NSString *)searchText {
}

- (void)searchViewSearchBarTextDidChange:(NSString *)searchText {
    [self.dataArray removeAllObjects];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    });
}

- (void)refreshSearchView:(NSString *)searchText {
    NSString *searchStr = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!self.dataArray.count && searchText.length > 0 && searchStr.length > 0) {
        self.knbTableView.tableHeaderView = self.headerView;
    } else {
        self.knbTableView.tableHeaderView = nil;
    }
    
    [self.knbTableView reloadData];
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

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

@end
