//
//  KNBPrecompile.h
//  KenuoTraining
//
//  Created by Robert on 16/2/22.
//  Copyright © 2016年 Robert. All rights reserved.
//

#ifndef KNBPrecompile_h
#define KNBPrecompile_h

//主代理
#define KNB_AppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
//全局tabBar
#define KNB_TabBarVc (KNTabBarViewController *)KNB_AppDelegate.tabBarController

//单例宏定义.h
#define KNB_DEFINE_SINGLETON_FOR_HEADER(className) \
                                                   \
    +(className *)shareInstance

//单例宏定义.m
#define KNB_DEFINE_SINGLETON_FOR_CLASS(className) \
                                                  \
    +(className *)shareInstance {                 \
        static className *instance = nil;         \
        static dispatch_once_t onceToken;         \
        dispatch_once(&onceToken, ^{              \
            instance = [[self alloc] init];       \
        });                                       \
        return instance;                          \
    }

//色值宏定义
#define KNB_RGBA(r, g, b, a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]
#define KNB_RGB(r, g, b) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1.0]

//字体大小
#define KNB_FONT_SIZE_DEFAULT(size) [UIFont systemFontOfSize:size]
#define KNB_FONT_SIZE_BOLD(size) [UIFont boldSystemFontOfSize:size]

//分页查询一次返回的最大数
#define KNB_PAGE_MAX_NUMBER 20
//当前系统版本
#define KNB_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//App版本
#define KNB_APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//屏幕大小
#define KNB_SCREEN_BOUNDS [[UIScreen mainScreen] bounds]
//设备屏幕高度
#define KNB_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
//设备屏幕宽度
#define KNB_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

//判断是否是iphoneX XS
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size)) : NO)
// 判断iPHoneXR
#define IS_IPHONE_XR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断iPhoneXs_Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)
// X、XR、XS、XS_MAX系列
#define KNB_ISIPHONEX ((IS_IPHONE_X == YES || IS_IPHONE_XR == YES || IS_IPHONE_Xs_Max == YES) ? YES : NO)
//不包括状态栏的导航高度
#define KNB_unStatusNav_H 44
//状态栏高度
#define KNB_StatusBar_H (KNB_ISIPHONEX ? 44 : 20)
//导航条高度
#define KNB_NAV_HEIGHT (KNB_StatusBar_H + KNB_unStatusNav_H)
//tabar高度
#define KNB_TAB_HEIGHT (KNB_ISIPHONEX ? 83 : 49)
//tabar图片间隔
#define KNB_TAB_IMAGEMARGIN (KNB_ISIPHONEX ? 40 : 10)

#define KNB_NAV_COLOR [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1.0]
//图片名字
#define KNBImages(imageName) [UIImage imageNamed:imageName]
//字体大小
#define KNBFont(font) [UIFont systemFontOfSize:font]
//字体大小
#define KNBColor(color) [UIColor colorWithHex:color]
//图片地址
#define KNBImageUrl(imageUrl) [NSURL URLWithString:imageUrl]
//过滤字符串
#define KNBLimitString(string, index) (!isNullStr(string) && string.length > index) ? [string substringWithRange:NSMakeRange(0, index)] : string;

//权限判断
#define KNB_HasJurisdiction(moduleName) [[KNBUserInfo shareInstance] hasJurisdiction:moduleName]

//沙盒路径
#define KNB_PATH_SANDBOX (NSHomeDirectory())
#define KNB_PATH_DOCUMENTS (NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0])
#define KNB_PATH_LIBRARY (NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0])
#define KNB_PATH_CACHE (NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0])
#define KNB_PATH_TMP (NSTemporaryDirectory())

//weakSelf
#define KNB_WS(weakSelf) __weak __typeof(self) weakSelf = self;

//strongSelf
#define KNB_SS(strongSelf, weakSelf) __strong __typeof(weakSelf) strongSelf = weakSelf;

#define KEY_WINDOW [UIApplication sharedApplication].keyWindow

#define TICK NSDate *startTime = [NSDate date]
#define TOCK NSLog(@"Time: %f", -[startTime timeIntervalSinceNow])
/// weakSelf
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) \
    autoreleasepool {}  \
    __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) \
    autoreleasepool {}  \
    __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) \
    try {               \
    } @finally {        \
    }                   \
    {}                  \
    __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) \
    try {               \
    } @finally {        \
    }                   \
    {}                  \
    __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

/// strongSelf
#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) \
    autoreleasepool {}    \
    __typeof__(object) object = weak##_##object;
#else
#define strongify(object) \
    autoreleasepool {}    \
    __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) \
    try {                 \
    } @finally {          \
    }                     \
    __typeof__(object) object = weak##_##object;
#else
#define strongify(object) \
    try {                 \
    } @finally {          \
    }                     \
    __typeof__(object) object = block##_##object;
#endif
#endif
#endif


#define CCPortraitPlaceHolderName @"knb_default_user"
#define CCPortraitPlaceHolder KNBImages(CCPortraitPlaceHolderName)

#endif /* KNBPrecompile_h */
