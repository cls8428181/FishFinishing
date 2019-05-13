//
//  KNBBaseViewController.m
//  KenuoTraining
//
//  Created by 吴申超 on 16/2/26.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "KNBBaseViewController.h"
#import <LCProgressHUD.h>
#import "NSString+HTML.h"

@interface KNBBaseViewController ()

@property (nonatomic, copy) KNMJFooterLoadCompleteBlock footerCompleteBlock;

@end


@implementation KNBBaseViewController

- (void)dealloc {
    NSLog(@"delloc=====%@", self.class);

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.naviView];
    [self.naviView addLeftBarItemImageName:@"knb_back_black" target:self sel:@selector(backAction)];
    self.view.backgroundColor = [UIColor knBgColor];
    self.requestPage = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    if (@available(iOS 11.0, *)) {
        _knGroupTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _knGroupTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _knGroupTableView.scrollIndicatorInsets = _knGroupTableView.contentInset;
        
        _knbTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _knbTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _knbTableView.scrollIndicatorInsets = _knbTableView.contentInset;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - UIBarButtonItemAction
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - Getting
- (UITableView *)knbTableView {
    if (!_knbTableView) {
        CGRect frame = CGRectMake(0, KNB_NAV_HEIGHT, KNB_SCREEN_WIDTH, KNB_SCREEN_HEIGHT - KNB_NAV_HEIGHT);
        _knbTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _knbTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _knbTableView.backgroundColor = [UIColor knBgColor];
        _knbTableView.delegate = self;
        _knbTableView.dataSource = self;
    }
    return _knbTableView;
}

- (UITableView *)knGroupTableView { // group
    if (!_knGroupTableView) {
        CGRect frame = CGRectMake(0, KNB_NAV_HEIGHT, KNB_SCREEN_WIDTH, KNB_SCREEN_HEIGHT - KNB_NAV_HEIGHT);
        _knGroupTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        _knGroupTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _knGroupTableView.backgroundColor = [UIColor knBgColor];
        _knGroupTableView.delegate = self;
        _knGroupTableView.dataSource = self;
        _knGroupTableView.sectionFooterHeight = 0.1;
        _knGroupTableView.sectionHeaderHeight = 0.1;
    }
    return _knGroupTableView;
}

- (KNBNavigationView *)naviView {
    if (!_naviView) {
        _naviView = [[KNBNavigationView alloc] init];
    }
    return _naviView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark-- RAC监听userId
- (void)userId_RACObserveCompleteBlock:(void (^)(BOOL success))completeBlock{
//    [[RACObserve([KNBUserInfo shareInstance], userId) ignore:@"-1"] subscribeNext:^(id _Nullable x) {
//        if (completeBlock) {
//            completeBlock(YES);
//        }
//    }];
}

#pragma mark - checkout_logIn
- (void)checkout_logInSuccessBlock:(void (^)(BOOL success))successBlock{
//    if ([[KNBUserInfo shareInstance] isLogin]) {
//        if (successBlock) {
//            successBlock(YES);
//        }
//    } else {
//        KNBLoginViewController *logInVC = [[KNBLoginViewController alloc] init];
//        UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:logInVC];
//        [self presentViewController:navigationVC animated:YES completion:nil];
//    }
}

#pragma mark -  MJRefresh
- (void)addMJRefreshFootView:(KNMJFooterLoadCompleteBlock)completeBlock {
    self.knGroupTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.knbTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.footerCompleteBlock = completeBlock;
}

- (void)loadMoreData {
    self.requestPage += 1;
    if (self.footerCompleteBlock) {
        self.footerCompleteBlock(self.requestPage);
    }
}

- (void)requestSuccess:(BOOL)success requestEnd:(BOOL)end {
    [self.knGroupTableView.mj_header endRefreshing];
    [self.knGroupTableView.mj_footer endRefreshing];
    [self.knbTableView.mj_header endRefreshing];
    [self.knbTableView.mj_footer endRefreshing];

    if (end) {
        [self.knbTableView.mj_footer endRefreshingWithNoMoreData];
        [self.knGroupTableView.mj_footer endRefreshingWithNoMoreData];
        [self.knGroupTableView reloadData];
        [self.knbTableView reloadData];
        return;
    }
    if (!success && self.requestPage > 1) {
        self.requestPage -= 1;
    } else {
        [self.knGroupTableView reloadData];
        [self.knbTableView reloadData];
    }
}

- (void)addMJRefreshHeadView:(KNMJHeaderLoadCompleteBlock)completeBlock {
    KNB_WS(weakSelf);
    MJRefreshNormalHeader *knbTableViewHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.knbTableView.mj_footer resetNoMoreData];
        weakSelf.requestPage = 1;
        if (completeBlock) {
            completeBlock(1);
        }
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    knbTableViewHeader.automaticallyChangeAlpha = YES;
    // 隐藏时间
    knbTableViewHeader.lastUpdatedTimeLabel.hidden = YES;
    self.knbTableView.mj_header = knbTableViewHeader;

    MJRefreshNormalHeader *knGroupTableViewHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.knGroupTableView.mj_footer resetNoMoreData];
        weakSelf.requestPage = 1;
        if (completeBlock) {
            completeBlock(1);
        }
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    knGroupTableViewHeader.automaticallyChangeAlpha = YES;
    // 隐藏时间
    knGroupTableViewHeader.lastUpdatedTimeLabel.hidden = YES;
    self.knGroupTableView.mj_header = knGroupTableViewHeader;
}

- (void)shareMessages:(NSArray *)messages isActionType:(BOOL)isActionType shareButtonBlock:(void (^)(NSInteger platformType, BOOL success))shareButtonBlock {
    if (messages.count == 3) {
        NSString *sharTitle = [messages[0] stringByConvertingHTMLToPlainText];
        NSString *shareContent = [messages[1] stringByDecodingHTMLEntities];
        NSString *shareUrl = [messages[2] stringByConvertingHTMLToPlainText];

        [[KNUMManager shareInstance] showShareViewWithShareInfoTitle:sharTitle shareImageName:@"" desc:shareContent shareUrl:shareUrl currentViewController:self];
    }
}

- (void)shareImageWithMessages:(NSArray *)messages image:(UIImage *)image shareButtonBlock:(void (^)(NSInteger platformType, BOOL success))shareButtonBlock {
    if (messages.count == 2) {
        NSString *sharTitle = [messages[0] stringByConvertingHTMLToPlainText];
        NSString *shareContent = [messages[1] stringByDecodingHTMLEntities];
        
        [[KNUMManager shareInstance] showShareViewWithShareInfoTitle:sharTitle shareImage:image desc:shareContent currentViewController:self];
    }
}

//- (void)shareMessages:(NSArray *)messages
//              channel:(NSString *)channel
//             callBack:(void (^)(NSString *channel, BOOL result))callBack {
//    [[KNUMManager shareInstance] shareDetail:messages channel:channel controller:self completeBlock:callBack];
//}

- (BOOL)isLogin {
    return [KNBUserInfo shareInstance].isLogin;
}

@end
