//
//  KNBMeAboutTableViewCell.h
//  FishFinishing
//
//  Created by apple on 2019/4/19.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KNBMeAboutTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
