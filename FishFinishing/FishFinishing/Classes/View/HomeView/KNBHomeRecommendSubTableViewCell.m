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
#import "KNBHomeDesignViewController.h"
#import "KNBHomeWorkerViewController.h"
#import "KNBDesignSketchDetailViewController.h"
#import "NSString+Size.h"

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
@property (weak, nonatomic) IBOutlet UIImageView *mobileImageView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftCase;
@property (weak, nonatomic) IBOutlet UIImageView *middleCase;
@property (weak, nonatomic) IBOutlet UIImageView *rightCase;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *maxSpace;

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
    
    if ([self.model.parent_cat_name isEqualToString:@"设计师"]) {
        KNBHomeDesignViewController *designVC = [[KNBHomeDesignViewController alloc] init];
        designVC.faceId = [self.model.serviceId integerValue];
        UIViewController *vc = [KNBHomeRecommendSubTableViewCell currentViewController];
        [vc.navigationController pushViewController:designVC animated:YES];
    } else if ([self.model.parent_cat_name isEqualToString:@"装修工人"] || [self.model.parent_cat_name isEqualToString:@"装修工长"]) {
        KNBHomeWorkerViewController *workerVC = [[KNBHomeWorkerViewController alloc] init];
        workerVC.faceId = [self.model.serviceId integerValue];
        UIViewController *vc = [KNBHomeRecommendSubTableViewCell currentViewController];
        [vc.navigationController pushViewController:workerVC animated:YES];
    } else {
        KNBHomeOfferViewController *offerVC = [[KNBHomeOfferViewController alloc] init];
        offerVC.faceId = [self.model.serviceId integerValue];
        UIViewController *vc = [KNBHomeRecommendSubTableViewCell currentViewController];
        [vc.navigationController pushViewController:offerVC animated:YES];
    }


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

- (IBAction)leftCaseButtonAction:(id)sender {
    if (self.model.caseList.count > 0) {
        KNBHomeServiceModel *caseModel = self.model.caseList[0];
        KNBDesignSketchModel *model  = [[KNBDesignSketchModel alloc] init];
        model.caseId = caseModel.serviceId;
        model.name = self.model.name;
        model.img = self.model.logo;
        KNBDesignSketchDetailViewController *detailVC = [[KNBDesignSketchDetailViewController alloc] init];
        detailVC.model = model;
        UIViewController *vc = [KNBHomeRecommendSubTableViewCell currentViewController];
        [vc.navigationController pushViewController:detailVC animated:YES];
    }
}

- (IBAction)middleCaseButtonAction:(id)sender {
    if (self.model.caseList.count > 1) {
        KNBHomeServiceModel *caseModel = self.model.caseList[1];
        KNBDesignSketchModel *model  = [[KNBDesignSketchModel alloc] init];
        model.caseId = caseModel.serviceId;
        model.name = self.model.name;
        model.img = self.model.logo;
        KNBDesignSketchDetailViewController *detailVC = [[KNBDesignSketchDetailViewController alloc] init];
        detailVC.model = model;
        UIViewController *vc = [KNBHomeRecommendSubTableViewCell currentViewController];
        [vc.navigationController pushViewController:detailVC animated:YES];
    }

}

- (IBAction)rightCaseButtonAction:(id)sender {
    if (self.model.caseList.count > 2) {
        KNBHomeServiceModel *caseModel = self.model.caseList[2];
        KNBDesignSketchModel *model  = [[KNBDesignSketchModel alloc] init];
        model.caseId = caseModel.serviceId;
        model.name = self.model.name;
        model.img = self.model.logo;
        KNBDesignSketchDetailViewController *detailVC = [[KNBDesignSketchDetailViewController alloc] init];
        detailVC.model = model;
        UIViewController *vc = [KNBHomeRecommendSubTableViewCell currentViewController];
        [vc.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark - private method
+ (CGFloat)cellHeight {
    return 205;
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
        tagView.tagBackgroundColor = [UIColor colorWithHex:0xf2f2f2];
        tagView.lineSpacing = 7;
        tagView.interitemSpacing = 5;
        tagView.tagFont = KNBFont(11);
        tagView.tagTextColor = [UIColor colorWithHex:0x737373];
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
    
    CGFloat distanceWidth = [distance widthWithFont:[UIFont systemFontOfSize:11] constrainedToHeight:12];
    
    //计算名称最大长度
    self.maxSpace.constant = KNB_SCREEN_WIDTH - 158 - distanceWidth;
    
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
    
    if ([model.parent_cat_name containsString:@"设计"]) {
        [self.orderButton setTitle:@"预约设计" forState:UIControlStateNormal];
    }
    
    if ([model.parent_cat_name containsString:@"家居"] || [model.parent_cat_name containsString:@"建材"]) {
        self.orderButton.hidden = YES;
    } else {
        self.orderButton.hidden = NO;
    }

    if ([model.is_stick isEqualToString:@"0"]) {
        self.topImageView.hidden = YES;
    } else {
        self.topImageView.hidden = NO;
    }
    
    
}

@end
