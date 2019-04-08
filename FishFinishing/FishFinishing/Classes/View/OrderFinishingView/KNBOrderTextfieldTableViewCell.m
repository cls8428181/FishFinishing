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

@end
