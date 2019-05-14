//
//  KNBThirdManager.h
//  KenuoTraining
//
//  Created by 吴申超 on 16/3/14.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KNBAppManager : NSObject


KNB_DEFINE_SINGLETON_FOR_HEADER(KNBAppManager);

/**
 配置第三方
 */
- (void)configureThird;

/**
 *  token 过期验证
 */
- (void)configureRequestFilters;

/**
 * 配置数据库
 */
- (void)configureCoreDataPath;

//
///**
// 删除解密文件路径
// */
//- (void)clearTmpSecretFilePath;

@end
