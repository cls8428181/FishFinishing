//
//  KNBHomeDesignSketchSubTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/1.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeDesignSketchSubTableViewCell.h"

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

@end
