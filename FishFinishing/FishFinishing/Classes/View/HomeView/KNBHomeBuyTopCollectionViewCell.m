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

@end
