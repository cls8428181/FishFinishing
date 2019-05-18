//
//  KNBHomeCompanyIntroTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/3.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeCompanyIntroTableViewCell.h"
#import "NSString+Size.h"

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
    if (model.isSpread) {
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
    self.model.isSpread = button.isSelected;
    if (button.isSelected) {
        [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            button.transform = CGAffineTransformMakeRotation(M_PI);
            //监听tableview动画执行结束时间
            [CATransaction begin];
            [CATransaction setCompletionBlock:^{
                weakSelf.heightConstraint.constant = [weakSelf.model.remark heightWithFont:KNBFont(13) constrainedToWidth:KNB_SCREEN_WIDTH - 24] + 6;
                //tableview动画结束回调
                [weakSelf.superTableView reloadData];
            }];
            [weakSelf.superTableView beginUpdates];
            [weakSelf.superTableView endUpdates];
            [CATransaction commit];
        }completion:^(BOOL finished) {
            //UIView动画结束回调
            [button setImage:KNBImages(@"knb_service_xiala") forState:UIControlStateNormal];
        }];
    } else {
        [UIView animateWithDuration:0.3f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //监听tableview动画执行结束时间
            //button.transform = CGAffineTransformIdentity;
            if (weakSelf.superTableView.contentOffset.y > KNB_SCREEN_HEIGHT/2) {
                [weakSelf.superTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
                [weakSelf.superTableView setContentOffset:CGPointMake(0,0) animated:YES];
            };
            weakSelf.heightConstraint.constant = 55;
            button.transform = CGAffineTransformMakeRotation(2*M_PI);

            [CATransaction begin];
            [CATransaction setCompletionBlock:^{
                //tableview动画结束回调
                [weakSelf.superTableView reloadData];
            }];
            [weakSelf.superTableView beginUpdates];
            [weakSelf.superTableView endUpdates];
            [CATransaction commit];
        }completion:^(BOOL finished) {
            //UIView动画结束回调
            [button setImage:KNBImages(@"knb_service_xiala") forState:UIControlStateNormal];
        }];
    }
}

- (void)setModel:(KNBHomeServiceModel *)model {
    _model = model;
    self.contentLabel.text = model.remark;
}
@end
