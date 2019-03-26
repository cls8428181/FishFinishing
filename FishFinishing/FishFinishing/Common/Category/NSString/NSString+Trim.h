//
//  NSString+Trim.h
//  KenuoTraining
//
//  Created by Robert on 16/2/22.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Trim)

/**
 *  去除空格
 *
 *  @return 去除后的字符串
 */
- (NSString *)trimmingWhitespace;

/**
 *  去除空格和空行
 *
 *  @return 去除后的字符串
 */
- (NSString *)trimmingWhitespaceAndNewlines;


/**
 去除控制字符

 @return 去除后字符串
 */
- (NSString *)stringByRemovingControlCharacters;

@end
