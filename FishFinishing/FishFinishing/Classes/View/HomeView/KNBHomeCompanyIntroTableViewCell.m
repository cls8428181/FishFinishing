//
//  KNBHomeCompanyIntroTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/3.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeCompanyIntroTableViewCell.h"
#import "NSString+Size.h"

@interface KNBHomeCompanyIntroTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@end

@implementation KNBHomeCompanyIntroTableViewCell

#pragma mark - life cycle
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBHomeCompanyIntroTableViewCell";
    KNBHomeCompanyIntroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - private method
+ (CGFloat)cellHeight:(KNBHomeServiceModel *)model {
    CGFloat height = 0;
    if (model.isSpread) {
        height = [model.remark heightWithFont:[UIFont systemFontOfSize:14] constrainedToWidth:KNB_SCREEN_WIDTH - 24];
    } else {
        height = 60;
    }
    return 100 + height;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)bottomButtonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.isSelected;
    self.model.isSpread = button.isSelected;
    if (button.isSelected) {
        self.heightConstraint.constant = [self.model.remark heightWithFont:[UIFont systemFontOfSize:14] constrainedToWidth:KNB_SCREEN_WIDTH - 24];
    } else {
        self.heightConstraint.constant = 55;
    }
    !self.spreadIntroBlock ?: self.spreadIntroBlock();
}

- (void)setModel:(KNBHomeServiceModel *)model {
    _model = model;
    self.contentLabel.text = model.remark;
}
@end
