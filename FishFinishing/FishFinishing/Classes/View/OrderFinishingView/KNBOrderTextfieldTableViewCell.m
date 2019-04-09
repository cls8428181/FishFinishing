//
//  KNBOrderTextfieldTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/8.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBOrderTextfieldTableViewCell.h"

@interface KNBOrderTextfieldTableViewCell ()
@property (weak, nonatomic) IBOutlet UITextField *describeTextField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation KNBOrderTextfieldTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBOrderTextfieldTableViewCell";
    KNBOrderTextfieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.describeTextField setValue:[UIColor colorWithHex:0x808080] forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)setType:(KNBOrderTextFieldType)type {
    _type = type;
    if (type == KNBOrderTextFieldTypeArea) {
        self.titleLabel.text = @"房屋面积:";
        self.describeTextField.placeholder = @"m²";
    } else if (type == KNBOrderTextFieldTypeCommunity) {
        self.titleLabel.text = @"小区名称:";
        self.describeTextField.placeholder = @"请输入小区名称";
    } else if (type == KNBOrderTextFieldTypeName) {
        self.titleLabel.text = @"联  系  人:";
        self.describeTextField.placeholder = @"请输入姓名";
    } else {
        self.titleLabel.text = @"联系电话:";
        self.describeTextField.placeholder = @"请输入联系电话";
    }
}

@end
