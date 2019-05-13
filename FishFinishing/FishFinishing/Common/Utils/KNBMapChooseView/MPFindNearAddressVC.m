//
//  MPAttentionFriendVC.m
//  honghong
//
//  Created by manpaoPlum on 15/3/5.
//  Copyright (c) 2015年 localhost. All rights reserved.
//

#import "MPFindNearAddressVC.h"
#import "MPFindFriendCell.h"
#import "UISearchBar+MP.h"
#import "MPFindNearAddressViewModel.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "MJRefresh.h"
#import "MPMapView.h"
#import "MPFindFriendCell.h"
#import "MPNoResultHeadView.h"
#import "MPAddNewAddressVC.h"
#import "KNBMapHeader.h"
#import "KNBSearchView.h"
#import "KNBNavigationView.h"

@interface MPFindNearAddressVC ()<UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate,MAMapViewDelegate,AMapSearchDelegate,KNBSearchViewDelegate,UISearchBarDelegate>
{
    NSString *_searchTypesStr;
    
    AMapPOIAroundSearchRequest *_aroundSearchRequest;
    
    AMapPOIKeywordsSearchRequest *_keywordsSearchRequest;
    
    UIImage *_shotImg;
    
    AMapPOI *_searchSelectModel;
    
}
//@property (nonatomic, strong) MPMapView *mapView1;

@property (nonatomic, strong) NSMutableArray *searchDataArr;
@property (nonatomic, strong) MPFindNearAddressViewModel *requestViewModel;
@property (nonatomic, strong) UITableView *searchResultsTableView;
@property (nonatomic, strong) KNBSearchView *searchView;
@property (nonatomic, strong) KNBNavigationView *navView;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) CLLocation *dingLocation;
@property (strong,nonatomic) UIActivityIndicatorView *reloadView;
@property (strong,nonatomic) UIView *reloadBGView;

@end

@implementation MPFindNearAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //050000 餐饮服务;餐饮相关场所;餐饮相关
    //060000 购物服务;购物相关场所;购物相关场所
    //070000 生活服务;生活服务场所;生活服务场所
    //080000 体育休闲服务;体育休闲服务场所;体育休闲服务场所
    //090000 医疗保健服务;医疗保健服务场所;医疗保健服务场所
    //100000 住宿服务;住宿服务相关;住宿服务相关
    //110000 风景名胜;风景名胜相关;旅游景点
    //120000 商务住宅;商务住宅相关;商务住宅相关
    //130000 政府机构及社会团体;政府及社会团体相关;政府及社会团体相关
    //140000 科教文化服务;科教文化场所;科教文化场所
    //150000 交通设施服务;交通服务相关;交通服务相关
    //160000 金融保险服务;金融保险服务机构;金融保险机构
    //170000 公司企业;公司企业;公司企业
    //180000 道路附属设施;道路附属设施;道路附属设施
    //_searchTypesStr = @"050000|060000|070000|100000|110000|170000";
    _searchTypesStr = @"地名地址信息|餐饮服务|购物服务|生活服务|风景名胜|公司企业";
    //_searchTypesStr = @"地名地址信息";
    [self initNavView];
    [self initTableView];
    [self initMapView];
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.reloadView];
    [self resultTableViewHidden:YES];

}
#pragma mark - initTableView
- (void)initTableView{
    
    
//    UIImageView *imageBack = [[UIImageView alloc]initWithFrame:self.view.bounds];
//    imageBack.backgroundColor = TABLE_BG_COLOR;
//    self.knbTableView.backgroundView = imageBack;

    self.knbTableView.showsVerticalScrollIndicator = NO;
    self.knbTableView.frame = CGRectMake(0, KNB_NAV_HEIGHT + 50, KNB_SCREEN_WIDTH, KNB_SCREEN_HEIGHT - KNB_NAV_HEIGHT - 50);
    self.knbTableView.dataSource = self.requestViewModel;
    self.knbTableView.delegate = self.requestViewModel;
    self.knbTableView.backgroundColor = TABLE_BG_COLOR;
    self.knbTableView.separatorColor = LINECOLOR;
    self.knbTableView.separatorInset = UIEdgeInsetsZero;
    
    [self setUpTableFootViewWithTitle:@"定位中..." andFootViewH:60];
    [self setUpRefreshViewWithView:self.knbTableView];
    self.knbTableView.refreshControl = nil;
    [self.view addSubview:self.knbTableView];
    [self.view addSubview:self.searchResultsTableView];
}
- (void)initNavView
{
    self.navView.title = @"所在位置";
    [self.navView addLeftBarItemImageName:@"knb_back_black" target:self sel:@selector(backAction)];
    [self.navView addRightBarItemTitle:@"确定" target:self sel:@selector(enterAction)];
    [self.navView.rightNaviButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.navView];
}

- (void)initMapView{
    _search = [[AMapSearchAPI alloc]init];
    _search.delegate = self;
    
    _mapView = [[MAMapView alloc]initWithFrame:CGRectZero];;
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
    _mapView.showsUserLocation = YES;
    
    _aroundSearchRequest = [[AMapPOIAroundSearchRequest alloc]init];
    _aroundSearchRequest.offset = 30;
    /* 按照距离排序. */
    _aroundSearchRequest.sortrule = 0;
    _aroundSearchRequest.requireExtension  = YES;
    _aroundSearchRequest.types = _searchTypesStr;
    
    _keywordsSearchRequest = [[AMapPOIKeywordsSearchRequest alloc]init];
    _keywordsSearchRequest.offset = 50;
    /* 按照距离排序. */
    _keywordsSearchRequest.sortrule = 1;
    _keywordsSearchRequest.requireExtension  = YES;
    _keywordsSearchRequest.cityLimit           = YES;
    _keywordsSearchRequest.requireSubPOIs      = YES;
    _keywordsSearchRequest.types = _searchTypesStr;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    _mapView.showsUserLocation = NO;
    _dingLocation = [userLocation.location copy];
    _currentLocation = _dingLocation;
    
    [self.requestViewModel.tableSectionHeadView layerFrameWithTitle:nil WithAddress:nil andLo:_dingLocation.coordinate.longitude andLa:_dingLocation.coordinate.latitude];
    
    [self loadNewData];
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    [self baseEndRefresh];
    [_reloadView stopAnimating];
//    _reloadBGView.hidden = YES;
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if ([request isKindOfClass:[AMapPOIAroundSearchRequest class]]) {
        
        [_reloadView stopAnimating];
//        _reloadBGView.hidden = YES;
        [self baseEndRefresh];

        [self layerModelDataWithArr:response.pois];
        
        AMapAOI *model = self.dataArr.firstObject;
        if (_searchSelectModel&&![model.name isEqualToString:_searchSelectModel.name]) {
            [self.dataArr insertObject:_searchSelectModel atIndex:0];
        }
        self.requestViewModel.models = self.dataArr;
        [self.knbTableView reloadData];
        
        self.knbTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        if (self.dataArr.count == 0) {
            self.knbTableView.mj_footer.hidden = YES;
            [self layerTableFootViewWithTitle:@"还没有数据哦" andFootViewH:60];
        }else{
            if (response.pois.count==0) {
                self.knbTableView.mj_footer.hidden = YES;
            }else{
                self.knbTableView.mj_footer.hidden = NO;
            }
        }
        
        [self cutMapImg];

    }
   

    if ([request isKindOfClass:[AMapPOIKeywordsSearchRequest class]]) {
        
        if (response.pois.count==0) {
            MPNoResultHeadView *noResultLabel = [[MPNoResultHeadView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];
             noResultLabel.textStr = [NSString stringWithFormat:@"没有找到 %@",self.searchView.searchBar.text];
//            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_noResultLabel)];
//            [noResultLabel addGestureRecognizer:tap1];
            self.searchResultsTableView.tableFooterView = noResultLabel;
        }else{
            UIView *view = [UIView new];
            self.searchResultsTableView.tableFooterView = view;
        }
        [_searchDataArr removeAllObjects];
        [_searchDataArr  addObjectsFromArray:response.pois];
        [self.searchResultsTableView reloadData];

    }
}
- (void)tap_noResultLabel
{
    MPAddNewAddressVC *vc = [MPAddNewAddressVC new];
    vc.dingLocation = _dingLocation;
    vc.namestr = self.searchView.searchBar.text;
    [vc setReturnBlock:^(NSString *name,CGFloat latitude,CGFloat longitude){
        if (self.returnBlock) {
            self.returnBlock(nil,nil,name,nil,latitude,longitude,nil,nil);
        }
    
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -
- (void)cutMapImg {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIGraphicsBeginImageContextWithOptions(self.requestViewModel.tableSectionHeadView.bounds.size, NO, 0);
        [self.requestViewModel.tableSectionHeadView.layer renderInContext:UIGraphicsGetCurrentContext()];
        self->_shotImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
}


- (void)searchRequestNearPIOSWithPage:(NSString *)page
{
    if (_currentLocation==nil||_search==nil) {
        return;
    }
   
    _aroundSearchRequest.location =  [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    _aroundSearchRequest.page = [page integerValue];
    [self.search AMapPOIAroundSearch:_aroundSearchRequest];
}

- (void)getData:(NSString*)page{
    
    [self searchRequestNearPIOSWithPage:page];
}

#pragma mark -  UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AMapPOI *model = self.searchDataArr[indexPath.row];
    MPFindFriendCell *cell = [MPFindFriendCell cellWithTableView:tableView];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.address;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [MPFindFriendCell getCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.02;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.searchView.searchBar.text = @"";
    [self.searchView.searchBar resignFirstResponder];
    [self resultTableViewHidden:YES];
    AMapPOI *model = self.searchDataArr[indexPath.row];
    [self didseletIndex:model andIsSearch:YES];
}

- (void)didseletIndex:(AMapPOI *)model andIsSearch:(BOOL)issearch {
    [_reloadView startAnimating];
//    _reloadBGView.hidden = NO;
    _currentLocation =  [[CLLocation alloc]initWithLatitude:model.location.latitude longitude:model.location.longitude];
    [self.requestViewModel.tableSectionHeadView layerFrameWithTitle:nil WithAddress:nil andLo:model.location.longitude andLa:model.location.latitude];
    _searchSelectModel = model;
    if (issearch) {
        [self.knbTableView scrollToTopAnimated:NO];
    }else{
        [self.knbTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    [self loadNewData];



}
#pragma mark - scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.knbTableView) {
        [self.searchView.searchBar resignFirstResponder];
        CGFloat tableCH = self.knbTableView.contentOffset.y;
        CGFloat tableH = self.knbTableView.contentSize.height;
        if ( fabs(tableH - tableCH) <  ScreenHeight+64){
            [self.knbTableView.mj_footer beginRefreshing];
        }
    }
    
}

#pragma mark - respon event
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)enterAction {
    if (self.requestViewModel.models.count>0) {
        AMapPOI *model = self.requestViewModel.models[0];
        if (self.returnBlock) {
            
            self.returnBlock(model.city,model.district,model.name,model.address,model.location.latitude,model.location.longitude,model.tel,_shotImg);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        //[self showHoderView:@"还没有选择位置"];
    }
}

- (void)resultTableViewHidden:(BOOL)hidden {
    if (hidden) {
        KNB_WS(weakSelf);
        [UIView animateWithDuration:0.3 animations:^{
            self.searchResultsTableView.alpha = 0;
        } completion:^(BOOL finished) {
            weakSelf.searchDataArr = @[].mutableCopy;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.searchResultsTableView.alpha = 1;
        }];
    }
}

#pragma mark -  setter and getter

-(MPFindNearAddressViewModel *)requestViewModel
{
    if (!_requestViewModel) {
        _requestViewModel = [[MPFindNearAddressViewModel alloc] initWithSelectBlock:^(NSIndexPath *indexPath) {
                AMapPOI *model = self.dataArr[indexPath.row];
                [self didseletIndex:model andIsSearch:NO];
        }];
    }
    return _requestViewModel;
}

- (NSMutableArray *)searchDataArr
{
    if (_searchDataArr == nil) {
        _searchDataArr = [NSMutableArray new];
    }
    return _searchDataArr;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchMyFriends:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (isNullStr(searchBar.text) && isNullStr(searchText)) {
        [self resultTableViewHidden:YES];
        [self.searchView.searchBar resignFirstResponder];
    } else {
        [self resultTableViewHidden:NO];
        [self searchMyFriends:searchText];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchView.searchBar resignFirstResponder];
    [self resultTableViewHidden:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
}

#pragma mark - searchdata
- (void)searchMyFriends:(NSString *)searchStr {
    _keywordsSearchRequest.location =  [AMapGeoPoint locationWithLatitude:_dingLocation.coordinate.latitude longitude:_dingLocation.coordinate.longitude];
    _keywordsSearchRequest.keywords = searchStr;
    [_search AMapPOIKeywordsSearch:_keywordsSearchRequest];
    
}

#pragma mark - Getter
- (UIActivityIndicatorView *)reloadView {
    if (!_reloadView) {
        CGFloat top = 50 + CHOOSEMAPVIEWMAPH + KNB_NAV_HEIGHT;
        CGFloat height = KNB_SCREEN_HEIGHT - top;
        UIActivityIndicatorView *testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        testActivityIndicator.backgroundColor = [UIColor whiteColor];
        testActivityIndicator.frame = CGRectMake(0, top, ScreenWidth, height);
        [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
        _reloadView = testActivityIndicator;
    }
    return _reloadView;
}

- (KNBSearchView *)searchView {
    if (!_searchView) {
        _searchView = [[KNBSearchView alloc] initWithFrame:CGRectMake(0, KNB_NAV_HEIGHT, KNB_SCREEN_WIDTH, 50) isNavView:NO isHaveBackButton:NO isHaveCancleButton:NO style:KNBSearchViewStyleWhite];
        _searchView.searchBar.placeholder = @"搜索位置";
        _searchView.searchBar.delegate = self;
        KNB_WS(weakSelf);
        _searchView.backBlock = ^() {
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        };
    }
    return _searchView;
}

- (KNBNavigationView *)navView {
    if (!_navView) {
        _navView = [[KNBNavigationView alloc] init];
        _navView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, KNB_NAV_HEIGHT);
    }
    return _navView;
}

- (UITableView *)searchResultsTableView {
    if (!_searchResultsTableView) {
        CGRect frame = CGRectMake(0, KNB_NAV_HEIGHT + 50, KNB_SCREEN_WIDTH, KNB_SCREEN_HEIGHT - KNB_NAV_HEIGHT - 50);
        _searchResultsTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _searchResultsTableView.backgroundColor = [UIColor knBgColor];
        _searchResultsTableView.delegate = self;
        _searchResultsTableView.dataSource = self;
    }
    return _searchResultsTableView;
}

@end


