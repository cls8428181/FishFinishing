//
//  KNBRecruitmentProtocolTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/9.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBRecruitmentProtocolTableViewCell.h"

@interface KNBRecruitmentProtocolTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *agreeButton;

@end

@implementation KNBRecruitmentProtocolTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBRecruitmentProtocolTableViewCell";
    KNBRecruitmentProtocolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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

- (IBAction)selectButtonAction:(id)sender {
    !self.selectButtonBlock ?: self.selectButtonBlock(sender);
}

@end
