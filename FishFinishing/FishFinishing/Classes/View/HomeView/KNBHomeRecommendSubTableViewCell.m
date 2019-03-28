//
//  KNBHomeRecommendSubTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/27.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeRecommendSubTableViewCell.h"

@implementation KNBHomeRecommendSubTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBHomeRecommendSubTableViewCell";
    KNBHomeRecommendSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

+ (CGFloat)cellHeight {
    return 130;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
