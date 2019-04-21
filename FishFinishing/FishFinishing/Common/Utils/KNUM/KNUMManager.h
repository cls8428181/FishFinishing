//
//  KNUMManager.h
//  Concubine
//
//  Created by 吴申超 on 16/8/30.
//  Copyright © 2016年 dengyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMShare/UMShare.h>

typedef NS_ENUM(NSInteger, KNUMManagerShare) {
    KNUMManagerShareWeibo = 99,
    KNUMManagerShareWeChat,
    KNUMManagerShareWeChatTimeline,
    KNUMManagerShareQQ,
    KNUMManagerShareQZone
};

typedef void (^KNUMManagerCompleteBlock)(BOOL success);


@interface KNUMManager : NSObject

@property (nonatomic, copy) KNUMManagerCompleteBlock completeBlock;

+ (instancetype)shareInstance;

/**
 * 友盟分享
 * @parame shareImageName 传nil时 为本地默认图 传其它时为网络图片
 */
- (void)showShareViewWithShareInfoTitle:(NSString *)title
                         shareImageName:(NSString *)shareImageName
                                   desc:(NSString *)desc
                               shareUrl:(NSString *)shareUrl
                  currentViewController:(UIViewController *)currentViewController;
/**
 * 友盟分享
 * @parame shareImageName 传nil时 为本地默认图
 */
- (void)showShareViewWithShareInfoTitle:(NSString *)title
                             shareImage:(UIImage *)shareImage
                                   desc:(NSString *)desc
                               shareUrl:(NSString *)shareUrl
                  currentViewController:(UIViewController *)currentViewController;
/**
 * 智能测肤 结果分
 */
- (void)shareSmartResultsAnalys:(UIViewController *)controller andAnalysID:(NSInteger)analysID andUserPhone:(NSString *)UserPhone;

/**转发的方法*/
- (void)shareWebPage:(UIViewController *)controller toPlatformType:(UMSocialPlatformType)platformType withTitle:(NSString *)title url:(NSString *)url descr:(NSString *)desc shareImageName:(NSString *)shareImageName withTransmit:(BOOL)transmit;

// 是否安装qq
+ (BOOL)isQQInstalled;

// 是否安装微信
+ (BOOL)isWeChatInstalled;

@end
