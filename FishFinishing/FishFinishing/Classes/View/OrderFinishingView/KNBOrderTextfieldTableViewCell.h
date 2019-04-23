//
//  KNBOrderTextfieldTableViewCell.h
//  FishFinishing
//
//  Created by 常立山 on 2019/4/8.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KNBOrderTextFieldType) {
    KNBOrderTextFieldTypeArea = 0,       //面积
    KNBOrderTextFieldTypeCommunity,    //小区
    KNBOrderTextFieldTypeName,           //姓名
    KNBOrderTextFieldTypePhone,          //电话
    KNBOrderTextFieldTypeShopName,    //商家名称
    KNBOrderTextFieldTypeLocation,       //所在位置
    KNBOrderTextFieldTypeShopPhone,    //商家电话
    KNBOrderTextFieldTypeProductName, //产品名称
    KNBOrderTextFieldTypeProductPrice, //产品价格
    KNBOrderTextFieldTypeTitle              //案例标题
};

NS_ASSUME_NONNULL_BEGIN

@interface KNBOrderTextfieldTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *describeTextField;

 /**
  类型
  */
 @property (nonatomic, assign) KNBOrderTextFieldType type;
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
