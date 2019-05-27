//
//  KNBDesignSketchFreeOrderHeaderView.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/1.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBDesignSketchFreeOrderHeaderView.h"

@interface KNBDesignSketchFreeOrderHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation KNBDesignSketchFreeOrderHeaderView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {

    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self addSubview:self.scrollLabel];
//    self.scrollLabel.frame = CGRectMake(30, 104, self.scrollLabel.frame.size.width, self.scrollLabel.frame.size.height);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    KNB_WS(weakSelf);
//    [self.scrollLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(weakSelf.priceLabel);
//        make.right.equalTo(weakSelf.priceLabel.mas_left).mas_offset(-2);
//    }];
}

//- (JQScrollNumberLabel *)scrollLabel {
//    if (!_scrollLabel) {
//        _scrollLabel = [[JQScrollNumberLabel alloc] initWithNumber:@(1) font:[UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:36] textColor:[UIColor whiteColor] rowNumber:8];
//    }
//    return _scrollLabel;
//}

@end
