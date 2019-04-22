//
//  KNBDSFreeOrderAddressTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/1.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBDSFreeOrderAddressTableViewCell.h"

@interface KNBDSFreeOrderAddressTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *provinceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@end

@implementation KNBDSFreeOrderAddressTableViewCell

#pragma mark - life cycle
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBDSFreeOrderAddressTableViewCell";
    KNBDSFreeOrderAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - private method
+ (CGFloat)cellHeight {
    return 50;
}

- (void)setProvinceName:(NSString *)provinceName cityName:(NSString *)cityName areaName:(NSString *)areaName {
    self.provinceLabel.text = provinceName;
    self.cityLabel.text = cityName;
    self.areaLabel.text = areaName;
}
@end
