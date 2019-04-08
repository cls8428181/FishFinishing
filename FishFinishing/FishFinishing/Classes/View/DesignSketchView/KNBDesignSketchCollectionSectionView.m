//
//  KNBDesignSketchCollectionSectionView.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/28.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBDesignSketchCollectionSectionView.h"

@interface KNBDesignSketchCollectionSectionView ()
@end

@implementation KNBDesignSketchCollectionSectionView

#pragma mark - life cycle
- (instancetype)init {
    if (self = [super init]) {

    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - 风格按钮
- (IBAction)styleBtnClick:(UIButton *)sender {
    if (self.optionCompleteBlock) {
        self.optionCompleteBlock(self, KNBOptionViewButtonType_Style);
    }
}

#pragma mark - 户型按钮
- (IBAction)typeBtnClick:(UIButton *)sender {
}

#pragma mark - 面积按钮
- (IBAction)areaBtnClick:(UIButton *)sender {
}

@end
