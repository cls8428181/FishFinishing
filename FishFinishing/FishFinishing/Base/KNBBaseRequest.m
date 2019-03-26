//
//  KNBBaseRequest.m
//  KenuoTraining
//
//  Created by Robert on 16/3/12.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "KNBBaseRequest.h"
#import "KNBBaseRequestAccessory.h"
#import "KNBMainConfigModel.h"
#import "NSString+MD5.h"
#import "KNGetUserLoaction.h"

@interface KNBBaseRequest ()

@property (nonatomic, strong) KNBBaseRequestAccessory *accessory;


@end


@implementation KNBBaseRequest

- (instancetype)init {
    if (self = [super init]) {
        [self addAccessory:self.accessory];
    }
    return self;
}

- (NSInteger)getRequestStatuCode {
    NSDictionary *jsonDic = self.responseJSONObject;
    return [[jsonDic objectForKey:@"result"] integerValue];
}

- (BOOL)requestSuccess {
    return [self getRequestStatuCode] == 200;
}

- (NSString *)errMessage {
    NSDictionary *jsonDic = self.responseJSONObject;
    return [jsonDic objectForKey:@"message"];
}

- (NSTimeInterval)requestTimeoutInterval {
    return 15;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (id)requestArgument {
    return self.appendSecretDic;
}

- (NSMutableDictionary *)baseMuDic {
    if (!_baseMuDic) {
        _baseMuDic = [NSMutableDictionary dictionary];
    }
//    NSString *userToken = [KNBUserInfo shareInstance].userToken;
//    NSString *user_id = [KNBUserInfo shareInstance].userId;
//    NSDictionary *dic = @{ @"user_token" : userToken ?: @"",
//                           @"nowu_id" : user_id ?: @"",
//                           @"client" : @"ios",
//                           @"company_id" : @([KNBUserInfo shareInstance].roleFranchisee_id),
//                           @"ver_num" : KNB_APP_VERSION };
//    [_baseMuDic addEntriesFromDictionary:dic];
    return _baseMuDic;
}

+ (NSString *)changeJsonStr:(NSDictionary *)dic {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStr;
}

#pragma mark - Getter&Setter
- (KNBBaseRequestAccessory *)accessory {
    if (!_accessory) {
        _accessory = [[KNBBaseRequestAccessory alloc] init];
    }
    return _accessory;
}

- (NSString *)hudString {
    return _hudString ? _hudString : nil;
}

//+ (NSString *)requestArticleId:(NSString *)articleId {
//    if (articleId.length == 0 || [articleId isKindOfClass:[NSNull class]]) {
//        return nil;
//    }
//    NSString *contentUrlString = [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNB_ArticleContent];
//    NSString *urlString = [NSString stringWithFormat:@"%@?article_id=%@", contentUrlString, articleId];
//    return urlString;
//}

//- (NSDictionary *)requestArgumentDicWithSecretKey:(NSString *)secretKey moreArgument:(NSDictionary *)moreDic{
//    NSString *userToken = [KNBUserInfo shareInstance].userToken;
//    NSString *user_id = [KNBUserInfo shareInstance].userId;
//    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
//    NSDictionary *dic = @{ @"user_token" : userToken ?: @"",
//                           @"nowu_id" : user_id ?: @"",
//                           @"client" : @"ios",
//                           @"company_id" : @([KNBUserInfo shareInstance].roleFranchisee_id),
//                           @"user_id" : @([KNBUserInfo shareInstance].mtmyUserId),
//                           @"ver_num" : KNB_APP_VERSION };
//    [muDic addEntriesFromDictionary:dic];
//    [muDic addEntriesFromDictionary:moreDic];
//
//    NSString *jsonStr = [KNBBaseRequest changeJsonStr:muDic];
//    NSString *saltKey = secretKey;
//    NSString *saltStr = [NSString stringWithFormat:@"%@%@%@", saltKey, jsonStr, saltKey];
//    NSString *sign = [saltStr MD5];
//    NSDictionary *signdic = @{ @"sign" : sign,
//                           @"jsonStr" : [NSString stringWithFormat:@"market%@", jsonStr] };
//    return signdic;
//}
#pragma mark -- 数据缓存
//根据url和参数创建路径
- (NSString *)cacheFilePath{
    NSString *cacheFileName = [[NSString stringWithFormat:@"%@",self.requestUrl] MD5];
    NSString *path = [self cacheBasePath];
    path = [path stringByAppendingPathComponent:cacheFileName];
    return path;
}

//创建根路径 -文件夹
- (NSString *)cacheBasePath {
    //放入cash文件夹下,为了让手机自动清理缓存文件,避免产生垃圾
    NSString *pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [pathOfLibrary stringByAppendingPathComponent:@"KNBServiceApiCache"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    NSError *error = nil;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    } else {
        if (!isDir) {
            NSError *error = nil;
            [fileManager removeItemAtPath:path error:&error];
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        }
    }
    return path;
}


@end
