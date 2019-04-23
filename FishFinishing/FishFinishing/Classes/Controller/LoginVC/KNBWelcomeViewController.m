//
//  KNBWelcomeViewController.m
//  KenuoTraining
//
//  Created by 沙漠 on 2018/3/30.
//  Copyright © 2018年 Robert. All rights reserved.
//

#import "KNBWelcomeViewController.h"
#import "KNBStartPageView.h"
#import "AppDelegate.h"

@interface KNBWelcomeViewController () <UIScrollViewDelegate, WStartPageViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, copy) NSArray *pageData;

@end

@implementation KNBWelcomeViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrollView];
    for (int i = 0; i < self.pageData.count; i++) {
        KNBStartPageView *pageView = [KNBStartPageView creatStartPageView:CGRectMake(i * KNB_SCREEN_WIDTH, 0, KNB_SCREEN_WIDTH, KNB_SCREEN_HEIGHT)];
        pageView.pageDic = self.pageData[i];
        pageView.delegate = self;
        pageView.index = i;
        [self.scrollView addSubview:pageView];
    }
}

#pragma mark - WStartPageViewDelegate
- (void)wstartPageView:(KNBStartPageView *)pageView
                cancel:(UIButton *)cancel {
    if (self.delegate && [self.delegate respondsToSelector:@selector(isShowGuidePageViewComplete)]) {
        [self.delegate isShowGuidePageViewComplete];
        [self saveCurrentVersion];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat floatX = scrollView.contentOffset.x;
    self.scrollView.bounces = floatX > KNB_SCREEN_WIDTH;
    if (floatX > (self.pageData.count - 1) * KNB_SCREEN_WIDTH) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(isShowGuidePageViewComplete)]) {
            [self.delegate isShowGuidePageViewComplete];
            [self saveCurrentVersion];
        }
    }
}

+ (BOOL)isShowGuideView {
//    // 读取版本信息
//    NSString *localVersion = [[NSUserDefaults standardUserDefaults] objectForKey:VERSION_INFO_CURRENT];
//    NSString *currentVersion = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    if (isNullStr(localVersion) || ![currentVersion isEqualToString:localVersion]) {
//        return YES;
//    } else {
//        return NO;
//    }
    return NO;
}

// 保存版本信息
- (void)saveCurrentVersion {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *version = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    [user setObject:version forKey:VERSION_INFO_CURRENT];
    [user synchronize];
}

#pragma mark-- Getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KNB_SCREEN_WIDTH, KNB_SCREEN_HEIGHT)];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(KNB_SCREEN_WIDTH * self.pageData.count, KNB_SCREEN_HEIGHT);
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (NSArray *)pageData {
    if (!_pageData) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"KNBStartPage" ofType:@"plist"];
        _pageData = [[NSArray alloc] initWithContentsOfFile:path];
    }
    return _pageData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
