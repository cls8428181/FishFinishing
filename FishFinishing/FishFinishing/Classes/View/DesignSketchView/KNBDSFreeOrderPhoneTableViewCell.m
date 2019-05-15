//
//  KNBDSFreeOrderPhoneTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/1.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBDSFreeOrderPhoneTableViewCell.h"

@implementation KNBDSFreeOrderPhoneTableViewCell

#pragma mark - life cycle
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBDSFreeOrderPhoneTableViewCell";
    KNBDSFreeOrderPhoneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.detailTextField setValue:[UIColor colorWithHex:0x808080] forKeyPath:@"_placeholderLabel.textColor"];
}

@end
