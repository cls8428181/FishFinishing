//
//  KNBHomeBuyTopCollectionViewCell.m
//  FishFinishing
//
//  Created by apple on 2019/4/25.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBHomeBuyTopCollectionViewCell.h"

@interface KNBHomeBuyTopCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *topTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *markImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation KNBHomeBuyTopCollectionViewCell
#pragma mark - life cycle
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"KNBHomeBuyTopCollectionViewCell";
    KNBHomeBuyTopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"KNBHomeBuyTopCollectionViewCell" owner:self options:nil].lastObject;
    }
    return self;
}

- (void)setModel:(KNBRecruitmentCostModel *)model {
//    NSString *timeString = @"";
//    if ([model.termType isEqualToString:@"year"]) {
//        timeString = [NSString stringWithFormat:@"%@年",model.term];
//    } else if ([model.termType isEqualToString:@"month"]) {
//        timeString = [NSString stringWithFormat:@"%@月",model.term];
//    } else {
//        timeString = [NSString stringWithFormat:@"%@日",model.term];
//    }
    self.topTimeLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@元",model.price];
    self.markImageView.hidden = [model.isRecommend isEqualToString:@"0"];
    if (model.isSelected) {
        self.bgView.layer.borderColor = [UIColor colorWithHex:0xff6700].CGColor;
        self.bgView.layer.borderWidth = 1;
    } else {
        self.bgView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.bgView.layer.borderWidth = 1;
    }
}

@end
