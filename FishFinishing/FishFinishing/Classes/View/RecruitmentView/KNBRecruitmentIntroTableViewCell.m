//
//  KNBRecruitmentIntroTableViewCell.m
//  FishFinishing
//
//  Created by apple on 2019/4/15.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBRecruitmentIntroTableViewCell.h"

@interface KNBRecruitmentIntroTableViewCell ()
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation KNBRecruitmentIntroTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBRecruitmentIntroTableViewCell";
    KNBRecruitmentIntroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

+ (CGFloat)cellHeight {
    return 210;
}
@end
