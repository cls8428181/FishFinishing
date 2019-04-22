//
//  KNBUploadFileApi.m
//  KenuoTraining
//
//  Created by Robert on 16/3/16.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "KNBUploadFileApi.h"
#import <AFNetworking.h>
#import <YTKBatchRequest.h>
#import "UIImage+Resize.h"


@interface KNBUploadFileApi ()
@property (nonatomic, copy) NSString *token;
@property (nonatomic, strong) UIImage *image;
@end

@implementation KNBUploadFileApi

//- (instancetype)initWithDictionary:(NSDictionary *)dic {
//    KNBRecorderType type = [dic[KNBPublishContentItemType] integerValue];
//    if (type == KNBRecorderPhoto) {
//        self = [self initWithImage:dic[KNBPublishContentItemOriginImage]];
//    }
//    return self;
//}

+ (YTKBatchRequest *)uploadWithArray:(NSArray *)array token:(NSString *)token complete:(KNBUploadCompletionBlock)completeBlock failure:(KNBUploadFailBlock)failureBlock {
    NSMutableArray *apiArray = [NSMutableArray array];

    for (NSDictionary *dic in array) {
//        KNBRecorderType type = [dic[KNBPublishContentItemType] integerValue];
        KNBUploadFileApi *api = [[KNBUploadFileApi alloc] initWithImage:dic[KNBPublishContentItemOriginImage] token:token];
        [apiArray addObject:api];
    }

    YTKBatchRequest *batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:apiArray];
    
    [batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
        NSMutableArray *fileUrls = [NSMutableArray array];
        
        for (KNBUploadFileApi *api in batchRequest.requestArray) {
            if (api.responseJSONObject && api.responseStatusCode == 200) {
                NSString *fileUrl = [api getUploadFileUrl];
                [fileUrls addObject:fileUrl];
            }
        }

        if (completeBlock) {
            completeBlock(fileUrls);
        }
    } failure:^(YTKBatchRequest *batchRequest) {
        NSMutableArray *failRequests = [NSMutableArray array];
        NSMutableArray *successUrls = [NSMutableArray array];

        for (KNBUploadFileApi *api in batchRequest.requestArray) {
            if (api.error) {
                [failRequests addObject:api];
            } else {
                NSString *url = [api getUploadFileUrl];
                [successUrls addObject:url];
            }
        }

        if (failureBlock) {
            failureBlock(failRequests, successUrls);
        }
    }];
    return batchRequest;
}

+ (void)uploadWithRequests:(NSArray *)requests token:(NSString *)token complete:(KNBUploadCompletionBlock)completeBlock failure:(KNBUploadFailBlock)failureBlock {
    NSMutableArray *muArray = [NSMutableArray array];
    for (id req in requests) {
        if ([req isKindOfClass:[UIImage class]]) {
            KNBUploadFileApi *api = [[KNBUploadFileApi alloc] initWithImage:req token:token];
            [muArray addObject:api];
        } else {
            [muArray addObject:req];
        }
    }

    YTKBatchRequest *batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:muArray];

    [batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
        NSMutableArray *fileUrls = [NSMutableArray array];

        for (KNBUploadFileApi *api in batchRequest.requestArray) {
            if (api.responseJSONObject && api.responseStatusCode == 200) {
                NSString *fileUrl = [api getUploadFileUrl];
                [fileUrls addObject:fileUrl];
            }
        }

        if (completeBlock) {
            completeBlock(fileUrls);
        }
    } failure:^(YTKBatchRequest *batchRequest) {
        NSMutableArray *failRequests = [NSMutableArray array];
        NSMutableArray *successUrls = [NSMutableArray array];

        for (KNBUploadFileApi *api in batchRequest.requestArray) {
            if (api.error) {
                [failRequests addObject:api];
            } else {
                NSString *url = [api getUploadFileUrl];
                if (url) {
                    [successUrls addObject:url];
                }
            }
        }

        if (failureBlock) {
            failureBlock(failRequests, successUrls);
        }
    }];
}

- (instancetype)initWithImage:(UIImage *)image token:(NSString *)token {
    if (self = [super init]) {
        _image = image;
        _token = token;
    }
    return self;
}

- (NSString *)getUploadFileUrl {
    return [self.responseJSONObject objectForKey:@"imgurl"];
}

- (NSString *)requestUrl {
    return [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNB_UploadFile];
}

- (id)requestArgument {
    return @{
        @"img" : [self->_image dealImageMaxFileSize:600],
        @"token" : _token
    };
}

- (AFConstructingBlock)constructingBodyBlock {
    if (_image) {
        return ^(id<AFMultipartFormData> formData) {
            NSData *data = [self->_image dealImageMaxFileSize:600];
            //            NSData *data = UIImageJPEGRepresentation(_image, 0.9);
            NSString *name = @"image.jpg";
            NSString *formKey = @"image";
            NSString *type = @"image/jpeg";
            [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
        };
    }
    return nil;
}

@end
