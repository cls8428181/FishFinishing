//
//  KNBDataEmptySet.h
//  KenuoTraining
//
//  Created by Robert on 16/4/7.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KNBDataEmptySet : UIView

@property (nonatomic, strong) NSString *noticeString;

@property (nonatomic, strong) UIImage *noticeImage;

@property (nonatomic, strong) NSString *subNoticeString;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) BOOL viewHidden;


- (void)setDataCount:(NSInteger)count;

/**
 设置提示文字的颜色
 */
- (void)setNoticeStringColor:(UIColor *)color;

/**
 设置提示文字距离顶部的距离
 */
- (void)setNoticeStringTop:(CGFloat)top;

@end
