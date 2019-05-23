//
//  KNBHomeUploadCaseCollectionViewCell.m
//  FishFinishing
//
//  Created by apple on 2019/4/19.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBHomeUploadCaseCollectionViewCell.h"

@interface KNBHomeUploadCaseCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *delButton;

@end

@implementation KNBHomeUploadCaseCollectionViewCell

#pragma mark - life cycle
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"KNBHomeUploadCaseCollectionViewCell";
    KNBHomeUploadCaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"KNBHomeUploadCaseCollectionViewCell" owner:self options:nil].lastObject;
    }
    return self;
}

#pragma mark - private method
+ (CGFloat)cellHeight {
    return 160;
}

- (IBAction)delButtonAction:(id)sender {
    !self.delButtonBlock ?: self.delButtonBlock();
}

@end
