//
//  KNBUtilExtend.h
//  KenuoTraining
//
//  Created by Robert on 16/2/22.
//  Copyright © 2016年 Robert. All rights reserved.
//

#ifndef KNBUtilExtend_h
#define KNBUtilExtend_h

//通知相关
CG_INLINE void KNB_ADD_NOTIFICATION(NSString *name, id target, SEL action, id object) {
    [[NSNotificationCenter defaultCenter] addObserver:target selector:action name:name object:object];
}

CG_INLINE void KNB_REMOVE_NOTIFICATION(NSString *name, id target, id object) {
    [[NSNotificationCenter defaultCenter] removeObserver:target name:name object:object];
}

CG_INLINE void KNB_POST_NOTIFICATION(NSString *name, id object, NSDictionary *userInfo) {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object userInfo:userInfo];
}

CG_INLINE BOOL isNullStr(NSString *str) {
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    NSCharacterSet *whiltSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *textStr = [str stringByTrimmingCharactersInSet:whiltSpace];
    if (textStr == nil ||
        [textStr isEqualToString:@""] ||
        textStr.length == 0 ||
        [str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}

//多线程相关
CG_INLINE void KNB_PerformAsynchronous(void (^block)(void)) {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, block);
}

CG_INLINE void KNB_PerformOnMainThread(void (^block)(void)) {
    dispatch_async(dispatch_get_main_queue(), block);
}

typedef NS_ENUM(NSUInteger, KNBRecorderType) {
    KNBRecorderPhoto = 2, //照片
    KNBRecorderVideo      //视频
};

/*
 * 支付相关
 */
typedef NS_ENUM(NSUInteger, KNBGetChargeType) {
    KNBGetChargeTypeRecruitment,       //商家入驻
    KNBGetChargeTypeBuyService         //购买服务
};

typedef NS_ENUM(NSInteger, KNBOrderPayType) {
    KNBOrderPayTypeNone = -1,
    KNBOrderPayTypeWX,     //微信
    KNBOrderPayTypeAlipay, //支付宝
};

typedef NS_ENUM(NSInteger, KNBOrderPayStatus) {
    KNBOrderPayStatusSuccess, //支付成功
    KNBOrderPayStatusCancel,  //取消支付
    KNBOrderPayStatusFail     //支付失败
};

CG_INLINE NSURL *resourceSaveDirectory(NSString *userName, KNBRecorderType type) {
    NSString *dirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:userName];

    BOOL isDir;

    if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDir] || !isDir) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    if (type == KNBRecorderVideo) {
        dirPath = [dirPath stringByAppendingPathComponent:@"Video"];
    } else if (type == KNBRecorderPhoto) {
        dirPath = [dirPath stringByAppendingPathComponent:@"Photo"];
    }

    if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDir] || !isDir) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    NSURL *dirUrl = [NSURL fileURLWithPath:dirPath];
    ;
    return dirUrl;
}


CG_INLINE NSURL *resourceAbsolutePath(NSString *userName, NSString *resourceName, KNBRecorderType type) {
    NSURL *dirUrl = resourceSaveDirectory(userName, type);

    NSURL *fileUrl = nil;

    if (type == KNBRecorderVideo) {
        fileUrl = [[dirUrl URLByAppendingPathComponent:resourceName] URLByAppendingPathExtension:@"mp4"];
    } else if (type == KNBRecorderPhoto) {
        fileUrl = [[dirUrl URLByAppendingPathComponent:resourceName] URLByAppendingPathExtension:@"jpg"];
    }
    return fileUrl;
}
CG_INLINE BOOL isNullArray(NSArray *array) {
    if (array != nil && ![array isKindOfClass:[NSNull class]] && array.count != 0) {
        return NO;
    }
    return YES;
}
CG_INLINE void removeResources(NSString *userName) {
    NSString *dirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:userName];

    NSString *videoDirPath = [dirPath stringByAppendingPathComponent:@"Video"];
    NSString *photoDirPath = [dirPath stringByAppendingPathComponent:@"Photo"];

    [[NSFileManager defaultManager] removeItemAtPath:videoDirPath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:photoDirPath error:nil];
}

CG_INLINE NSString *combineResourceUrl(NSString *url) {
    //    NSString *complteString = [NSString stringWithFormat:@"%@%@", [[KNBMainConfigModel shareInstance] getRequestUrlWithKey:KNBResourceUrl], url];
    //    return complteString;
    return url;
}

CG_INLINE BOOL isPhoneNumber(NSString *number) {
    //* 普通
    NSString *MB = @"^1[3-9]\\d{9}$";
    //* 移动
    NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    //* 联通
    NSString *CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    //* 电信
    NSString *CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";


    NSPredicate *regextestmb = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MB];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if (([regextestmb evaluateWithObject:number] == YES) ||
        ([regextestcm evaluateWithObject:number] == YES) ||
        ([regextestct evaluateWithObject:number] == YES) ||
        ([regextestcu evaluateWithObject:number] == YES)) {
        return YES;
    } else {
        return NO;
    }
}

CG_INLINE BOOL isIDCardNumber(NSString *value) {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    int length = 0;

    if (!value) {
        return NO;
    } else {
        length = (int)value.length;

        if (length != 15 && length != 18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray = @[ @"11", @"12", @"13", @"14", @"15", @"21", @"22", @"23", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"41", @"42", @"43", @"44", @"45", @"46", @"50", @"51", @"52", @"53", @"54", @"61", @"62", @"63", @"64", @"65", @"71", @"81", @"82", @"91" ];

    NSString *valueStart2 = [value substringToIndex:2];

    BOOL areaFlag = NO;

    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag = YES;
            break;
        }
    }
    if (!areaFlag) {
        return NO;
    }
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    int year = 0;
    switch (length) {
        case 15: {
            year = [value substringWithRange:NSMakeRange(6, 2)].intValue + 1900;
            if (year % 4 == 0 || (year % 100 == 0 && year % 4 == 0)) {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil]; //测试出生日期的合法性
            } else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil]; //测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];

            if (numberofMatch > 0) {
                return YES;
            } else {
                return NO;
            }
        }
        case 18:
            year = [value substringWithRange:NSMakeRange(6, 4)].intValue;
            if (year % 4 == 0 || (year % 100 == 0 && year % 4 == 0)) {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}((19[0-9]{2})|(2[0-9]{3}))((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil]; //测试出生日期的合法性
            } else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}((19[0-9]{2})|(2[0-9]{3}))((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil]; //测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];

            if (numberofMatch > 0) {
                int S = ([value substringWithRange:NSMakeRange(0, 1)].intValue + [value substringWithRange:NSMakeRange(10, 1)].intValue) * 7 + ([value substringWithRange:NSMakeRange(1, 1)].intValue + [value substringWithRange:NSMakeRange(11, 1)].intValue) * 9 + ([value substringWithRange:NSMakeRange(2, 1)].intValue + [value substringWithRange:NSMakeRange(12, 1)].intValue) * 10 + ([value substringWithRange:NSMakeRange(3, 1)].intValue + [value substringWithRange:NSMakeRange(13, 1)].intValue) * 5 + ([value substringWithRange:NSMakeRange(4, 1)].intValue + [value substringWithRange:NSMakeRange(14, 1)].intValue) * 8 + ([value substringWithRange:NSMakeRange(5, 1)].intValue + [value substringWithRange:NSMakeRange(15, 1)].intValue) * 4 + ([value substringWithRange:NSMakeRange(6, 1)].intValue + [value substringWithRange:NSMakeRange(16, 1)].intValue) * 2 + [value substringWithRange:NSMakeRange(7, 1)].intValue * 1 + [value substringWithRange:NSMakeRange(8, 1)].intValue * 6 + [value substringWithRange:NSMakeRange(9, 1)].intValue * 3;

                int Y = S % 11;

                NSString *M = @"F";

                NSString *JYM = @"10X98765432";

                M = [JYM substringWithRange:NSMakeRange(Y, 1)]; // 判断校验位

                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17, 1)]]) {
                    return YES; // 检测ID的校验位
                } else {
                    return NO;
                }
            } else {
                return NO;
            }
        default:
            return NO;
    }
}

CG_INLINE BOOL isPrice(NSString *text) {
    // 小数点前面最多可输入9位
    NSString *stringRegex = @"(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,9}(([.]\\d{0,2})?)))?";
    NSPredicate *regextPrice = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
    return [regextPrice evaluateWithObject:text];
}
CG_INLINE BOOL isEmail(NSString *value) {
    if (value.length > 0) {
        NSString *numberRegex = @"^[\u4e00-\u9fa5]+$";
        NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
        if ([numberPredicate evaluateWithObject:value]) {
            return NO;
        }
    }
    if (![value containsString:@"@"] || ![value containsString:@"."]) {
        return NO;
    }
    NSInteger index = [value rangeOfString:@"."].location;
    if (value.length - index > 4) {
        return NO;
    }
    NSInteger atIndex = [value rangeOfString:@"@"].location;
    if (atIndex < 6 || atIndex > 18) {
        return NO;
    }
    NSString *numberRegex = @"^[A-Za-z0-9]([A-Za-z0-9]*[_]?[A-Za-z0-9]+)*@([a-z0-9]*[-_]?[a-z0-9]+)+[/.][a-z]{2,3}([/.][a-z]{2})?$";
    NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [numberPredicate evaluateWithObject:value];
    //    NSRegularExpression *regularExpression = [[NSRegularExpression alloc] initWithPattern:@"" options:NSRegularExpressionCaseInsensitive error:nil];
    //    NSUInteger numberofMatch = [regularExpression numberOfMatchesInString:value options:NSMatchingReportProgress range:NSMakeRange(0, value.length)];
    //    return numberofMatch > 0;
}
/**
 获取当月第一天
 
 @param dateFormat 日期格式
 */
CG_INLINE NSString *KNB_CurrentMonthFirstTime(NSString *dateFormat) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (isNullStr(dateFormat)) {
        dateFormat = @"yyyy-MM-dd";
    }
    [formatter setDateFormat:dateFormat];
    NSDate *currentDate = [NSDate date];
    double interval = 0;
    NSDate *firstDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&firstDate interval:&interval forDate:currentDate];
    NSString *firstString = [formatter stringFromDate:firstDate];
    return firstString;
}

/**
 获取当天时间
 
 @param dateFormat 日期格式
 */
CG_INLINE NSString *KNB_CurrentTime(NSString *dateFormat) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (isNullStr(dateFormat)) {
        dateFormat = @"yyyy-MM-dd";
    }
    [formatter setDateFormat:dateFormat];
    return [formatter stringFromDate:[NSDate date]];
}

/**
 获取当前年
 */
CG_INLINE NSString *KNB_CurrentYear() {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    return [formatter stringFromDate:[NSDate date]];
}

/**
 获取当前月
 */
CG_INLINE NSString *KNB_CurrentMonth() {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M"];
    return [formatter stringFromDate:[NSDate date]];
}

CG_INLINE NSString *WebURLEncode(NSString * str)
{
    NSString *charactersToEscape = @"#[]@!$'()*+,;\"<>%{}|^~`";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *encodedUrl = [[str description] stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return encodedUrl;
}

CG_INLINE NSString *WebURLDecodedString(NSString * str)
{
    return [str stringByRemovingPercentEncoding];
}

#endif /* KNBUtilExtend_h */
