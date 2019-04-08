//
//  KNBDesignSketchCollectionViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/4.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBDesignSketchCollectionViewCell.h"

@interface KNBDesignSketchCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation KNBDesignSketchCollectionViewCell

#pragma mark - life cycle
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"KNBDesignSketchCollectionViewCell";
    KNBDesignSketchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"KNBDesignSketchCollectionViewCell" owner:self options:nil].lastObject;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.borderColor = [UIColor colorWithHex:0xe6e6e6].CGColor;
    self.bgView.layer.borderWidth = 1;
}


#pragma mark - private method
+ (CGFloat)cellHeight {
    return 160;
}

@end
