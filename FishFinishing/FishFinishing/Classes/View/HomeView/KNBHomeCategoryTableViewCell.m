//
//  KNBHomeCategoryTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/26.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeCategoryTableViewCell.h"

@interface KNBHomeCategoryTableViewCell ()

@end

@implementation KNBHomeCategoryTableViewCell

#pragma mark - life cycle
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBHomeCategoryTableViewCell";
    KNBHomeCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - private method
+ (CGFloat)cellHeight {
    return 225;
}

#pragma mark - event respon
- (IBAction)offerButtonAction:(id)sender {
    !self.offerButtonAction ?: self.offerButtonAction();
}
- (IBAction)companyButtonAction:(id)sender {
    !self.companyButtonAction ?: self.companyButtonAction();
}
- (IBAction)foremanButtonAction:(id)sender {
    !self.foremanButtonAction ?: self.foremanButtonAction();
}
- (IBAction)designButtonAction:(id)sender {
    !self.designButtonAction ?: self.designButtonAction();
}
- (IBAction)materialsButtonAction:(id)sender {
    !self.materialButtonAction ?: self.materialButtonAction();
}
- (IBAction)workerButtonAction:(id)sender {
    !self.workerButtonAction ?: self.workerButtonAction();
}

@end
