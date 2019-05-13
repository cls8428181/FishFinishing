//
//  KNBHomeExperienceHeaderView.m
//  FishFinishing
//
//  Created by apple on 2019/5/5.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeExperienceHeaderView.h"
#import "NSDate+BTAddition.h"

@interface KNBHomeExperienceHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;
@end

@implementation KNBHomeExperienceHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setBannerModel:(KNBHomeBannerModel *)bannerModel {
    [self.adImageView sd_setImageWithURL:[NSURL URLWithString:bannerModel.img]];
}

- (void)setServiceModel:(KNBHomeServiceModel *)serviceModel {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:serviceModel.logo]];
    self.nameLabel.text = serviceModel.name;
    self.phoneLabel.text = serviceModel.telephone;
    NSInteger due_time = [NSDate getDifferenceByDate:[NSDate transformFromTimestamp:serviceModel.due_time]];
    if (due_time < 0) {
        self.timeLabel.text = @"您的入驻时间已经结束";
    } else {
        self.timeLabel.text = [NSString stringWithFormat:@"入驻时间将于%ld后到期",due_time];
    }
}

@end
