//
//  KNBHomeChatTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/19.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeChatTableViewCell.h"
#import "NSDate+BTAddition.h"

@interface KNBHomeChatTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation KNBHomeChatTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBHomeChatTableViewCell";
    KNBHomeChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

+ (CGFloat)cellHeight {
    return 290;
}

- (void)setModel:(KNBHomeChatModel *)model {
    _model = model;
    self.timeLabel.text = [NSDate transformFromTimestamp:model.created_at];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:CCPortraitPlaceHolder];
    self.titleLabel.text = model.title;
}

@end
