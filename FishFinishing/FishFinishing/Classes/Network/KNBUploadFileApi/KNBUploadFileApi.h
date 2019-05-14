//
//  KNBUploadFileApi.h
//  KenuoTraining
//
//  Created by Robert on 16/3/16.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "KNBBaseRequest.h"

typedef void (^KNBUploadCompletionBlock)(NSArray *fileUrls);
typedef void (^KNBUploadFailBlock)(NSArray *failRequests, NSArray *successFileUrls);

@class YTKBatchRequest;


@interface KNBUploadFileApi : KNBBaseRequest

///**
// *  上传文件
// *
// *  @param dic 文件信息
// *
// *  @return 实例
// */
//
////KNBPublishContentItemType
////KNBPublishContentItemName
////KNBPublishContentItemPreviewImage
////KNBPublishContentItemOriginImage
//
//- (instancetype)initWithDictionary:(NSDictionary *)dic;

/**
 上传图片

 @param image 图片
 */
- (instancetype)initWithImage:(UIImage *)image;

/**
 *  批量上传
 *
 *  @param array 数据字典数组
 *  @param token 用户登录标识
 *  @param completeBlock 成功请求
 *  @param failureBlock  失败请求
 */
+ (YTKBatchRequest *)uploadWithArray:(NSArray *)array token:(NSString *)token complete:(KNBUploadCompletionBlock)completeBlock failure:(KNBUploadFailBlock)failureBlock;

/**
 *  批量上传
 *
 *  @param requests      请求数组
 *  @param token 用户登录标识
 *  @param completeBlock 成功请求
 *  @param failureBlock  失败请求
 */
+ (void)uploadWithRequests:(NSArray *)requests token:(NSString *)token complete:(KNBUploadCompletionBlock)completeBlock failure:(KNBUploadFailBlock)failureBlock;

/**
 *  获取请求返回的文件Url
 *
 *  @return Url
 */
- (NSString *)getUploadFileUrl;

@end
