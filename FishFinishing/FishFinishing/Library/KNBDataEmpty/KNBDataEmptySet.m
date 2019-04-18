//
//  KNBDataEmptySet.m
//  KenuoTraining
//
//  Created by Robert on 16/4/7.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "KNBDataEmptySet.h"
#import "UIColor+Hex.h"


@interface KNBDataEmptySet ()

@property (nonatomic, strong) UILabel *noticeLabel;

@property (nonatomic, strong) UIImageView *noticeImageView;

@property (nonatomic, strong) UILabel *subNoticeLabel;

@end


@implementation KNBDataEmptySet

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, 155, 155)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.hidden = YES;
        [self configureViews];
    }
    return self;
}

- (void)configureViews {
    [self addSubview:self.noticeLabel];
    [self addSubview:self.noticeImageView];
    [self addSubview:self.subNoticeLabel];
    self.center = CGPointMake(KNB_SCREEN_WIDTH / 2, KNB_SCREEN_HEIGHT / 2);
}


#pragma mark - MasonryKNBDataEmptySet
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    KNB_WS(weakSelf);

    [_noticeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.mas_centerY).offset(-10);
    }];

    [_noticeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.noticeImageView.mas_bottom).offset(15);
        make.centerX.mas_equalTo(weakSelf.noticeImageView.mas_centerX);
        make.width.mas_equalTo(weakSelf.width);
    }];

    [_subNoticeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.noticeLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(weakSelf.noticeImageView.mas_centerX);
        make.width.mas_equalTo(KNB_SCREEN_WIDTH - 48);
    }];

    [super updateConstraints];
}

#pragma mark - Getter && Setter

- (UILabel *)noticeLabel {
    if (!_noticeLabel) {
        _noticeLabel = [[UILabel alloc] init];
        _noticeLabel.font = KNB_FONT_SIZE_DEFAULT(15);
        _noticeLabel.textColor = [UIColor knBlackColor];
        _noticeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noticeLabel;
}

- (UILabel *)subNoticeLabel {
    if (!_subNoticeLabel) {
        _subNoticeLabel = [[UILabel alloc] init];
        _subNoticeLabel.font = KNB_FONT_SIZE_DEFAULT(12);
        _subNoticeLabel.textAlignment = NSTextAlignmentCenter;
        _subNoticeLabel.textColor = KNB_RGBA(0, 0, 0, 0.8);
        _subNoticeLabel.numberOfLines = 3;
    }
    return _subNoticeLabel;
}

- (UIImageView *)noticeImageView {
    if (!_noticeImageView) {
        _noticeImageView = [[UIImageView alloc] init];
        _noticeImageView.image = [UIImage imageNamed:@"emptyNotice_img"];
    }
    return _noticeImageView;
}

- (void)setNoticeString:(NSString *)noticeString {
    _noticeString = noticeString;
    self.noticeLabel.text = _noticeString;
}

- (void)setSubNoticeString:(NSString *)subNoticeString {
    _subNoticeString = subNoticeString;
    self.subNoticeLabel.text = _subNoticeString;
}

- (void)setNoticeImage:(UIImage *)noticeImage {
    _noticeImage = noticeImage;
    self.noticeImageView.image = _noticeImage;
}

- (void)setNoticeStringColor:(UIColor *)color {
    self.noticeLabel.textColor = color;
}

- (void)setNoticeStringTop:(CGFloat)top {
    self.noticeLabel.top = top;
}

- (void)setViewHidden:(BOOL)viewHidden{
    _viewHidden = viewHidden;
    if (viewHidden) {
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             self.hidden = YES;
                         }];
    }else{
        self.hidden = NO;
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.alpha = 1.0;
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    if (_dataArray && _dataArray.count != 0) {
        [UIView animateWithDuration:0.2
            animations:^{
                self.alpha = 0.0;
            }
            completion:^(BOOL finished) {
                self.hidden = YES;
            }];
    } else {
        self.hidden = NO;
        [UIView animateWithDuration:0.2
            animations:^{
                self.alpha = 1.0;
            }
            completion:^(BOOL finished){

            }];
    }
}

- (void)setDataCount:(NSInteger)count {
    if (count != 0) {
        [UIView animateWithDuration:0.2
            animations:^{
                self.alpha = 0.0;
            }
            completion:^(BOOL finished) {
                self.hidden = YES;
            }];
    } else {
        self.hidden = NO;
        [UIView animateWithDuration:0.2
            animations:^{
                self.alpha = 1.0;
            }
            completion:^(BOOL finished){

            }];
    }
}

@end
