//
//  KNBHomeCompanyIntroTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/3.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeCompanyIntroTableViewCell.h"
#import "NSString+Size.h"
#import "KNBHomeCompanyServerTableViewCell.h"
static NSMutableArray *receiverArr;
static KNBHomeCompanyServerTableViewCell *cell;

@interface KNBHomeCompanyIntroTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) UITableView *superTableView;

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
    cell.superTableView = tableView;
    return cell;
}

#pragma mark - private method
+ (CGFloat)cellHeight:(KNBHomeServiceModel *)model {
    CGFloat height = 0;
    if (model.isOpen) {
        height = [model.remark heightWithFont:KNBFont(13) constrainedToWidth:KNB_SCREEN_WIDTH - 24];
    } else {
        height = 60;
    }
    return 100 + height;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)bottomButtonAction:(id)sender {
    KNB_WS(weakSelf);
    UIButton *button = (UIButton *)sender;
    button.selected = !button.isSelected;
//    self.model.isSpread = button.isSelected;
    !self.openIntroBlock ?: self.openIntroBlock();
//    if (button.isSelected) {
//        self.heightConstraint.constant = [weakSelf.model.remark heightWithFont:KNBFont(13) constrainedToWidth:KNB_SCREEN_WIDTH - 24] + 6;
//    } else {
//
//        self.heightConstraint.constant = 55;
//        button.transform = CGAffineTransformMakeRotation(2*M_PI);
//    }
//    [self.superTableView reloadData];

//    if (button.isSelected) {
//        [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            button.transform = CGAffineTransformMakeRotation(M_PI);
//            //监听tableview动画执行结束时间
//            [CATransaction begin];
//            [CATransaction setCompletionBlock:^{
//                weakSelf.heightConstraint.constant = [weakSelf.model.remark heightWithFont:KNBFont(13) constrainedToWidth:KNB_SCREEN_WIDTH - 24] + 6;
//                //tableview动画结束回调
//                weakSelf.superTableView.estimatedRowHeight = 0;
//                weakSelf.superTableView.estimatedSectionHeaderHeight = 0;
//                weakSelf.superTableView.estimatedSectionFooterHeight = 0;
//                [weakSelf.superTableView reloadData];
//            }];
//            [weakSelf.superTableView beginUpdates];
//            [weakSelf.superTableView endUpdates];
//            [CATransaction commit];
//        }completion:^(BOOL finished) {
//            //UIView动画结束回调
//            [button setImage:KNBImages(@"knb_service_xiala") forState:UIControlStateNormal];
//        }];
//    } else {
//        [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            //监听tableview动画执行结束时间
//            //button.transform = CGAffineTransformIdentity;
//            weakSelf.heightConstraint.constant = 55;
//            button.transform = CGAffineTransformMakeRotation(2*M_PI);
//
//            [CATransaction begin];
//            [CATransaction setCompletionBlock:^{
//                //tableview动画结束回调
//                weakSelf.superTableView.estimatedRowHeight = 0;
//                weakSelf.superTableView.estimatedSectionHeaderHeight = 0;
//                weakSelf.superTableView.estimatedSectionFooterHeight = 0;
//                [weakSelf.superTableView reloadData];
//            }];
//            [weakSelf.superTableView beginUpdates];
//            [weakSelf.superTableView endUpdates];
//            [CATransaction commit];
//        }completion:^(BOOL finished) {
//            //UIView动画结束回调
//            [button setImage:KNBImages(@"knb_service_xiala") forState:UIControlStateNormal];
//        }];
//    }
}

- (void)setModel:(KNBHomeServiceModel *)model {
    _model = model;
    self.contentLabel.text = model.remark;
    if (model.isOpen) {
        self.contentLabel.numberOfLines = NSIntegerMax;
    } else {
        self.contentLabel.numberOfLines = 4;
    }
}
@end
