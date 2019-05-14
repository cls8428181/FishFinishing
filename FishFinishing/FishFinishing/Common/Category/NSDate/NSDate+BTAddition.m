//
//  NSDate+BTAddition.m
//  BEConnector
//
//  Created by andy on 3/18/15.
//  Copyright (c) 2015 NationSky. All rights reserved.
//

#import "NSDate+BTAddition.h"


@implementation NSDate (BTAddition)

+ (NSString *)transformFromTimestamp:(NSString *)timestamp {
    NSString * timeStampString = timestamp;
    NSTimeInterval _interval=[timeStampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd"];
    return [objDateformat stringFromDate: date];
}

- (NSString *)transformToFuzzyDate {
    NSDate *nowDate = [NSDate date];
    NSUInteger timeInterval = [nowDate timeIntervalSinceDate:self];
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //  通过已定义的日历对象，获取某个时间点的NSDateComponents表示，并设置需要表示哪些信息（NSYearCalendarUnit, NSMonthCalendarUnit, NSDayCalendarUnit等）
    NSDateComponents *nowDateComponents = [greCalendar components:NSCalendarUnitEra | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear fromDate:nowDate];

    NSDateComponents *selfDateComponents = [greCalendar components:NSCalendarUnitEra | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear fromDate:self];

    if (timeInterval < 5 * 60) {
        return @"刚刚";
    } else if (timeInterval < 60 * 60) {
        NSString *dateString = [NSString stringWithFormat:@"%@分钟前", @(timeInterval / 60)];
        return dateString;
    } else if (timeInterval < 24 * 60 * 60 && nowDateComponents.day == selfDateComponents.day) {
        NSString *dateString = [NSString stringWithFormat:@"%@小时前", @(timeInterval / (60 * 60))];
        return dateString;
    } else if (nowDateComponents.day != selfDateComponents.day && timeInterval < 24 * 60 * 60) {
        return @"昨天";
    } else if (nowDateComponents.day == (selfDateComponents.day + 1)) {
        return @"昨天";
    } else if (nowDateComponents.weekOfMonth == selfDateComponents.weekOfMonth) {
        NSArray *weekdays = @[ @"temp", @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六" ];
        NSString *dateString = weekdays[selfDateComponents.weekday];
        return dateString;
    } else if ([self timeIntervalSince1970] == 0) {
        return @"";
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        NSString *dateString = [dateFormatter stringFromDate:self];
        return dateString;
    }
}

- (NSString *)promptDateString {
    NSDate *nowDate = [NSDate date];
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //  通过已定义的日历对象，获取某个时间点的NSDateComponents表示，并设置需要表示哪些信息（NSYearCalendarUnit, NSMonthCalendarUnit, NSDayCalendarUnit等）
    NSDateComponents *nowDateComponents = [greCalendar components:NSCalendarUnitEra | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear fromDate:nowDate];

    NSDateComponents *selfDateComponents = [greCalendar components:NSCalendarUnitEra | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear fromDate:self];

    NSDateComponents *weeDateComponents = [[NSDateComponents alloc] init];
    [weeDateComponents setCalendar:[NSCalendar currentCalendar]];
    weeDateComponents.year = selfDateComponents.year;
    weeDateComponents.month = selfDateComponents.month;
    weeDateComponents.day = selfDateComponents.day;
    weeDateComponents.hour = 0;
    weeDateComponents.minute = 0;
    weeDateComponents.second = 0;

    NSDate *weeDate = [[weeDateComponents date] dateByAddingTimeInterval:24 * 60 * 60];

    NSString *lastComponents = nil;
    //    NSString* twoComponent = nil;
    //    NSInteger hour = nowDateComponents.hour;
    //
    //    if (hour < 12) {
    //        twoComponent = @"am";
    //    }
    //    else {
    //        twoComponent = @"pm";
    //        hour = hour - 12;
    //    }
    //判断显示小时
    NSString *newHour = nil;
    if (selfDateComponents.hour < 10) {
        newHour = [NSString stringWithFormat:@"0%@", @(selfDateComponents.hour)];
    } else {
        newHour = [NSString stringWithFormat:@"%@", @(selfDateComponents.hour)];
    }

    //判断显示分钟
    NSString *minute = nil;
    if (selfDateComponents.minute < 10) {
        minute = [NSString stringWithFormat:@"0%@", @(selfDateComponents.minute)];
    } else {
        minute = [NSString stringWithFormat:@"%@", @(selfDateComponents.minute)];
    }

    lastComponents = [NSString stringWithFormat:@"%@:%@", newHour, minute];

    int timeInterval = [nowDate timeIntervalSinceDate:weeDate];
    NSString *dateString = nil;
    if (abs(timeInterval) < (24 * 60 * 60)) {
        if (nowDateComponents.day == selfDateComponents.day) { //同一天判断上下午
            dateString = lastComponents;
        } else { //昨天
            dateString = [NSString stringWithFormat:@"%@ %@", @"yesterday", lastComponents];
        }
    } else if (nowDateComponents.weekOfMonth == selfDateComponents.weekOfMonth) {
        NSArray *weekdays = @[ @"temp", @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六" ];
        NSString *weekdayString = weekdays[selfDateComponents.weekday];
        dateString = [NSString stringWithFormat:@"%@%@", weekdayString, lastComponents];
    } else { //判断是否是同一年
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateString = [NSString stringWithFormat:@"%@ %@", [dateFormatter stringFromDate:self], lastComponents];
    }
    return dateString;
}

+ (NSDate *)dateWithTimestamp:(long long)timestamp;
{
    return [NSDate dateWithTimeIntervalSince1970:timestamp];
}

/**
 *  比较时间（self），获取间隔
 */
- (NSInteger)compareWithDate:(NSDate *)date {
    return fabs([self timeIntervalSinceDate:date]);
}

/**
 *  比较时间（当前时间），获取间隔
 */
+ (NSInteger)compareCurrentTimeWithDate:(NSDate *)date {
    return [[NSDate date] compareWithDate:date];
}

/**
 *  dataStr -> NSDate
 *
 *  @param dateStr  格式（"yyyy-MM-dd HH:mm:ss" or "yyyy-MM-dd HH:mm"）
 */
+ (NSDate *)transformDateStr:(NSString *)dateStr {
    NSString *formate = @"yyyy-MM-dd HH:mm:ss";
    if (dateStr.length != formate.length) {
        formate = @"yyyy-MM-dd HH:mm";
    }
    return [self transformDateStr:dateStr dateFormat:formate];
}

/**
 *  NSDate -> dataStr
 *
 *  @param NSDate
 *  @param dateFormate  exp ("yyyy-MM-dd HH:mm:ss"）
 */

+ (NSString *)transformDate:(NSDate *)date
                 dateFormat:(NSString *)dateFormate {
    NSDateFormatter *forma = [[NSDateFormatter alloc] init];
    [forma setDateFormat:dateFormate];
    NSString *dateString = [forma stringFromDate:date];
    return dateString;
}


/**
 *  dataStr -> NSDate
 *  @param dateFormate  exp ("yyyy-MM-dd HH:mm:ss"）
 */
+ (NSDate *)transformDateStr:(NSString *)dateStr
                  dateFormat:(NSString *)dateFormate {
    NSDateFormatter *forma = [[NSDateFormatter alloc] init];
    [forma setDateFormat:dateFormate];
    NSDate *date = [forma dateFromString:dateStr];
    return date;
}


/**
 *  将字符串时间转换为NSDate
 *
 *  @param dateString 字符串时间 @"yyyy-MM-dd HH:mm:ss"
 *
 *  @return NSDate
 */
+ (NSDate *)getDate:(NSString *)dateString {
    NSDateFormatter *forma = [[NSDateFormatter alloc] init];
    [forma setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [forma dateFromString:dateString];
    return date;
}

/**
 *  将字符串时间转换为NSDate
 *
 *  @param dateTimeString 字符串时间 HH:mm:ss
 *
 *  @return NSDate
 */
+ (NSDate *)getDateTime:(NSString *)dateTimeString {
    NSDateFormatter *forma = [[NSDateFormatter alloc] init];
    [forma setDateFormat:@"HH:mm:ss"];
    //    NSDate *date = [[NSDate alloc] init];
    NSDate *date = [forma dateFromString:dateTimeString];
    return date;
}

/**
 *  判断是否在当前日期的前7天之内
 *
 *  @param dateString 字符串时间@
 *
 *  @return bool值
 */
+ (BOOL)insideOfSevenDaysBeforeWithDateString:(NSString *)dateString{
    NSDate *date = [self getDate:[NSString stringWithFormat:@"%@:00", dateString]];
    NSString *currentDataString = [self getTheCurrentDateString];
    NSDate *currentDate = [self getDate:currentDataString];
    NSTimeInterval compareinterVal = [date timeIntervalSince1970];
    NSTimeInterval currentInterVal = [currentDate timeIntervalSince1970];
    if (compareinterVal > currentInterVal) {
        return NO;
    }
    if ((currentInterVal - compareinterVal) > 7 * 24 * 3600) {
        return NO;
    }
    return YES;
}

/**
 *  判断是否在当前日期的后7天之内
 *
 *  @param dateString 字符串时间@
 *
 *  @return bool值
 */
+ (BOOL)insideOfSevenDaysAfterWithDateString:(NSString *)dateString {
    NSDate *date = [self getDate:dateString];
    NSString *currentDataString = [self getTheCurrentDateString];
    NSDate *currentDate = [self getDate:currentDataString];
    NSTimeInterval compareinterVal = [date timeIntervalSince1970];
    NSTimeInterval currentInterVal = [currentDate timeIntervalSince1970];
    if (compareinterVal < currentInterVal) {
        return NO;
    }
    if ((compareinterVal - currentInterVal) > 7 * 24 * 3600) {
        return NO;
    }
    return YES;
}

/**
 *  判断是否在此时间之前 比较日期
 *
 *  @param dateStr 字符串时间 （被比较的时间 @"yy-MM-dd"
 *
 *  @param dateString 字符串时间 (比较的时间) @"yy-MM-dd"
 *
 *  @return bool值
 */
+ (BOOL)compareIsBeforeTheDate:(NSString *)dateStr withDateString:(NSString *)dateString {
    NSDate *date = [self getDate:[NSString stringWithFormat:@"%@ 00:00:00", dateString]];
    NSDate *currentDate = [self getDate:[NSString stringWithFormat:@"%@ 00:00:00", dateStr]];
    NSTimeInterval compareinterVal = [date timeIntervalSince1970];
    NSTimeInterval currentInterVal = [currentDate timeIntervalSince1970];
    if (compareinterVal <= currentInterVal) {
        return YES;
    } else {
        return NO;
    }
}
/**
 *  判断是否在此时间之前 比较日期和时间
 *
 *  @param dateStr 字符串时间 （被比较的时间 @"yy-MM-dd hh:mm"
 *
 *  @param dateString 字符串时间 (比较的时间) @"yy-MM-dd hh:mm"
 *
 *  @return bool值
 */
+ (BOOL)compareIsBeforeTheTime:(NSString *)TimeStr withTimeString:(NSString *)TimeString {
    NSDate *date = [self getDate:[NSString stringWithFormat:@"%@:00", TimeString]];
    NSDate *currentDate = [self getDate:[NSString stringWithFormat:@"%@:00", TimeStr]];
    NSTimeInterval compareinterVal = [date timeIntervalSince1970];
    NSTimeInterval currentInterVal = [currentDate timeIntervalSince1970];
    if (compareinterVal <= currentInterVal) {
        return YES;
    } else {
        return NO;
    }
}


/**
 *  判断是否在当前时间之前
 *
 *  @param dateString 字符串时间
 *
 *  @return bool值
 */
+ (BOOL)compareIsBeforeTheCurrentDateWithDateString:(NSString *)dateString {
    NSDate *date = [self getDate:dateString];
    NSString *currentDataString = [self getTheCurrentDateString];
    NSDate *currentDate = [self getDate:[NSString stringWithFormat:@"%@", currentDataString]];
    NSTimeInterval compareinterVal = [date timeIntervalSince1970];
    NSTimeInterval currentInterVal = [currentDate timeIntervalSince1970];
    if (compareinterVal < currentInterVal) {
        return YES;
    } else {
        return NO;
    }
}


+ (BOOL)compareIsBeforeTheCurrentDateWithDateString2:(NSString *)dateString {
    NSDate *date = [self getDate:[NSString stringWithFormat:@"%@ 00:00:00", dateString]];
    NSString *currentDataString = [self getTheCurrentDateyyyy_MM_ddFormat];
    NSDate *currentDate = [self getDate:[NSString stringWithFormat:@"%@ 00:00:00", currentDataString]];
    NSTimeInterval compareinterVal = [date timeIntervalSince1970];
    NSTimeInterval currentInterVal = [currentDate timeIntervalSince1970];
    if (compareinterVal < currentInterVal) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *)getTheCurrentDateString {
    return [self getTheDateStringWithDate:[NSDate date]];
}

+ (NSString *)getTheCurrentDateSimpleFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}

+ (NSString *)getTheDateStringWithDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSString *)getTheDateStringWithDate:(NSString *)timeStr format:(NSString *)format {
    NSTimeInterval time=[timeStr doubleValue];
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:format];//@"MM月dd号"
    NSString *dateString = [dateFormatter stringFromDate:detailDate];
    return dateString;
}

+ (NSString *)getTheCurrentDateyyyy_MM_ddFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}

+ (NSArray *)getMonthToTheMonth:(NSDate *)date OfTheMonth:(NSInteger)month {
    NSMutableArray *muDataArray = [NSMutableArray array];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    for (NSInteger i = month - 1; i >= 0; i--) {
        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
        [adcomps setYear:0];
        [adcomps setMonth:-i];
        [adcomps setDay:0];
        NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
        NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
        [dateformat setDateFormat:@"yyyy-MM"];
        NSString *dateString = [dateformat stringFromDate:newdate];
        [muDataArray addObject:dateString];
    }
    return muDataArray;
}

+ (NSArray *)getMonthFromTheMonth:(NSDate *)date OfTheMonth:(NSInteger)month {
    NSMutableArray *muDataArray = [NSMutableArray array];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    for (NSInteger i = month - 1; i >= 0; i--) {
        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
        [adcomps setYear:0];
        [adcomps setMonth:+i];
        [adcomps setDay:0];
        NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
        NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
        [dateformat setDateFormat:@"yyyy-MM"];
        NSString *dateString = [dateformat stringFromDate:newdate];
        [muDataArray addObject:dateString];
    }
    return muDataArray;
}

+ (NSArray *)getDateToTheDate:(NSDate *)date OfTheDate:(NSInteger)numDate {
    NSMutableArray *muDataArray = [NSMutableArray array];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    for (NSInteger i = numDate - 1; i >= 0; i--) {
        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
        [adcomps setYear:0];
        [adcomps setMonth:0];
        [adcomps setDay:-i];
        NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
        NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
        [dateformat setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [dateformat stringFromDate:newdate];
        [muDataArray addObject:dateString];
    }
    return muDataArray;
}

+ (NSArray *)getDateFromTheDate:(NSDate *)date OfTheDate:(NSInteger)numDate {
    NSMutableArray *muDataArray = [NSMutableArray array];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    for (NSInteger i = numDate - 1; i >= 0; i--) {
        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
        [adcomps setYear:0];
        [adcomps setMonth:0];
        [adcomps setDay:+i];
        NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
        NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
        [dateformat setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [dateformat stringFromDate:newdate];
        [muDataArray addObject:dateString];
    }
    return muDataArray;
}

+ (NSString *)stringWithTimestamp:(long long)timestamp {
    NSString *time = [NSString stringWithFormat:@"%lld", timestamp];
    if (time.length > 11) {
        time = [time substringToIndex:10];
        timestamp = [time doubleValue];
    }
    NSDate *date = [self dateWithTimestamp:timestamp];
    NSString *str = [self getTheDateStringWithDate:date];
    return str;
}


+ (NSString *)changeToTimeString:(int)totalSeconds {
    int seconds = totalSeconds % 60;
    int minutes = totalSeconds / 60;
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

+ (NSString *)getResidualTime:(NSString *)time {
    NSDate *date = [self getDate:time];
    long long timeInterval = [date timeIntervalSinceDate:[NSDate date]];
    if (timeInterval <= 0) {
        return @"0天";
    }
    double hour = (timeInterval % (3600 * 24)) / 3600;
    double day = timeInterval / (24 * 3600);
    NSString *timeStr = @"";
    if (day > 0) {
        timeStr = [timeStr stringByAppendingString:[NSString stringWithFormat:@"%.0f天", day]];
    }
    if (hour > 0) {
        timeStr = [timeStr stringByAppendingString:[NSString stringWithFormat:@"%.0f时", hour]];
    }

    return timeStr;
}

+ (CGFloat)changeToFloatTime:(NSString *)time {
    CGFloat floatTime = 0.0;

    NSArray *array = [time componentsSeparatedByString:@":"];

    if (array) {
        floatTime = [array[0] intValue] * 60 * 60 + [array[1] intValue] * 60 + [array[2] intValue];
    }
    return floatTime;
}

+ (CGFloat)changeToFloatMinute:(NSString *)time {
    CGFloat floatMinutes = 0.0;

    NSArray *array = [time componentsSeparatedByString:@":"];

    if (array) {
        floatMinutes = [array[0] intValue] * 60 + [array[1] intValue];
    }
    return floatMinutes;
}


/**
 *  判断时间是否在当前时间的后n小时之外
 *
 *  @param dateStr 格式（"yyyy-MM-dd HH:mm:ss" or "yyyy-MM-dd HH:mm"
 *  @param hours 小时
 */
+ (BOOL)judgeDateStr:(NSString *)dateStr outHours:(double)hours {
    NSDate *date = [self transformDateStr:dateStr];
    NSInteger timeInterval = [date timeIntervalSinceDate:[NSDate date]];
    if (timeInterval < (hours * 3600)) {
        return NO;
    }
    return YES;
}


/**
 *  把时间转换为 时:分:秒
 *
 *  @param totalSeconds 秒
 *
 *  @return 时:分:秒
 */
+ (NSString *)totalSecondsTransformFuzzyStr:(int)totalSeconds {
    NSString *seconds = [self totalSecondsTransformSeconds:totalSeconds];
    NSString *minutes = [self totalSecondsTransformMinutes:totalSeconds];
    NSString *hours = [self totalSecondsTransformHours:totalSeconds];
    return [NSString stringWithFormat:@"%@:%@:%@", hours, minutes, seconds];
}

+ (NSString *)totalSecondsTransform:(int)totalSeconds {
    NSString *seconds = [self totalSecondsTransformSeconds:totalSeconds];
    NSString *minutes = [self totalSecondsTransformMinutes:totalSeconds];
    NSString *hours = [self totalSecondsTransformHours:totalSeconds];
    return [NSString stringWithFormat:@"%@ 时 %@ 分 %@ 秒", hours, minutes, seconds];
}

+ (NSString *)totalSecondsTransStr:(int)totalSecond {
    NSString *dateStr = [NSDate totalSecondsTransformFuzzyStr:totalSecond];
    if (totalSecond > 86400) {
        dateStr = [NSDate totalSecondsTransformDaysStr:totalSecond];
    }
    return dateStr;
}


/**
 *  把时间转换为 天:时:分:秒
 *
 *  @param totalSeconds 秒
 *
 *  @return 天 时:分:秒
 */
+ (NSString *)totalSecondsTransformDaysStr:(int)totalSeconds {
    NSString *seconds = [self totalSecondsTransformSeconds:totalSeconds];
    NSString *minutes = [self totalSecondsTransformMinutes:totalSeconds];
    NSString *hours = [self totalSecondsTransformHours:totalSeconds];
    NSString *days = [self totalSecondsTransformDays:totalSeconds];
    return [NSString stringWithFormat:@"%@天 %@:%@:%@", days, hours, minutes, seconds];
}

+ (NSString *)totalSecondsTransformDays:(int)totalSeconds {
    int days = totalSeconds / 86400;
    return [NSString stringWithFormat:@"%d", days];
}


+ (NSString *)totalSecondsTransformHours:(int)totalSeconds {
    int hours = (totalSeconds / 3600) % 24;
    return [NSString stringWithFormat:@"%02d", hours];
}

+ (NSString *)totalSecondsTransformMinutes:(int)totalSeconds {
    int minutes = (totalSeconds / 60) % 60;
    return [NSString stringWithFormat:@"%02d", minutes];
}

+ (NSString *)totalSecondsTransformSeconds:(int)totalSeconds {
    int seconds = totalSeconds % 60;
    return [NSString stringWithFormat:@"%02d", seconds];
}

//判断时间是否过期 // 格式"yyyy-MM-dd"
+ (BOOL)isOverdueDateStr:(NSString *)dateStr {
    NSDateFormatter *forma = [[NSDateFormatter alloc] init];
    [forma setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [forma dateFromString:dateStr];
    NSString *currentDataString = [self getTheCurrentDateString];
    NSDate *currentDate = [self getDate:[NSString stringWithFormat:@"%@", currentDataString]];
    NSTimeInterval compareinterVal = [date timeIntervalSince1970];
    NSTimeInterval currentInterVal = [currentDate timeIntervalSince1970];
    if (compareinterVal < currentInterVal) {
        return YES;
    } else {
        return NO;
    }
}
+ (NSString *)getCurrentWithAgo:(NSInteger)days {
    NSDate *date = [NSDate date];
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24 * 60 * 60 * days sinceDate:date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:lastDay];
}

+ (BOOL)isLastDay:(NSString *)timeStr {
    NSString *lastDayStr = [self getCurrentWithAgo:1];
    NSTimeInterval time=[timeStr doubleValue];//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    
    if ([lastDayStr isEqualToString:currentDateStr]) {
        return YES;
    } else {
        return NO;
    }
}

+ (bool) isMonthWithTime:(NSString *)time andTime1:(NSString *)time1{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:time];
    NSDate *date1 = [dateFormatter dateFromString:time1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unit = NSCalendarUnitMonth;
    
    NSDateComponents *compos = [calendar components:unit fromDate:date];
    NSDateComponents *compos1 = [calendar components:unit fromDate:date1];
    return compos.month == compos1.month;
}

+(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
    
}


+ (NSString *)timeStr:(long long)timestamp
{
    // 创建日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 获取当前时间
    NSDate *currentDate = [NSDate date];
    // 获取当前时间的年、月、日。利用日历
    NSDateComponents *components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    // 获取消息发送时间的年、月、日
    NSDate *msgDate = [NSDate dateWithTimeIntervalSince1970:timestamp / 1000.0];
    components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay fromDate:msgDate];
    
    // 进行判断
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
        //昨天以前
    dateFmt.dateFormat = @"yyyy-MM-dd";

    // 返回处理后的结果
    return [dateFmt stringFromDate:msgDate];
}

+ (NSInteger)getDifferenceByDate:(NSString *)date {
    
    //获得当前时间
    
    NSDate *now = [NSDate date];
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式
    
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    
    NSDate *newDate = [dateFormatter dateFromString:date];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    unsigned int unitFlags = NSCalendarUnitDay;
    
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:now  toDate:newDate  options:0];
    
    return [comps day];
    
//下面这种方法从00:00:00开始计算
//
//#pragma clang diagnostic push
//
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//
//    NSCalendar *gregorian = [[NSCalendar alloc]
//
//                             initWithCalendarIdentifier:NSGregorianCalendar];
//
//    [gregorian setFirstWeekday:2];
//
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//
//    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
//
//    NSDate *fromDate;
//
//    NSDate *toDate;
//
//    [gregorian rangeOfUnit:NSDayCalendarUnit startDate:&fromDate interval:NULL forDate:[dateFormatter dateFromString:date]];
//
//    [gregorian rangeOfUnit:NSDayCalendarUnit startDate:&toDate interval:NULL forDate:[NSDate date]];
//
//    NSDateComponents *dayComponents = [gregorian components:NSDayCalendarUnit fromDate:fromDate toDate:toDate options:0];
//
//#pragma clang diagnostic pop
//
//
//
//    return [dayComponents day];
//
}

@end
