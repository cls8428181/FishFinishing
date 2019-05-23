//
//  KNBHomeChatTableViewCell.h
//  FishFinishing
//
//  Created by 常立山 on 2019/4/19.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNBHomeChatModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeChatTableViewCell : UITableViewCell
@property (nonatomic, strong) KNBHomeChatModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;
@end

NS_ASSUME_NONNULL_END
