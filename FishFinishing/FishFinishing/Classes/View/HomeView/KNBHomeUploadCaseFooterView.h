//
//  KNBHomeUploadCaseFooterView.h
//  FishFinishing
//
//  Created by apple on 2019/5/7.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeUploadCaseFooterView : UIView

@property (nonatomic, copy) void (^addCaseBlock)(NSMutableArray *imgsArray);

@property (nonatomic, strong) UILabel *titleLabel;

/**
 已经上传了的图片数量
 */
@property (nonatomic, assign) NSInteger imgsCount;

/**
 图片数组
 */
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) CCTextView *describeText;

/**
 cell 高度
 */
+ (CGFloat)cellHeight:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
