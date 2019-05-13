//
//  KNBHomeDesignSketchSubTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/1.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeDesignSketchSubTableViewCell.h"

@interface KNBHomeDesignSketchSubTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation KNBHomeDesignSketchSubTableViewCell

#pragma mark - life cycle
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"KNBHomeDesignSketchSubTableViewCell";
    KNBHomeDesignSketchSubTableViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"KNBHomeDesignSketchSubTableViewCell" owner:self options:nil].lastObject;
    }
    return self;
}

#pragma mark - private method
+ (CGFloat)cellHeight {
    return 160;
}

- (void)setModel:(KNBHomeRecommendCaseModel *)model {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:KNBImages(@"knb_default_style")];
    if (isNullStr(model.cat_name)) {
        self.titleLabel.text = model.name;
    } else {
        self.titleLabel.text = model.cat_name;
    }
}

@end
