//
//  KNBRecruitmentPayTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/9.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBRecruitmentPayTableViewCell.h"

@interface KNBRecruitmentPayTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation KNBRecruitmentPayTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView payType:(NSString *)type {
    static NSString *ID = @"KNBRecruitmentPayTableViewCell";
    KNBRecruitmentPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([type containsString:@"支付宝"]) {
        cell.payTypeLabel.text = @"支付宝支付";
        cell.iconImageView.image = KNBImages(@"knb_pay_alipy");
    } else {
        cell.payTypeLabel.text = @"微信支付";
        cell.iconImageView.image = KNBImages(@"knb_pay_wechat");
    }
    return cell;
}

+ (CGFloat)cellHeight {
    return 50;
}

- (IBAction)selectButtonAction:(id)sender {
    !self.selectButtonBlock ?: self.selectButtonBlock(sender);

}

@end
