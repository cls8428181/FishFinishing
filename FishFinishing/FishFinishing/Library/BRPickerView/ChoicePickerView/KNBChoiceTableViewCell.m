//
//  KNBChoiceTableViewCell.m
//  FishFinishing
//
//  Created by apple on 2019/4/16.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBChoiceTableViewCell.h"

@interface KNBChoiceTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, assign) NSInteger num;

@end

@implementation KNBChoiceTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBChoiceTableViewCell";
    KNBChoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.num = 0;
    return cell;
}

+ (CGFloat)cellHeight {
    return 50;
}

- (void)setType:(KNBChoiceType)type {
    if (type == KNBChoiceTypeBedroom) {
        self.titleLabel.text = @"卧室";
    } else if (type == KNBChoiceTypeLivingroom) {
        self.titleLabel.text = @"客厅";
    } else if (type == KNBChoiceTypeDiningroom) {
        self.titleLabel.text = @"餐厅";
    } else if (type == KNBChoiceTypeKitchen) {
        self.titleLabel.text = @"厨房";
    } else {
        self.titleLabel.text = @"卫生间";
    }
}

- (IBAction)addButtonAction:(id)sender {
    !self.addButtonBlock ?: self.addButtonBlock();
    self.num = self.num + 1;
    self.numTextField.text = [NSString stringWithFormat:@"%ld",self.num];
}
- (IBAction)subButtonAction:(id)sender {
    !self.subButtonBlock ?: self.subButtonBlock();
    self.num = self.num - 1;
    if (self.num < 0) {
        self.num = 0;
    }
    self.numTextField.text = [NSString stringWithFormat:@"%ld",self.num];
}

@end
