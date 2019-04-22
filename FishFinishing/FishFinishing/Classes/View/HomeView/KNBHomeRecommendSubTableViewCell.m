//
//  KNBHomeRecommendSubTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/27.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeRecommendSubTableViewCell.h"
#import "FMTagsView.h"
#import "KNBHomeOfferViewController.h"

@interface KNBHomeRecommendSubTableViewCell ()
//标签背景
@property (weak, nonatomic) IBOutlet UIView *tagBgView;
//标签视图
@property (nonatomic, strong) FMTagsView *tagView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *certImageView;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property (weak, nonatomic) IBOutlet UIButton *mobileButton;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftCase;
@property (weak, nonatomic) IBOutlet UIImageView *middleCase;
@property (weak, nonatomic) IBOutlet UIImageView *rightCase;

@end

@implementation KNBHomeRecommendSubTableViewCell

#pragma mark - life cycle
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBHomeRecommendSubTableViewCell";
    KNBHomeRecommendSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    KNB_WS(weakSelf);
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.tagBgView);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.tagBgView addSubview:self.tagView];
}

+ (UIViewController *)currentViewController {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIViewController *currentVC = window.rootViewController;
    while (currentVC.presentedViewController) {
        currentVC = currentVC.presentedViewController;
    }
    if ([currentVC isKindOfClass:[UINavigationController class]]) {
        currentVC = [(UINavigationController *)currentVC topViewController];
    }
    return currentVC;
}

- (IBAction)orderButtonAction:(id)sender {
    KNBHomeOfferViewController *offerVC  = [[KNBHomeOfferViewController alloc] init];
    UIViewController *vc = [KNBHomeRecommendSubTableViewCell currentViewController];
    [vc.navigationController pushViewController:offerVC animated:YES];
}

- (IBAction)mobileButtonAction:(id)sender {
    NSString *telephoneNumber = self.model.telephone;
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",telephoneNumber];
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:str];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        //OpenSuccess = 选择 呼叫 为 1  选择 取消 为0
        NSLog(@"OpenSuccess=%d",success);
        
    }];
}

#pragma mark - private method
+ (CGFloat)cellHeight {
    return 195;
}

#pragma mark - lazy load
- (FMTagsView *)tagView {
    if (!_tagView) {
        FMTagsView *tagView = [[FMTagsView alloc] init];
        tagView.contentInsets = UIEdgeInsetsZero;
        tagView.tagInsets = UIEdgeInsetsMake(0.5, 8.5, 0.5, 9);
        tagView.contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        tagView.tagBorderWidth = 0.5;
        tagView.tagcornerRadius = 10;
        tagView.tagBorderColor = [UIColor colorWithHex:0xebebeb];
        tagView.tagSelectedBorderColor = [UIColor colorWithHex:0xebebeb];
        tagView.tagBackgroundColor = [UIColor colorWithHex:0xfafafa];
        tagView.lineSpacing = 7;
        tagView.interitemSpacing = 5;
        tagView.tagFont = KNBFont(11);
        tagView.tagTextColor = [UIColor colorWithHex:0x666666];
        tagView.allowsSelection = NO;
        tagView.collectionView.scrollEnabled = NO;
        tagView.collectionView.showsVerticalScrollIndicator = NO;
        _tagView = tagView;
    }
    return _tagView;
}

- (void)setModel:(KNBHomeServiceModel *)model {
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.logo]];
    self.nameLabel.text = model.name;
    self.addressLabel.text = model.address;
    
    NSString *distance = @"";
    if ([model.distance integerValue] > 1000) {
        distance = [NSString stringWithFormat:@"%ld km",[model.distance integerValue] / 1000];
    } else {
        distance = [NSString stringWithFormat:@"%ld m",[model.distance integerValue]];
    }
    self.distanceLabel.text = distance;
    NSArray *tagsArray = [model.tag componentsSeparatedByString:@","];
    self.tagView.tagsArray = tagsArray;
    for (int i = 0 ; i < model.caseList.count; i++) {
        KNBHomeServiceModel *caseModel = model.caseList[i];
        if (i == 0) {
            [self.leftCase sd_setImageWithURL:[NSURL URLWithString:caseModel.img] placeholderImage:KNBImages(@"knb_default_case")];
        }
        if (i == 1) {
            [self.middleCase sd_setImageWithURL:[NSURL URLWithString:caseModel.img] placeholderImage:KNBImages(@"knb_default_case")];
        }
        if (i == 2) {
            [self.rightCase sd_setImageWithURL:[NSURL URLWithString:caseModel.img] placeholderImage:KNBImages(@"knb_default_case")];
        }
    }
}
@end
