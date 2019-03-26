//
//  NSURL+Video.h
//  KenuoTraining
//
//  Created by Robert on 16/3/29.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>


@interface NSURL (Video)

/**
 *  视频格式转换
 *
 *  @param inputURL  视频Url
 *  @param outputURL 转换输出Url
 *  @param handler   转换成功回调
 */
+ (void)convertVideoQuailtyWithInputURL:(NSURL *)inputURL
                              outputURL:(NSURL *)outputURL
                        completeHandler:(void (^)(AVAssetExportSession *))handler;
@end
