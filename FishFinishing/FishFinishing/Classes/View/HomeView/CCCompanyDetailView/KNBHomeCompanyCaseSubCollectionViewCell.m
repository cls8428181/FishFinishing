//
//  KNBHomeCompanyCaseSubCollectionViewCell.m
//  FishFinishing
//
//  Created by apple on 2019/4/19.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBHomeCompanyCaseSubCollectionViewCell.h"
#import "NSDate+BTAddition.h"
#import "KNBRecruitmentShowApi.h"

@interface KNBHomeCompanyCaseSubCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *showButton;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation KNBHomeCompanyCaseSubCollectionViewCell
#pragma mark - life cycle
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"KNBHomeCompanyCaseSubCollectionViewCell";
    KNBHomeCompanyCaseSubCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"KNBHomeCompanyCaseSubCollectionViewCell" owner:self options:nil].lastObject;
    }
    return self;
}

#pragma mark - private method
+ (CGFloat)cellHeight {
    return 160;
}

- (IBAction)deleteButtonAction:(id)sender {
    !self.deleteButtonBlock ?: self.deleteButtonBlock();
}

- (IBAction)showButtonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.isSelected) {
        KNBRecruitmentShowApi *api = [[KNBRecruitmentShowApi alloc] initWithCaseId:[self.model.serviceId integerValue] isRecommend:0];
        api.hudString = @"";
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
            if (api.requestSuccess) {
                button.selected = NO;
            } else {
                [LCProgressHUD showMessage:api.errMessage];
            }
        } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
            [LCProgressHUD showMessage:api.errMessage];
        }];
    } else {
        KNBRecruitmentShowApi *api = [[KNBRecruitmentShowApi alloc] initWithCaseId:[self.model.serviceId integerValue] isRecommend:1];
        api.hudString = @"";
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
            if (api.requestSuccess) {
                button.selected = YES;
            } else {
                [LCProgressHUD showMessage:api.errMessage];
            }
        } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
            [LCProgressHUD showMessage:api.errMessage];
        }];
    }
}

- (void)setModel:(KNBHomeServiceModel *)model {
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:CCPortraitPlaceHolder];
    self.titleLabel.text = model.title;
    if (self.isProduct) {
        self.detailLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    } else {
        self.detailLabel.text = [NSString stringWithFormat:@"%@/%@㎡/%@",model.apart_name ?: @"无",model.acreage ?: @"0",model.style_name ?: @"无"];
    }
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 5;
    if ([model.is_recommend isEqualToString:@"1"]) {
        self.showButton.selected = YES;
    } else {
        self.showButton.selected = NO;
    }
}

- (void)setServiceName:(NSString *)name ServiceIcon:(NSString *)icon {
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:CCPortraitPlaceHolder];
    self.nameLabel.text = name;
}

- (void)setIsEdit:(BOOL)isEdit {
    self.deleteButton.hidden = !isEdit;
    self.showButton.hidden = !isEdit;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.borderColor = [UIColor colorWithHex:0xe6e6e6].CGColor;
    self.bgView.layer.borderWidth = 1;
}
@end
