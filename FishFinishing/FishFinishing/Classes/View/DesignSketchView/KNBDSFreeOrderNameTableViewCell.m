//
//  KNBDSFreeOrderNameTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/1.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBDSFreeOrderNameTableViewCell.h"

@implementation KNBDSFreeOrderNameTableViewCell

#pragma mark - life cycle
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBDSFreeOrderNameTableViewCell";
    KNBDSFreeOrderNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - private method
+ (CGFloat)cellHeight {
    return 50;
}
@end
