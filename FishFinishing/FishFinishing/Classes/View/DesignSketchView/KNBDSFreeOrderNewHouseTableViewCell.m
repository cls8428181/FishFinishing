//
//  KNBDSFreeOrderNewHouseTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/1.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBDSFreeOrderNewHouseTableViewCell.h"

@implementation KNBDSFreeOrderNewHouseTableViewCell

#pragma mark - life cycle
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBDSFreeOrderNewHouseTableViewCell";
    KNBDSFreeOrderNewHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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

#pragma mark - event respon

- (IBAction)newHouseButtonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.isSelected;
}
- (IBAction)oldHouseButtonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.isSelected;
}

@end
