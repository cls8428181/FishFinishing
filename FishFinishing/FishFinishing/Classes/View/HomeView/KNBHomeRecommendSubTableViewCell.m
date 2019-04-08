//
//  KNBHomeRecommendSubTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/27.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeRecommendSubTableViewCell.h"
#import "FMTagsView.h"

@interface KNBHomeRecommendSubTableViewCell ()
//标签背景
@property (weak, nonatomic) IBOutlet UIView *tagBgView;
//标签视图
@property (nonatomic, strong) FMTagsView *tagView;

@end

@implementation KNBHomeRecommendSubTableViewCell

#pragma mark - life cycle
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBHomeRecommendSubTableViewCell";
    KNBHomeRecommendSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
    self.tagView.tagsArray = @[@"装修",@"漂亮",@"大方"];
}

#pragma mark - private method
+ (CGFloat)cellHeight {
    return 195;
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
        tagView.tagBackgroundColor = [UIColor colorWithHex:0xfafafa];
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
@end
