//
//  KNBMeTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/29.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBMeTableViewCell.h"

@implementation KNBMeTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBMeTableViewCell";
    KNBMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

+ (CGFloat)cellHeight {
    return 50;
}

@end
