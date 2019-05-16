//
//  KNBHomeHeaderView.m
//  FishFinishing
//
//  Created by apple on 2019/5/16.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeHeaderView.h"

@interface KNBHomeHeaderView ()<SDCycleScrollViewDelegate>
// 轮播图
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation KNBHomeHeaderView

- (instancetype)initWithDataSource:(NSArray *)dataSource {
    if (self = [super init]) {
        _dataArray = dataSource;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.cycleScrollView];
    }
    return self;
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(13, 13, KNB_SCREEN_WIDTH - 26, 130) delegate:nil placeholderImage:[UIImage imageNamed:@"knb_home_banner"]];
        _cycleScrollView.delegate = self;
        _cycleScrollView.backgroundColor = [UIColor whiteColor];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.pageDotColor = [UIColor whiteColor];
        _cycleScrollView.currentPageDotColor = KNB_RGB(255, 94, 132);
        _cycleScrollView.autoScrollTimeInterval = 3.5f;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        _cycleScrollView.imageURLStringsGroup = self.dataArray;
        _cycleScrollView.layer.masksToBounds = YES;
        _cycleScrollView.layer.cornerRadius = 3;
    }
    return _cycleScrollView;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(homeCycleScrollView:didSelectItemAtIndex:)]) {
        [self.delegate homeCycleScrollView:cycleScrollView didSelectItemAtIndex:index];
    }
}

@end
