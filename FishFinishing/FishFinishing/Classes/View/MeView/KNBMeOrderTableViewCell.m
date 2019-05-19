//
//  KNBMeOrderTableViewCell.m
//  FishFinishing
//
//  Created by apple on 2019/4/24.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBMeOrderTableViewCell.h"
#import "NSDate+BTAddition.h"

@interface KNBMeOrderTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseLabel;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *markImageView;

@end

@implementation KNBMeOrderTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBMeOrderTableViewCell";
    KNBMeOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

+ (CGFloat)cellHeight {
    return 90;
}

- (void)setModel:(KNBMeOrderModel *)model {
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.portrait_img] placeholderImage:CCPortraitPlaceHolder];
    self.nameLabel.text = model.name;
    self.styleLabel.text = model.decorate_style;
    self.houseLabel.text = model.house_info;
    self.levelLabel.text = model.decorate_grade;
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",[model.province_name containsString:@"市"] ? @"" : model.province_name,model.city_name,model.area_name,model.community];
    self.timeLabel.text = [NSDate transformFromTimestamp:model.created_at];
    
    if ([model.sign isEqualToString:@"0"]) {
        self.markImageView.hidden = YES;
    } else {
        self.markImageView.hidden = NO;
    }
}
@end
