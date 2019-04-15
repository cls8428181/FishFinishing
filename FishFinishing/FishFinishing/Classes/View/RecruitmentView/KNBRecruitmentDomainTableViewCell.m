//
//  KNBRecruitmentDomainTableViewCell.m
//  FishFinishing
//
//  Created by apple on 2019/4/15.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBRecruitmentDomainTableViewCell.h"

@interface KNBRecruitmentDomainTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *tagsView;

@end
@implementation KNBRecruitmentDomainTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBRecruitmentDomainTableViewCell";
    KNBRecruitmentDomainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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

- (void)setType:(KNBRecruitmentDomainType)type {
    if (type == KNBRecruitmentDomainTypeDefault) {
        self.titleLabel.text = @"擅长领域:";
    } else {
        self.titleLabel.text = @"服务选择:";
    }
}

@end
