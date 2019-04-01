//
//  KNBHomeDoctorSubCell.m
//  KNMedicalBeauty
//
//  Created by LSQ on 2017/12/29.
//  Copyright © 2017年 idengyun. All rights reserved.
//

#import "KNBHomeDoctorSubCell.h"


@interface KNBHomeDoctorSubCell ()
//头像
@property (nonatomic, strong) UIImageView *headImage;
//名字工作
@property (nonatomic, strong) UILabel *nameLabel;
//擅长
@property (nonatomic, strong) UILabel *majorLabel;
//分割线
@property (nonatomic, strong) UIView *sepLineView;
//更多按钮
@property (nonatomic, strong) UIButton *showMoreButton;

@end

@implementation KNBHomeDoctorSubCell

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.headImage];
        [self.contentView addSubview:self.sepLineView];
        [self.contentView addSubview:self.majorLabel];
        [self.contentView addSubview:self.showMoreButton];
        [self.contentView setNeedsUpdateConstraints];

        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.shadowOpacity = 0.2;                           // 阴影透明度
        self.contentView.layer.shadowColor = [UIColor grayColor].CGColor; // 阴影的颜色
        self.contentView.layer.shadowRadius = 2;                              // 阴影扩散的范围控制
        self.contentView.layer.shadowOffset = CGSizeMake(0, 0);               // 阴影的范围
        self.contentView.layer.shouldRasterize = YES;                         //设置缓存
        //设置抗锯齿边缘
        self.contentView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    }
    return self;
}

#pragma mark - Event Response
- (void)showMoreButtonClickAction:(UIButton *)sender {

}

#pragma mark - Private Method
- (void)showMoreDoctorView {
    self.showMoreButton.hidden = NO;
}

- (void)dismissMoreDoctorView {
    self.showMoreButton.hidden = YES;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}
//布局约束
- (void)updateConstraints {
    [self.headImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.width.and.height.mas_equalTo(45);
        make.centerX.mas_equalTo(self.contentView);
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImage.mas_bottom).offset(10);
        make.width.mas_equalTo(120.5);
        make.height.mas_equalTo(20);
        make.centerX.mas_equalTo(self.contentView);
    }];
    [self.sepLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10.5);
        make.width.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    [self.majorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(6.5);
        make.top.mas_equalTo(self.sepLineView.mas_bottom).offset(7);
        make.right.mas_equalTo(self).offset(-6.5);
    }];
    [self.showMoreButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [super updateConstraints];
}

#pragma mark - Getters And Setters
- (UIImageView *)headImage {
    if (!_headImage) {
        _headImage = [[UIImageView alloc] init];
        _headImage.image = [UIImage imageNamed:@"1_selected"];
        _headImage.layer.cornerRadius = 22.5;
        _headImage.layer.masksToBounds = YES;
    }
    return _headImage;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:12]; //12 + 10 两种
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.backgroundColor = [UIColor grayColor];
        _nameLabel.layer.cornerRadius = 10;
        _nameLabel.layer.masksToBounds = YES;
    }
    return _nameLabel;
}

- (UIView *)sepLineView {
    if (!_sepLineView) {
        _sepLineView = [[UIView alloc] init];
        _sepLineView.backgroundColor = [UIColor grayColor];
    }
    return _sepLineView;
}

- (UILabel *)majorLabel {
    if (!_majorLabel) {
        _majorLabel = [[UILabel alloc] init];
        _majorLabel.textColor = [UIColor grayColor];
        _majorLabel.font = [UIFont systemFontOfSize:12]; //12 + 10 两种
        _majorLabel.textAlignment = NSTextAlignmentCenter;
        _majorLabel.numberOfLines = 2;
    }
    return _majorLabel;
}

- (UIButton *)showMoreButton {
    if (!_showMoreButton) {
        _showMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showMoreButton setTitle:@"查看更多" forState:UIControlStateNormal];
        [_showMoreButton setImage:[UIImage imageNamed:@"1_selected"] forState:UIControlStateNormal];
        _showMoreButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _showMoreButton.layer.cornerRadius = 2.5;
        _showMoreButton.layer.masksToBounds = YES;
        _showMoreButton.titleEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 13);
        _showMoreButton.imageEdgeInsets = UIEdgeInsetsMake(0, 59.5, 0, -59.5);
        [_showMoreButton addTarget:self action:@selector(showMoreButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _showMoreButton.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
    }
    return _showMoreButton;
}
@end
