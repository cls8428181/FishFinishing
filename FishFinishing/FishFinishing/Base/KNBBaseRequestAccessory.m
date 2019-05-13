//
//  KNBBaseRequestAccessory.m
//  KenuoTraining
//
//  Created by Robert on 16/3/17.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "KNBBaseRequestAccessory.h"
#import <AFNetworking.h>
#import <LCProgressHUD.h>
#import "AppDelegate.h"
#import "KNBBaseRequest.h"
#import "KNBLoginViewController.h"


@implementation KNBBaseRequestAccessory

- (void)requestWillStart:(id)request {
    KNBBaseRequest *baseRequest = (KNBBaseRequest *)request;
    if (baseRequest.needHud || !isNullStr(baseRequest.hudString) || baseRequest.hudString != nil) {
        KNB_PerformOnMainThread(^{
            NSString *hudStirng = baseRequest.hudString != nil ? baseRequest.hudString : @"加载中";
            [LCProgressHUD showLoading:hudStirng];
        });
    }
}

- (void)requestWillStop:(id)request {
    
}

- (void)requestDidStop:(id)request {
    KNBBaseRequest *baseRequest = (KNBBaseRequest *)request;
    if ([KNBUserInfo shareInstance].userInfo && baseRequest.getRequestStatuCode == KNTraingError_token && [baseRequest.errMessage containsString:@"请重新登录"]) {
        
        [LCProgressHUD hide];
        [[KNBUserInfo shareInstance] logout];
        [KNB_AppDelegate.navController popToRootViewControllerAnimated:NO];
        [KNB_TabBarVc turnToControllerIndex:KNB_AppDelegate.tabBarController.lastSelectIndex];
        KNBLoginViewController *logInVC = [[KNBLoginViewController alloc] init];
        UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:logInVC];
        [KNB_AppDelegate.navController presentViewController:navigationVC animated:YES completion:nil];
        [KNBAlertRemind alterWithTitle:@"提示" message:@"登录信息已失效,请重新登录" buttonTitles:@[ @"知道了" ] handler:^(NSInteger index, NSString *title){

        }];
        return;
    }

    if (baseRequest.needHud || !isNullStr(baseRequest.hudString) || baseRequest.hudString != nil) {
        //请求失败
        if (baseRequest.error || baseRequest.responseStatusCode != 200) {
            if ([AFNetworkReachabilityManager sharedManager].reachable) {
                KNB_PerformOnMainThread(^{
                    [LCProgressHUD showFailure:@"请求失败"];
                });
            } else {
                KNB_PerformOnMainThread(^{
                    [LCProgressHUD showInfoMsg:@"网络异常，请检查网络后重试"];
                });
            }
        } else {
            KNB_PerformOnMainThread(^{
                if (baseRequest.requestSuccess ||
                    baseRequest.getRequestStatuCode == KNTraingError_update) {
                    [LCProgressHUD hide];
                } else {
                    [LCProgressHUD showFailure:baseRequest.errMessage ?: @"出错啦!"];
                }
            });
        }
    }
}

@end
