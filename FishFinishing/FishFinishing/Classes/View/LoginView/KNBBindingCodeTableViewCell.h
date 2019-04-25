//
//  KNBBindingCodeTableViewCell.h
//  FishFinishing
//
//  Created by apple on 2019/4/25.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^GetVerifyCodeBlock)(void);

@interface KNBBindingCodeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

/**
 获取验证码的回调
 */
@property (nonatomic, copy) GetVerifyCodeBlock getVerifyCodeBlock;

/**
 cell 创建
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 cell 高度
 */
+ (CGFloat)cellHeight;

/**
 定时器开关
 
 @param startTimer YES开器
 */
- (void)timerControll:(BOOL)startTimer;

@end

NS_ASSUME_NONNULL_END
