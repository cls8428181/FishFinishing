//
//  KNBPayProtocolViewController.m
//  FishFinishing
//
//  Created by apple on 2019/4/26.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBPayProtocolViewController.h"
#import "KNBGetCollocationApi.h"
#import "KNBMeAboutModel.h"

@interface KNBPayProtocolViewController ()

@end

@implementation KNBPayProtocolViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configuration];
    
    [self addUI];
        
    [self fetchData];
}

#pragma mark - Utils
- (void)configuration {
    self.naviView.title = @"支付协议";
    [self.naviView addLeftBarItemImageName:@"knb_back_black" target:self sel:@selector(backAction)];
    self.view.backgroundColor = [UIColor knBgColor];
    self.showDocumentTitle = NO;
}

- (void)addUI {
    [self.view addSubview:self.webView];
}

- (void)fetchData {
    KNBGetCollocationApi *api = [[KNBGetCollocationApi alloc] initWithKey:@"System_setup"];
    api.hudString = @"";
    KNB_WS(weakSelf);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            NSDictionary *dic = request.responseObject[@"list"];
            KNBMeAboutModel *model= [KNBMeAboutModel changeResponseJSONObject:dic];
            NSString *htmlStr = [weakSelf htmlEntityDecode:model.payment_agreement];
            [weakSelf.webView loadHTMLString:htmlStr baseURL:nil];
            [weakSelf requestSuccess:YES requestEnd:YES];
        } else {
            [weakSelf requestSuccess:NO requestEnd:NO];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [weakSelf requestSuccess:NO requestEnd:NO];
    }];
}

//将 &lt 等类似的字符转化为HTML中的“<”等
- (NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    
    return string;
}

#pragma mark - Event Response
/*
 *  所有button、gestureRecognizer的响应事件都放在这个区域里面，不要到处乱放。
 */
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getters And Setters
/* getter和setter全部都放在最后*/


@end
