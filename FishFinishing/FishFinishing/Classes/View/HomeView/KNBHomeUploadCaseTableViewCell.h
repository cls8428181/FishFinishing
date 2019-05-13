//
//  KNBHomeUploadCaseTableViewCell.h
//  FishFinishing
//
//  Created by apple on 2019/4/19.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeUploadCaseTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^addCaseBlock)(NSMutableArray *imgsArray);

/**
 图片数组
 */
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITextView *describeText;

/**
 cell 创建
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView dataArray:(NSMutableArray *)heightArray;

/**
 cell 高度
 */
+ (CGFloat)cellHeight:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
