//
//  KNBeautySortView.m
//  Concubine
//
//  Created by 陈安伟 on 17/6/9.
//  Copyright © 2017年 dengyun. All rights reserved.
//

#import "KNBSortView.h"
#import "KNBDesignSketchCollectionSectionView.h"

@interface KNBSortView ()
//背景视图
@property (nonatomic, strong) UIView *alphaView;
//父视图
@property (nonatomic, strong) UIView *knSuperView;
//开始视图(用来定位位置)
@property (nonatomic, strong) KNBDesignSketchCollectionSectionView *optionView;
//显示文字数组
@property (nonatomic, strong) NSArray *titleArr;
//按钮数组
@property (nonatomic, strong) NSMutableArray *sortButtons;

@end

@implementation KNBSortView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame sortArr:(NSArray *)sortArr superView:(UIView *)superView optionView:(KNBDesignSketchCollectionSectionView *)optionView {
    self = [super initWithFrame:frame];
    if (self) {
        self.knSuperView = superView;
        self.optionView = optionView;
        self.titleArr = sortArr;
        self.backgroundColor = [UIColor whiteColor];
        self.sortViewHeight = 0.0;
        if (sortArr.count) {
            for (int i = 0; i < sortArr.count; i++) {
                UIButton *tit = [UIButton buttonWithType:UIButtonTypeCustom];
                tit.frame = CGRectMake(15, 46 * i, KNB_SCREEN_WIDTH, 45);
                [tit.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
                [tit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                if (i == 0) {
                    [tit setTitleColor:[UIColor knMainColor] forState:UIControlStateNormal];
                }
                [tit setTitle:sortArr[i] forState:UIControlStateNormal];
                tit.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                tit.tag = 100 + i;
                [tit addTarget:self action:@selector(sortBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:tit];
                [self.sortButtons addObject:tit];

                UILabel *topLine = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tit.frame), KNB_SCREEN_WIDTH, 1)];
                topLine.backgroundColor = [UIColor knLightGrayColor];
                [self addSubview:topLine];

                self.sortViewHeight += 46;
            }
        }

        self.clipsToBounds = YES;
    }
    return self;
}

#pragma mark - private mothed
- (void)showSortViewWithSortTag:(NSInteger)sortTag {
    self.optionView.styleButton.selected = self.height == 0.0;
    [UIView animateWithDuration:0.2 animations:^{
        self.height = self.height == 0.0 ? self.sortViewHeight : 0.0;
        self.alphaView.alpha = self.alphaView.alpha == 0.0 ? 0.7 : 0.0;
    }];
    if (sortTag > 99) {
        [self.optionView.styleButton setTitle:self.titleArr[sortTag - 100] forState:UIControlStateNormal];
        for (int i = 0; i < self.titleArr.count; i++) {
            UIButton *btn = (UIButton *)self.sortButtons[i];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            if (i == sortTag - 100) {
                [btn setTitleColor:[UIColor knMainColor] forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark - event response
- (void)sortBtnAction:(UIButton *)button {
    if (self.sortClicked) {
        self.sortClicked(button.tag);
    }
}

- (void)alphaViewAction:(UITapGestureRecognizer *)tap {
    [self showSortViewWithSortTag:0];
}

#pragma mark - lazy load
- (NSMutableArray *)sortButtons {
    if (!_sortButtons) {
        _sortButtons = [[NSMutableArray alloc] init];
    }
    return _sortButtons;
}

- (UIView *)alphaView {
    if (!_alphaView) {
        _alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, KNB_NAV_HEIGHT, KNB_SCREEN_WIDTH, KNB_SCREEN_HEIGHT - KNB_NAV_HEIGHT)];
        _alphaView.backgroundColor = [UIColor blackColor];
        _alphaView.alpha = 0.0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alphaViewAction:)];
        _alphaView.userInteractionEnabled = YES;
        [_alphaView addGestureRecognizer:tap];
        [self.knSuperView insertSubview:_alphaView belowSubview:self];
    }
    return _alphaView;
}

@end
