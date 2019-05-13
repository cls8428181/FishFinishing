//
//  KNBOrderTextfieldTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/8.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBOrderTextfieldTableViewCell.h"

@interface KNBOrderTextfieldTableViewCell ()
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
        self.describeTextField.keyboardType = UIKeyboardTypeDecimalPad;
    } else if (type == KNBOrderTextFieldTypeCommunity) {
        self.titleLabel.text = @"小区名称:";
        self.describeTextField.placeholder = @"请输入小区名称";
    } else if (type == KNBOrderTextFieldTypeName) {
        self.titleLabel.text = @"联  系  人:";
        self.describeTextField.placeholder = @"请输入姓名";
    } else if (type == KNBOrderTextFieldTypeShopName) {
        self.titleLabel.text = @"商家名称:";
        self.describeTextField.placeholder = @"请输入商家名称";
    } else if (type == KNBOrderTextFieldTypeNickName) {
        self.titleLabel.text = @"昵     称:";
        self.describeTextField.placeholder = @"请输入昵称";
    } else if (type == KNBOrderTextFieldTypeLocation) {
        self.titleLabel.text = @"所在位置:";
        self.describeTextField.placeholder = @"请输入商家位置";
    } else if (type == KNBOrderTextFieldTypeShopPhone) {
        self.titleLabel.text = @"商家电话:";
        self.describeTextField.placeholder = @"请输入商家电话";
        self.describeTextField.keyboardType = UIKeyboardTypePhonePad;
    } else if (type == KNBOrderTextFieldTypeProductName) {
        self.titleLabel.text = @"产品名称:";
        self.describeTextField.placeholder = @"请输入产品名称";
    } else if (type == KNBOrderTextFieldTypeProductPrice) {
        self.titleLabel.text = @"产品价格:";
        self.describeTextField.placeholder = @"请输入产品价格";
        self.describeTextField.keyboardType = UIKeyboardTypePhonePad;
    } else if (type == KNBOrderTextFieldTypeTitle) {
        self.titleLabel.text = @"案例标题:";
        self.describeTextField.placeholder = @"请输入案例标题";
    } else {
        self.titleLabel.text = @"联系电话:";
        self.describeTextField.placeholder = @"请输入联系电话";
        self.describeTextField.keyboardType = UIKeyboardTypePhonePad;
    }
}

@end
