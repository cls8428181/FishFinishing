//
//  KNBChoiceTableViewCell.h
//  FishFinishing
//
//  Created by apple on 2019/4/16.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, KNBChoiceType) {
    KNBChoiceTypeBedroom = 0,         //卧室
    KNBChoiceTypeLivingroom,            //客厅
    KNBChoiceTypeDiningroom,           //餐厅
    KNBChoiceTypeKitchen,                //厨房
    KNBChoiceTypeToilet,                  //卫生间
};

NS_ASSUME_NONNULL_BEGIN

@interface KNBChoiceTableViewCell : UITableViewCell

/**
 数字
 */
@property (weak, nonatomic) IBOutlet UITextField *numTextField;

/**
 类型
 */
@property (nonatomic, assign) KNBChoiceType type;

/**
 加好按钮的回调
 */
@property (nonatomic, copy) void(^addButtonBlock)(void);

/**
 减号按钮的回调
 */
@property (nonatomic, copy) void(^subButtonBlock)(void);

/**
 cell 创建
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 cell 高度
 */
+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
