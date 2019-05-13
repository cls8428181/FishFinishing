//
//  KNBOrderDownTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/8.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBOrderDownTableViewCell.h"

@interface KNBOrderDownTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation KNBOrderDownTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBOrderDownTableViewCell";
    KNBOrderDownTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

+ (CGFloat)cellHeight {
    return 50;
}

- (void)setButtonTitle:(NSString *)title {
    [self.describeButton setTitle:title forState:UIControlStateNormal];
    [self.describeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.describeButton.imageView.bounds.size.width - 15, 0, self.describeButton.imageView.bounds.size.width + 15)];
    [self.describeButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.describeButton.titleLabel.bounds.size.width - 5, 0, -self.describeButton.titleLabel.bounds.size.width + 5)];
}

- (void)setType:(KNBOrderDownType)type {
    _type = type;
    self.iconImageView.hidden = YES;
    if (type == KNBOrderDownTypeServer) {
        self.titleLabel.text = @"服务类型:";
        [self.describeButton setTitle:@"请选择服务类型" forState:UIControlStateNormal];
        self.iconImageView.hidden = NO;
    } else if (type == KNBOrderDownTypeRecruitment) {
        self.titleLabel.text = @"入驻类型:";
        [self.describeButton setTitle:@"请选择入驻类型" forState:UIControlStateNormal];
        self.iconImageView.hidden = NO;
    } else if (type == KNBOrderDownTypeHouse) {
        self.titleLabel.text = @"户        型:";
        [self.describeButton setTitle:@"请选择户型" forState:UIControlStateNormal];
    } else if (type == KNBOrderDownTypeStyle) {
        self.titleLabel.text = @"装修风格:";
        [self.describeButton setTitle:@"请选择风格" forState:UIControlStateNormal];
    } else if (type == KNBOrderDownTypeShowPrice) {
        self.titleLabel.text = @"展示费用:";
        [self.describeButton setTitle:@"请选择展示费用" forState:UIControlStateNormal];
    } else if (type == KNBOrderDownTypeDomain) {
        self.titleLabel.text = @"擅长领域:";
        [self.describeButton setTitle:@"请选择擅长领域" forState:UIControlStateNormal];
    } else if (type == KNBOrderDownTypeMedify) {
        self.titleLabel.text = @"密码修改:";
    } else {
        self.titleLabel.text = @"装修档次:";
        [self.describeButton setTitle:@"请选择装修档次" forState:UIControlStateNormal];
    }
    
    [self.describeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.describeButton.imageView.bounds.size.width - 15, 0, self.describeButton.imageView.bounds.size.width + 15)];
    [self.describeButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.describeButton.titleLabel.bounds.size.width - 5, 0, -self.describeButton.titleLabel.bounds.size.width)];
}

@end
