//
//  KNOCJSModel.h
//  Concubine
//
//  Created by 吴申超 on 16/8/25.
//  Copyright © 2016年 dengyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JSExport.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol KNOCJSObjectProtocol <JSExport>
// 我的团队
- (void)viewDetailMyTeam;
// 联系我们用于延迟返回
- (void)viewDetailDelayPopView;
// 返回按钮
- (void)viewDetailClose;
// 私人定制完成回调
- (void)viewDetailPersonalTailor;
// 商品ID 和 活动类型
JSExportAs(viewDetailGoodsId,
           -(void)viewDetailGoodsId
           : (NSString *)goodsId actionType
           : (NSString *)actionType);
//对战活动返回
- (void)viewOnBackPressed;
//web页分享
JSExportAs(viewDetailShare,
           -(void)viewDetailShare
           : (NSString *)title describe
           : (NSString *)describe url
           : (NSString *)url);
//文章详情内部链接跳转
- (void)gotoArticleDetails:(NSInteger)articleId;

@end

typedef void (^KNOCJSModelDetailGoodsIdBlock)(NSString *goodId, NSString *actionType);
typedef void (^KNOCJSModelDetailMyTeam)(void);
typedef void (^KNOCJSModelDetailPopViewController)(BOOL needDelay);
typedef void (^KNOCJSModelWebViewPopBlock)(void);
typedef void (^KNOCJSModelWebViewShareBlock)(NSString *title, NSString *describe, NSString *url);
typedef void (^KNOCJSModelGoToArticleDetails)(NSInteger articleId);

@interface KNOCJSModel : NSObject <KNOCJSObjectProtocol>

@property (nonatomic, copy) KNOCJSModelDetailMyTeam myTeamBlock;
@property (nonatomic, copy) KNOCJSModelDetailGoodsIdBlock goodsIdBlock;
@property (nonatomic, copy) KNOCJSModelDetailPopViewController popControllerBlock;
@property (nonatomic, copy) KNOCJSModelWebViewPopBlock webViewPopBlock;
@property (nonatomic, copy) KNOCJSModelWebViewShareBlock webViewShareBlock;
@property (nonatomic, copy) KNOCJSModelGoToArticleDetails gotoArticleDetailBlock;

@end
