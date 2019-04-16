//
//  KNBOrderAddressTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/8.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBOrderAddressTableViewCell.h"

@interface KNBOrderAddressTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *provinceButton;
@property (weak, nonatomic) IBOutlet UIButton *cityButton;
@property (weak, nonatomic) IBOutlet UIButton *districtButton;
@property (weak, nonatomic) IBOutlet UILabel *provinceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

@end

@implementation KNBOrderAddressTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBOrderAddressTableViewCell";
    KNBOrderAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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

- (void)setProvinceName:(NSString *)provinceName cityName:(NSString *)cityName areaName:(NSString *)areaName {
    self.provinceLabel.text = provinceName;
    self.cityLabel.text = cityName;
    self.areaLabel.text = areaName;
}

@end
