//
//  KNBHomeCompanyIntroTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/3.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeCompanyIntroTableViewCell.h"

@interface KNBHomeCompanyIntroTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation KNBHomeCompanyIntroTableViewCell

#pragma mark - life cycle
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBHomeCompanyIntroTableViewCell";
    KNBHomeCompanyIntroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - private method
+ (CGFloat)cellHeight {
    return 185;
}

- (void)setModel:(KNBHomeServiceModel *)model {
    self.contentLabel.text = model.remark;
}
@end
