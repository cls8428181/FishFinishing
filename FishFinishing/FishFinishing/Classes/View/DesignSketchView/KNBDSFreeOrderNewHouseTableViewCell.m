//
//  KNBDSFreeOrderNewHouseTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/1.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBDSFreeOrderNewHouseTableViewCell.h"
@interface KNBDSFreeOrderNewHouseTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *houseButton;
@property (weak, nonatomic) IBOutlet UIButton *oldHouseButton;
@end

@implementation KNBDSFreeOrderNewHouseTableViewCell

#pragma mark - life cycle
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBDSFreeOrderNewHouseTableViewCell";
    KNBDSFreeOrderNewHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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

#pragma mark - event respon

- (IBAction)newHouseButtonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (!self.isNewHouse) {
        button.selected = YES;
        self.oldHouseButton.selected = NO;
        self.isNewHouse = YES;
    }
}
- (IBAction)oldHouseButtonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (self.isNewHouse) {
        self.houseButton.selected = NO;
        button.selected = YES;
        self.isNewHouse = NO;
    }
}

@end
