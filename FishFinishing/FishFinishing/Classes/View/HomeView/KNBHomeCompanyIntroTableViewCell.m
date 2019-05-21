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
@property (nonatomic, assign) BOOL isOpen;
@property (weak, nonatomic) IBOutlet UIImageView *allowImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstrait;

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
    return 104 + height;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.isOpen = YES;
}

- (IBAction)bottomButtonAction:(id)sender {
    !self.openIntroBlock ?: self.openIntroBlock();
}

- (void)setModel:(KNBHomeServiceModel *)model {
    _model = model;
    self.contentLabel.text = model.remark;
    if (model.isOpen) {
        self.contentLabel.numberOfLines = NSIntegerMax;
    } else {
        self.contentLabel.numberOfLines = 4;
    }
    if (model.isShow) {
        self.allowImageView.hidden = NO;
        self.bottomConstrait.constant = 45;
        //根据是否展开显示尖头的方向（向下或向上）
        UIImage *img = [UIImage imageNamed:@"knb_service_xiala"];
        if (model.isOpen){
            //image的翻转
            img = [UIImage imageWithCGImage:img.CGImage scale:1 orientation:UIImageOrientationDown];
            
        }
        self.allowImageView.image = img;
    } else {
        self.bottomConstrait.constant = 15;
        self.allowImageView.hidden = YES;
    }
    

}

@end
