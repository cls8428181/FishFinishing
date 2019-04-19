//
//  KNBMeAboutTableViewCell.m
//  FishFinishing
//
//  Created by apple on 2019/4/19.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBMeAboutTableViewCell.h"

@implementation KNBMeAboutTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBMeAboutTableViewCell";
    KNBMeAboutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

+ (CGFloat)cellHeight {
    return 84;
}

@end
