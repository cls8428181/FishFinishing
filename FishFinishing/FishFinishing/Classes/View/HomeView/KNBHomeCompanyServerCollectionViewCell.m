//
//  KNBHomeCompanyServerCollectionViewCell.m
//  FishFinishing
//
//  Created by apple on 2019/5/16.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeCompanyServerCollectionViewCell.h"

@interface KNBHomeCompanyServerCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation KNBHomeCompanyServerCollectionViewCell

#pragma mark - life cycle
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"KNBHomeCompanyServerCollectionViewCell";
    KNBHomeCompanyServerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"KNBHomeCompanyServerCollectionViewCell" owner:self options:nil].lastObject;
    }
    return self;
}

#pragma mark - private method
+ (CGFloat)cellHeight {
    return 160;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(KNBHomeServiceModel *)model {
    self.titleLabel.text = model.service_name;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
}

@end
