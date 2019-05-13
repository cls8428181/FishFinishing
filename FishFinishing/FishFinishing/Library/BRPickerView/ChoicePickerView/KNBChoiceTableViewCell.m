//
//  KNBChoiceTableViewCell.m
//  FishFinishing
//
//  Created by apple on 2019/4/16.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBChoiceTableViewCell.h"

@interface KNBChoiceTableViewCell ()
@property (nonatomic, assign) NSInteger num;

@end

@implementation KNBChoiceTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView title:(nonnull NSString *)title {
    static NSString *ID = @"KNBChoiceTableViewCell";
    KNBChoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.num = 0;
    cell.titleLabel.text = title;
    return cell;
}

+ (CGFloat)cellHeight {
    return 50;
}
@end
