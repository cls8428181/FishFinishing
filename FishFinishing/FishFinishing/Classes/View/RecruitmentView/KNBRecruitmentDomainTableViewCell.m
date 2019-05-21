//
//  KNBRecruitmentDomainTableViewCell.m
//  FishFinishing
//
//  Created by apple on 2019/4/15.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBRecruitmentDomainTableViewCell.h"
#import "FMTagsView.h"

@interface KNBRecruitmentDomainTableViewCell () <FMTagsViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UIView *tagsView;
//标签视图
@property (nonatomic, strong) FMTagsView *tagView;
@property (weak, nonatomic) IBOutlet UIImageView *allowImageView;
@end

@implementation KNBRecruitmentDomainTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBRecruitmentDomainTableViewCell";
    KNBRecruitmentDomainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

+ (CGFloat)cellHeight {
    return 50;
}

- (void)setType:(KNBRecruitmentDomainType)type {
    if (type == KNBRecruitmentDomainTypeDefault) {
        self.titleLabel.text = @"擅长领域:";
        self.describeLabel.text = @"请选择擅长领域";
    } else {
        self.titleLabel.text = @"服务选择:";
        self.describeLabel.text = @"请选择服务";
    }
}

- (void)setTagsViewDataSource:(NSArray *)dataArray {
    self.describeLabel.hidden = YES;
    [self.tagsView addSubview:self.tagView];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSString *string in dataArray) {
        [tempArray addObject:[NSString stringWithFormat:@"%@ X",string]];
    }
    self.tagView.tagsArray = tempArray;
    KNB_WS(weakSelf);
//    [self.allowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(15);
//        make.centerY.equalTo(weakSelf.contentView);
//        make.width.mas_equalTo(10);
//        make.height.mas_equalTo(6);
//    }];
}

- (void)tagsView:(FMTagsView *)tagsView didSelectTagAtIndex:(NSUInteger)index {
    [self.tagView removeTagAtIndex:index];
    if (isNullArray(self.tagView.tagsArray)) {
        [self.tagView removeFromSuperview];
        self.describeLabel.hidden = NO;
    }
}

- (FMTagsView *)tagView {
    if (!_tagView) {
        FMTagsView *tagView = [[FMTagsView alloc] init];
        tagView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH - 124, self.tagsView.frame.size.height);
        tagView.contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        tagView.alignmentType = FMTagCellAlignmentTypeRight;
        tagView.tagBorderWidth = 0.5;
        tagView.tagcornerRadius = 10;
        tagView.tagBorderColor = [UIColor colorWithHex:0xf2f2f2];
        tagView.tagSelectedBorderColor = [UIColor colorWithHex:0x0096e6];
        tagView.tagBackgroundColor = [UIColor colorWithHex:0xebebeb];
        tagView.tagSelectedBackgroundColor = [UIColor colorWithHex:0x0096e6];
        tagView.interitemSpacing = 10;
        tagView.tagFont = KNBFont(11);
        tagView.tagTextColor = [UIColor colorWithHex:0x333333];
        tagView.allowsSelection = YES;
        tagView.allowsMultipleSelection = NO;
        tagView.collectionView.scrollEnabled = NO;
        tagView.collectionView.showsVerticalScrollIndicator = NO;
        tagView.tagHeight = 20;
        tagView.mininumTagWidth = 40;
        tagView.delegate = self;
        _tagView = tagView;
    }
    return _tagView;
}

@end
