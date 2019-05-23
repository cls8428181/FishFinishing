//
//  KNBHomeCompanyHeaderTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/3.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeCompanyHeaderTableViewCell.h"
#import "FMTagsView.h"
#import "NSString+Size.h"
#import "NSDate+BTAddition.h"

@interface KNBHomeCompanyHeaderTableViewCell ()
//标签背景
@property (weak, nonatomic) IBOutlet UIView *tagBgView;
//标签视图
@property (nonatomic, strong) FMTagsView *tagView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIButton *adButton;
@property (weak, nonatomic) IBOutlet UILabel *experienceTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet UILabel *enterLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *maxSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation KNBHomeCompanyHeaderTableViewCell

#pragma mark - life cycle
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBHomeCompanyHeaderTableViewCell";
    KNBHomeCompanyHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    KNB_WS(weakSelf);
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.tagBgView);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.addressLabel.preferredMaxLayoutWidth = KNB_SCREEN_WIDTH - 150;
    [self.tagBgView addSubview:self.tagView];
}

- (IBAction)adButtonAction:(id)sender {
    !self.adButtonBlock ?: self.adButtonBlock();
}

#pragma mark - private method
+ (CGFloat)cellHeight:(BOOL)isEdit {
    NSString *openString = [[NSUserDefaults standardUserDefaults] objectForKey:@"OpenPayment"];
    if ([openString isEqualToString:@"1"] && isEdit) {
        return 210;
    } else {
        return 130;
    }
}

#pragma mark - lazy load
- (FMTagsView *)tagView {
    if (!_tagView) {
        FMTagsView *tagView = [[FMTagsView alloc] init];
        tagView.contentInsets = UIEdgeInsetsZero;
        tagView.tagInsets = UIEdgeInsetsMake(0.5, 8.5, 0.5, 9);
        tagView.contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        tagView.tagBorderWidth = 0.5;
        tagView.tagcornerRadius = 10;
        tagView.tagBorderColor = [UIColor colorWithHex:0xebebeb];
        tagView.tagSelectedBorderColor = [UIColor colorWithHex:0xebebeb];
        tagView.tagBackgroundColor = [UIColor colorWithHex:0xf2f2f2];
        tagView.lineSpacing = 7;
        tagView.interitemSpacing = 5;
        tagView.tagFont = KNBFont(11);
        tagView.tagTextColor = [UIColor colorWithHex:0x666666];
        tagView.allowsSelection = NO;
        tagView.collectionView.scrollEnabled = NO;
        tagView.collectionView.showsVerticalScrollIndicator = NO;
        _tagView = tagView;
    }
    return _tagView;
}

- (void)setModel:(KNBHomeServiceModel *)model {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:CCPortraitPlaceHolder];
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 45;
    self.nameLabel.text = model.name;
    //计算名称最大长度
    self.maxSpace.constant = KNB_SCREEN_WIDTH - 186;
    //地址
    self.addressLabel.text = model.address;
    CGFloat height  = [model.address heightWithFont:[UIFont systemFontOfSize:13] constrainedToWidth:KNB_SCREEN_WIDTH - 150];
    if (height > 30) {
        height = 32;
    }
    [self.addressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    NSArray *array = [model.tag componentsSeparatedByString:@","]; //分割字符串
    if (isNullArray(array)) {
        self.tagView.hidden = YES;
    } else {
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:array];
        for (int i = 0; i < tempArray.count; i++) {
            NSString *str = tempArray[i];
            if (isNullStr(str)) {
                [tempArray removeObject:str];
            }
        }
        if (isNullArray(tempArray)) {
            self.tagView.tagsArray = @[@"无"];
        } else {
            self.tagView.hidden = NO;
            self.tagView.tagsArray = tempArray;
        }
    }
    if ([model.is_stick isEqualToString:@"0"]) {
        self.topImageView.hidden = YES;
    } else {
        self.topImageView.hidden = NO;
    }
    
    NSString *openString = [[NSUserDefaults standardUserDefaults] objectForKey:@"OpenPayment"];
    if ([openString isEqualToString:@"1"] && self.isEdit) {
        self.adView.hidden = NO;
        self.bottomConstraint.constant = 95;
    } else {
        self.adView.hidden = YES;
        self.bottomConstraint.constant = 15;
    }
    
    NSInteger time = [NSDate getDifferenceByDate:[NSDate transformFromTimestamp:model.due_time]];
    if (time < 0) {
        time = 0;
    }
    if ([model.is_experience isEqualToString:@"1"]) {
        self.experienceTimeLabel.text = [NSString stringWithFormat:@"%ld天后入驻到期[体验版]",(long)time];
        self.enterLabel.text = @"马上升级";
    } else {
        self.experienceTimeLabel.text = [NSString stringWithFormat:@"%ld天后入驻到期[正式版]",(long)time];
        self.enterLabel.text = @"马上续费";
    }
    
}

@end
