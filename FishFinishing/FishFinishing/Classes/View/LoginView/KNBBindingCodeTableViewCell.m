//
//  KNBBindingCodeTableViewCell.m
//  FishFinishing
//
//  Created by apple on 2019/4/25.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBindingCodeTableViewCell.h"

#define KNBTimerInvalue 60

@interface KNBBindingCodeTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
//定时器
@property (nonatomic) dispatch_source_t theTimer;
@end

@implementation KNBBindingCodeTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBBindingCodeTableViewCell";
    KNBBindingCodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

+ (CGFloat)cellHeight {
    return 90;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.codeButton.layer.borderColor = [UIColor colorWithHex:0xf2f2f2].CGColor;
    self.codeButton.layer.borderWidth = 1;
    self.codeButton.layer.masksToBounds = YES;
    self.codeButton.layer.cornerRadius = 3;
}

- (IBAction)getCodeAction:(id)sender {
    !self.getVerifyCodeBlock ?: self.getVerifyCodeBlock();
}

- (void)timerControll:(BOOL)startTimer {
    if (!startTimer) {
        if (self.theTimer != nil) {
            dispatch_source_cancel(self.theTimer);
        }
        [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    } else {
        __block int timeout = KNBTimerInvalue; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if (timeout <= 0) { //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.codeButton setTitle:@"重新获取" forState:UIControlStateNormal];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [self.codeButton setTitle:[NSString stringWithFormat:@"(%ds)", timeout] forState:UIControlStateNormal];
                });
                timeout--;
            }
        });
        self.theTimer = _timer;
        dispatch_resume(_timer);
    }
}
@end
