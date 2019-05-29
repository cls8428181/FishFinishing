//
//  KNBMeOrderOtherTableViewCell.m
//  FishFinishing
//
//  Created by apple on 2019/5/9.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBMeOrderOtherTableViewCell.h"
#import "NSDate+BTAddition.h"

@interface KNBMeOrderOtherTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *markImageView;

@end

@implementation KNBMeOrderOtherTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBMeOrderOtherTableViewCell";
    KNBMeOrderOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
    self.houseLabel.text = !isNullStr(model.decorate_cat) ? model.decorate_cat : @"用户未提供";
    self.areaLabel.text = [NSString stringWithFormat:@"%@m²",!isNullStr(model.area_info) ? model.area_info : @"用户未提供"];
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@",[model.province_name containsString:@"市"] ? @"" : model.province_name,model.city_name,model.area_name,model.community];
    self.addressLabel.text = !isNullStr(address) ? address: @"用户未提供";
    self.timeLabel.text = [NSDate transformFromTimestamp:model.created_at];
    
    if ([model.sign isEqualToString:@"0"]) {
        self.markImageView.hidden = YES;
    } else {
        self.markImageView.hidden = NO;
    }
    
}

@end
