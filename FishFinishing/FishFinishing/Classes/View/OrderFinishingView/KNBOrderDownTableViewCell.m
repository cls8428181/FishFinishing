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
@property (weak, nonatomic) IBOutlet UIButton *describeButton;

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

- (void)setType:(KNBOrderDownType)type {
    _type = type;
    self.iconImageView.hidden = YES;
    if (type == KNBOrderDownTypeServer) {
        self.titleLabel.text = @"服务类型:";
        [self.describeButton setTitle:@"装修公司" forState:UIControlStateNormal];
        self.iconImageView.hidden = NO;
    } else if (type == KNBOrderDownTypeHouse) {
        self.titleLabel.text = @"户        型:";
        [self.describeButton setTitle:@"3室,1厅,1厨,1卫" forState:UIControlStateNormal];
    } else if (type == KNBOrderDownTypeStyle) {
        self.titleLabel.text = @"装修风格:";
        [self.describeButton setTitle:@"新中式风格" forState:UIControlStateNormal];
    } else {
        self.titleLabel.text = @"装修档次:";
        [self.describeButton setTitle:@"中" forState:UIControlStateNormal];
    }
    
    [self.describeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.describeButton.imageView.bounds.size.width - 15, 0, self.describeButton.imageView.bounds.size.width + 15)];
    [self.describeButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.describeButton.titleLabel.bounds.size.width - 5, 0, -self.describeButton.titleLabel.bounds.size.width + 5)];
}

@end
