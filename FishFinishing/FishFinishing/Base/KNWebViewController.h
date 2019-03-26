//
//  KNWebViewController.h
//  Concubine
//
//  Created by ... on 16/7/15.
//  Copyright © 2016年 dengyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNBBaseViewController.h"
#import <WebKit/WebKit.h>

@interface KNWebViewController : KNBBaseViewController <UIWebViewDelegate>
// webView
@property (nonatomic, strong) UIWebView *webView;
// urlString
@property (nonatomic, copy) NSString *urlString;
// default YES
@property (nonatomic, assign) BOOL showDocumentTitle;
// default 返回是是否需要清除缓存
@property (nonatomic, assign) BOOL needGoBack;
// 分享按钮是否隐藏
@property (nonatomic, assign) BOOL shareButtonHidden;

- (void)leftBarButtonItemAction:(UIBarButtonItem *)item;

/**
 *  下拉重新加载
 */
- (void)addMJRefreshHeadView;

@end
