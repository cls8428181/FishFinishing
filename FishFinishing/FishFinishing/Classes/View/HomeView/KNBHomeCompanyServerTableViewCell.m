//
//  KNBHomeCompanyServerTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/3.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeCompanyServerTableViewCell.h"
#import "FMTagsView.h"

@interface KNBHomeCompanyServerTableViewCell ()
//标签背景
@property (weak, nonatomic) IBOutlet UIView *tagBgView;
//标签视图
@property (nonatomic, strong) FMTagsView *tagView;
@property (weak, nonatomic) IBOutlet UIButton *topButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraints;
@end

@implementation KNBHomeCompanyServerTableViewCell

#pragma mark - life cycle
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBHomeCompanyServerTableViewCell";
    KNBHomeCompanyServerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
    [self.tagBgView addSubview:self.tagView];
}

#pragma mark - private method
+ (CGFloat)cellHeight:(BOOL)isEdit {
    NSString *openString = [[NSUserDefaults standardUserDefaults] objectForKey:@"OpenPayment"];
    if ([openString isEqualToString:@"1"] && isEdit) {
        return 210;
    } else {
        return 85;
    }
}

- (IBAction)topButtonAction:(id)sender {
    !self.topButtonBlock ?: self.topButtonBlock();
}

#pragma mark - lazy load
- (FMTagsView *)tagView {
    if (!_tagView) {
        FMTagsView *tagView = [[FMTagsView alloc] init];
        tagView.contentInsets = UIEdgeInsetsZero;
        tagView.tagInsets = UIEdgeInsetsMake(0.5, 9, 0.5, 9);
        tagView.contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        tagView.tagBorderWidth = 0.5;
        tagView.tagcornerRadius = 10;
        tagView.tagBorderColor = [UIColor colorWithHex:0xebebeb];
        tagView.tagSelectedBorderColor = [UIColor colorWithHex:0xebebeb];
        tagView.tagBackgroundColor = [UIColor colorWithHex:0x009fe8];
        tagView.lineSpacing = 7;
        tagView.interitemSpacing = 5;
        tagView.tagFont = KNBFont(11);
        tagView.tagTextColor = [UIColor whiteColor];
        tagView.allowsSelection = NO;
        tagView.collectionView.scrollEnabled = NO;
        tagView.collectionView.showsVerticalScrollIndicator = NO;
        _tagView = tagView;
    }
    return _tagView;
}

- (void)setModel:(KNBHomeServiceModel *)model {
    NSArray *array = [model.service componentsSeparatedByString:@","]; //分割字符串
    self.tagView.tagsArray = array;
    
    NSString *openString = [[NSUserDefaults standardUserDefaults] objectForKey:@"OpenPayment"];
    if ([openString isEqualToString:@"1"] && self.isEdit) {
        self.topConstraints.constant = 145;
        self.topButton.hidden = NO;
    } else {
        self.topConstraints.constant = 15;
        self.topButton.hidden = YES;
    }

}
@end
