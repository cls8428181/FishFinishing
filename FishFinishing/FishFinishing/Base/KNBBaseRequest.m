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
    return [[jsonDic objectForKey:@"code"] integerValue];
}

- (BOOL)requestSuccess {
    return [self getRequestStatuCode] == 1;
}

- (NSString *)errMessage {
    NSDictionary *jsonDic = self.responseJSONObject;
    return [jsonDic objectForKey:@"msg"];
}

- (NSTimeInterval)requestTimeoutInterval {
    return 15;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (YTKRequestSerializerType)requestSerializerType {
    //添加返回数据的类型支持
    return YTKRequestSerializerTypeJSON;
}

- (id)requestArgument {
    return self.baseMuDic;
}

//baseMuDic
//- (NSDictionary *)appendSecretDic {
//    NSString *jsonStr = [KNBBaseRequest changeJsonStr:self.baseMuDic];
////    NSString *saltKey = [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNB_SecretSalt];
////    NSString *saltStr = [NSString stringWithFormat:@"%@%@%@", saltKey, jsonStr, saltKey];
////    NSString *sign = [saltStr MD5];
////    NSDictionary *dic = @{ @"sign" : sign,
////                           @"jsonStr" : [NSString stringWithFormat:@"train%@", jsonStr] };
//    return dic;
//}

- (NSMutableDictionary *)baseMuDic {
    if (!_baseMuDic) {
        _baseMuDic = [NSMutableDictionary dictionary];
    }
    NSString *userToken = [KNBUserInfo shareInstance].token;
    NSInteger user_id = [[KNBUserInfo shareInstance].userId integerValue];
    NSDictionary *dic = nil;
    if (isNullStr(userToken)) {
        dic = @{
                @"user_id" : @(user_id) ?: @(0),
                };
    } else {
        dic = @{
                @"token" : userToken ?: @"",
                @"user_id" : @(user_id) ?: @(0),
                };
    }

    [_baseMuDic addEntriesFromDictionary:dic];
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
