//
//  KNBRecruitmentEnterTableViewCell.m
//  FishFinishing
//
//  Created by apple on 2019/4/15.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBRecruitmentEnterTableViewCell.h"

@interface KNBRecruitmentEnterTableViewCell ()
//确认按钮
@property (weak, nonatomic) IBOutlet UIButton *enterButton;
@end

@implementation KNBRecruitmentEnterTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBRecruitmentEnterTableViewCell";
    KNBRecruitmentEnterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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

- (void)setType:(KNBRecruitmentEnterType)type {
    if (type == KNBRecruitmentEnterTypeOrder) {
        [self.enterButton setTitle:@"免费预约" forState:UIControlStateNormal];
        
    }  else if (type == KNBRecruitmentEnterTypeSet) {
        [self.enterButton setTitle:@"退出" forState:UIControlStateNormal];

    } else {
        [self.enterButton setTitle:@"立即入驻" forState:UIControlStateNormal];
    }
}

- (IBAction)enterButtonAction:(id)sender {
    !self.selectButtonBlock ?: self.selectButtonBlock(sender);
}

@end
