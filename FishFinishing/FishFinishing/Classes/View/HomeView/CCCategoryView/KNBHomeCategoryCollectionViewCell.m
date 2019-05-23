//
//  KNBHomeCategoryCollectionViewCell.m
//  FishFinishing
//
//  Created by apple on 2019/4/18.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBHomeCategoryCollectionViewCell.h"

@interface KNBHomeCategoryCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *markButton;
@end

@implementation KNBHomeCategoryCollectionViewCell

#pragma mark - life cycle
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"KNBHomeCategoryCollectionViewCell";
    KNBHomeCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"KNBHomeCategoryCollectionViewCell" owner:self options:nil].lastObject;
    }
    return self;
}

#pragma mark - private method
+ (CGFloat)cellHeight {
    return 160;
}

- (void)setModel:(KNBRecruitmentTypeModel *)model {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:KNBImages(@"knb_home_icon_offer")];
    self.titleLabel.text = model.catName;
    if ([model.catName isEqualToString:@"量房报价"]) {
        self.markButton.hidden = NO;
    } else {
        self.markButton.hidden = YES;
    }
}
@end
