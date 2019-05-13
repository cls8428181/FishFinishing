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
// 是否登陆过
@property (nonatomic, assign) BOOL isLogin;
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

/**
 分享的信息
 
 @param messages @[@"标题"，@“简介”，@“链接”]
 @param isActionType 是不是美臀活动
 @param shareButtonBlock 分享成功需要跳转
 
 */
- (void)shareMessages:(NSArray *)messages isActionType:(BOOL)isActionType shareButtonBlock:(void (^)(NSInteger platformType, BOOL success))shareButtonBlock;


/**
 分享信息
 
 @param messages @[@"标题"，@“简介”，@“链接”]
 @param channel 分享渠道
 @param callBack 分享结果回调 分享回调的渠道
 */
- (void)shareMessages:(NSArray *)messages
              channel:(NSString *)channel
             callBack:(void (^)(NSString *channel, BOOL result))callBack;

/**
 分享图片
 */
- (void)shareImageWithMessages:(NSArray *)messages image:(UIImage *)image shareButtonBlock:(void (^)(NSInteger platformType, BOOL success))shareButtonBlock;

@end
