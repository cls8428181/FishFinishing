//
//  KNBNavigationView.m
//  KenuoTraining
//
//  Created by 妖狐小子 on 2017/4/12.
//  Copyright © 2017年 Robert. All rights reserved.
//

#import "KNBNavigationView.h"
#import "NSString+Size.h"

@interface KNBNavigationView ()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation KNBNavigationView

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, KNB_SCREEN_WIDTH, KNB_NAV_HEIGHT)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configView];
    }
    return self;
}

- (void)configView {
    self.backgroundColor = KNB_NAV_COLOR;
    [self addSubview:self.leftNaviButton];
    [self addSubview:self.titleNaviLabel];
    [self addSubview:self.rightNaviButton];
    [self addSubview:self.lineView];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    if (CGColorEqualToColor(backgroundColor.CGColor, [UIColor clearColor].CGColor)) {
        self.lineView.backgroundColor = backgroundColor;
    }
}

#pragma mark - Setting
- (void)addLeftBarItemTitle:(NSString *)title {
    CGFloat titleWidth = [title widthWithFont:[UIFont systemFontOfSize:18] constrainedToHeight:44];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitle:title forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(40, KNB_StatusBar_H, titleWidth + 4, 44);
    [self addSubview:leftButton];
}

- (void)addRightBarItemTitle:(NSString *)title {
    [_rightNaviButton setTitle:title forState:UIControlStateNormal];
}

- (void)addRightBarItemTitle:(NSString *)title target:(id)target sel:(SEL)sel {
    [_rightNaviButton setTitle:title forState:UIControlStateNormal];
    [_rightNaviButton addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
}

- (void)addLeftBarItemImageName:(NSString *)imgName {
    [_leftNaviButton setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
}

- (void)addRightBarItemImageName:(NSString *)imgName {
    [_rightNaviButton setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
}

- (void)addRightBarItemImageName:(NSString *)imgName target:(id)target sel:(SEL)sel {
    [_rightNaviButton setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [_rightNaviButton addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
}

- (void)addLeftBarItemImageName:(NSString *)imgName target:(id)target sel:(SEL)sel {
    [_leftNaviButton setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    [_leftNaviButton addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
}

- (void)removeLeftBarItem {
    [_leftNaviButton removeFromSuperview];
}

- (void)setTitle:(NSString *)aTitle {
    _title = aTitle;
    self.titleNaviLabel.text = aTitle;
}


#pragma mark - Setter
- (UIButton *)leftNaviButton {
    if (!_leftNaviButton) {
        _leftNaviButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftNaviButton.frame = CGRectMake(0, KNB_StatusBar_H, 40, 44);
        [_leftNaviButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _leftNaviButton;
}

- (UILabel *)titleNaviLabel {
    if (!_titleNaviLabel) {
        _titleNaviLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, KNB_StatusBar_H, KNB_SCREEN_WIDTH - 120, 44)];
        _titleNaviLabel.textColor = [UIColor blackColor];
        _titleNaviLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleNaviLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleNaviLabel;
}

- (UIButton *)rightNaviButton {
    if (!_rightNaviButton) {
        _rightNaviButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightNaviButton.frame = CGRectMake(KNB_SCREEN_WIDTH - 65, KNB_StatusBar_H, 65, 44);
        [_rightNaviButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rightNaviButton.titleLabel.textAlignment = NSTextAlignmentRight;
        _rightNaviButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _rightNaviButton;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
        _lineView.frame = CGRectMake(0, KNB_NAV_HEIGHT - 1, KNB_SCREEN_WIDTH, 1);
    }
    return _lineView;
}

@end
