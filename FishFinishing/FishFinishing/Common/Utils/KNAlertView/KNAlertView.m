//
//  KNAlertView.m
//  Concubine
//
//  Created by ... on 16/6/21.
//  Copyright © 2016年 dengyun. All rights reserved.
//

#import "KNAlertView.h"
#import "CustomIOSAlertView.h"


@interface KNAlertView ()

@property (nonatomic, strong) UILabel *remidLabel;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) CustomIOSAlertView *alterView;

@end


@implementation KNAlertView

- (instancetype)initAlterTitle:(NSString *)title {
    self = [super init];
    if (self) {
        self.title = title;
        self.buttonsTitle = @[ @"不了", @"确定" ];
        [self configureView];
    }
    return self;
}

- (void)configureView {
    _alterView = [[CustomIOSAlertView alloc] init];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self view_width], 100)];
    [bgView addSubview:self.remidLabel];
    [_alterView setContainerView:bgView];
    [_alterView setButtonTitles:self.buttonsTitle];
    [_alterView setUseMotionEffects:true];

    __block KNAlertView *blockView = self;
    [self.alterView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        [blockView selectIndex:buttonIndex];
    }];
}

- (void)selectIndex:(NSInteger)index {
    [self.alterView close];
    _alterView = nil;
    if (self.alterBlock) {
        self.alterBlock(index);
    }
}

- (void)showAlterView {
    [_alterView show];
}

#pragma mark - Getting && Setting
- (void)setTitle:(NSString *)aTitle {
    if (_title != aTitle) {
        _title = aTitle;
        self.remidLabel.text = aTitle;
    }
}

- (void)setButtonsTitle:(NSArray *)aButtonsTitle {
    if (_buttonsTitle != aButtonsTitle) {
        _buttonsTitle = aButtonsTitle;
        [self.alterView setButtonTitles:aButtonsTitle];
    }
}

- (void)setAttributedString:(NSAttributedString *)aAttributedString {
    if (_attributedString != aAttributedString) {
        _attributedString = aAttributedString;
        if (self.title == nil) {
            self.remidLabel.attributedText = aAttributedString;
        }
    }
}

- (UILabel *)remidLabel {
    if (!_remidLabel) {
        CGFloat kWidth = [self view_width];
        _remidLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kWidth - 30, 80)];
        _remidLabel.font = [UIFont systemFontOfSize:16.0];
        _remidLabel.textAlignment = NSTextAlignmentCenter;
        _remidLabel.textColor = [UIColor knMainColor];
        _remidLabel.numberOfLines = 2;
    }
    return _remidLabel;
}

- (CGFloat)view_width {
    return [UIScreen mainScreen].bounds.size.width * 0.8;
}

@end
