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

- (void)awakeFromNib {
    [super awakeFromNib];
    NSInteger space = 10;
    self.oldHouseButton.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
    self.oldHouseButton.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
    self.houseButton.imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
    self.houseButton.titleEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
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
    self.houseButton.selected = NO;
    button.selected = YES;
    self.isNewHouse = NO;
}

@end
