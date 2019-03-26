//
//  KNBMainConfigModel.h
//  KenuoTraining
//
//  Created by Robert on 16/2/29.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "KNBBaseModel.h"

//主配置字典
extern NSString *const KNB_BaseUrlKey;


@interface KNBMainConfigModel : NSObject

// 启动广告图url
@property (nonatomic, copy) NSString *launch_adPhotoUrl;
// 启动广告跳转url
@property (nonatomic, copy) NSString *launch_adJumpUrl;
// 启动广告标题
@property (nonatomic, copy) NSString *launch_adName;

+ (instancetype)shareInstance;

- (void)regestMainConfig:(id)request;

- (NSString *)getRequestUrlWithKey:(NSString *)key;

- (NSString *)newVersion;

@end
