//
//  KNBBaseViewController.h
//  KenuoTraining
//
//  Created by 吴申超 on 16/2/26.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "KNBNavigationView.h"

typedef void (^KNMJFooterLoadCompleteBlock)(NSInteger page);
typedef void (^KNMJHeaderLoadCompleteBlock)(NSInteger page);


@interface KNBBaseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *knbTableView;
@property (nonatomic, strong) UITableView *knGroupTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger requestPage; //加载页数
@property (nonatomic, strong) KNBNavigationView *naviView;


/**
 * 登录校验
 */
- (void)checkout_logInSuccessBlock:(void (^)(BOOL success))successBlock;

/**
 * RAC监听userId
 */
- (void)userId_RACObserveCompleteBlock:(void (^)(BOOL success))completeBlock;

/**
 *  添加下拉加载更多
 */
- (void)addMJRefreshHeadView:(KNMJHeaderLoadCompleteBlock)completeBlock;

/**
 *  添加上拉加载更多
 */
- (void)addMJRefreshFootView:(KNMJFooterLoadCompleteBlock)completeBlock;

/**
 上下拉请求结果回掉
 
 @param success 成功／失败
 @param end 是否请求结束
 */
- (void)requestSuccess:(BOOL)success requestEnd:(BOOL)end;


@end
