//
//  KNBHomeCategoryTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/26.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeCategoryTableViewCell.h"

@implementation KNBHomeCategoryTableViewCell

#pragma mark - life cycle
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBHomeCategoryTableViewCell";
    KNBHomeCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - private method
+ (CGFloat)cellHeight {
    return 225;
}

@end
