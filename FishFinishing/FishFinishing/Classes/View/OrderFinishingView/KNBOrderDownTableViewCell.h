//
//  KNBOrderDownTableViewCell.h
//  FishFinishing
//
//  Created by 常立山 on 2019/4/8.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, KNBOrderDownType) {
    KNBOrderDownTypeServer = 0,       //服务类型
    KNBOrderDownTypeHouse,            //户型
    KNBOrderDownTypeStyle,            //装修风格
    KNBOrderDownTypeLevel,            //装修档次
    KNBOrderDownTypeRecruitment,      //入驻类型
    KNBOrderDownTypeDomain,           //擅长领域
    KNBOrderDownTypeShowPrice         //展示价格
    
};

NS_ASSUME_NONNULL_BEGIN

@interface KNBOrderDownTableViewCell : UITableViewCell

@property (nonatomic, assign) KNBOrderDownType type;
@property (nonatomic, copy) void (^describeButtonBlock)(KNBOrderDownType type);

/**
 内容按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *describeButton;
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
