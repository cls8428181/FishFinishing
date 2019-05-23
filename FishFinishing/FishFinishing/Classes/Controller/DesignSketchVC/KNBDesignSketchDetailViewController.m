//
//  KNBDesignSketchDetailViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/30.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBDesignSketchDetailViewController.h"
#import "RFPhotoScrollerView.h"
#import "KNBRecruitmentCaseDetailApi.h"
#import "KNBLoginViewController.h"
#import "KNBOrderViewController.h"
#import "NSString+Size.h"
#import "KNBHomeCompanyDetailViewController.h"
#import "KNBHomeOfferViewController.h"
#import "KNBHomeDesignViewController.h"
#import "KNBHomeWorkerViewController.h"

@interface KNBDesignSketchDetailViewController ()
//返回按钮
@property (nonatomic, strong) UIButton *backButton;
//分享按钮
@property (nonatomic, strong) UIButton *shareButton;
//大图
@property (nonatomic, strong) RFPhotoScrollerView *scrollerView;
//标题
@property (nonatomic, strong) UILabel *titleLabel;
//风格
@property (nonatomic, strong) UILabel *styleLabel;
//户型
@property (nonatomic, strong) UILabel *houseLabel;
//面积
@property (nonatomic, strong) UILabel *areaLabel;
//简介
@property (nonatomic, strong) UILabel *contentLabel;
//预约免费设计服务
@property (nonatomic, strong) UIView *bottomBgView;
@property (nonatomic, strong) UIButton *iconButton;
@property (nonatomic, strong) UILabel *leftLabel;
//立即报价
@property (nonatomic, strong) UIButton *enterButton;
//图片数组
@property (nonatomic, strong) NSArray *photosArray;
@end

@implementation KNBDesignSketchDetailViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configuration];
    
    [self addUI];
    
    [self settingConstraints];
    
    [self fetchData];
}

#pragma mark - Setup UI Constraints
/*
 *  在这里添加UIView的约束布局相关代码
 */
- (void)settingConstraints {
    KNB_WS(weakSelf);
    [self.iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).mas_offset(20);
        make.top.mas_equalTo(KNB_SCREEN_HEIGHT - KNB_TAB_HEIGHT + 10);
        make.height.mas_equalTo(38);
        make.width.mas_equalTo(38);
    }];
    CGFloat space = (KNB_SCREEN_WIDTH - 326)/2;
    [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(185 + space*2);
        make.centerY.equalTo(weakSelf.iconButton);
        make.height.mas_equalTo(34);
        make.width.mas_equalTo(128);
    }];
    _leftLabel.frame = CGRectMake(68, KNB_SCREEN_HEIGHT - KNB_TAB_HEIGHT + 10, 38, 38);

    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(68);
        make.centerY.equalTo(weakSelf.iconButton);
        make.right.equalTo(weakSelf.enterButton.mas_left).mas_offset(-10);
    }];
}

#pragma mark - Utils
- (void)configuration {
    [self.naviView removeFromSuperview];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)addUI {
    [self.view addSubview:self.bottomBgView];
    [self.view addSubview:self.iconButton];
    [self.view addSubview:self.leftLabel];
    [self.view addSubview:self.enterButton];
}

- (void)fetchData {
    KNBRecruitmentCaseDetailApi *api = [[KNBRecruitmentCaseDetailApi alloc] initWithCaseId:[self.model.caseId integerValue]];
    api.hudString = @"";
    KNB_WS(weakSelf);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            NSDictionary *dic = request.responseObject[@"list"];
            KNBDesignSketchModel *model = [KNBDesignSketchModel changeResponseJSONObject:dic];
            weakSelf.titleLabel.text = model.title;
            if ([model.parent_cat_name containsString:@"家居"] || [model.parent_cat_name containsString:@"建材"]) {
                weakSelf.styleLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
            } else {
                weakSelf.styleLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@㎡",model.apart_name ?: @"无",model.style_name ?: @"无",model.acreage ?: @"无"];
            }
            weakSelf.contentLabel.text = model.remark ?: @"暂无简介信息";
            weakSelf.enterButton.tag = [model.telephone integerValue];
            weakSelf.leftLabel.text = model.name;
            [weakSelf.iconButton sd_setImageWithURL:[NSURL URLWithString:isNullStr(model.logo) ? model.img : model.logo] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                UIImage *refined = [UIImage imageWithCGImage:image.CGImage scale:3 orientation:image.imageOrientation];
                [self->_iconButton setImage:refined forState:UIControlStateNormal];
            }];
            weakSelf.model = model;
            NSMutableArray *imgsArray = [NSMutableArray array];
            NSArray *tempArray = dic[@"imgs"];
            for (NSString *string in tempArray) {
                [imgsArray addObject:string];
            }
            weakSelf.photosArray = imgsArray;
            [weakSelf settingUI];
            [weakSelf settingLayout];
        } else {
            [weakSelf requestSuccess:NO requestEnd:NO];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [weakSelf requestSuccess:NO requestEnd:NO];
    }];
}

- (void)settingUI {
    [self.view addSubview:self.scrollerView];
    [self.view addSubview:self.contentLabel];
    [self.view addSubview:self.styleLabel];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.shareButton];
}

- (void)settingLayout {
    KNB_WS(weakSelf);
    CGFloat contentHeight = [weakSelf.contentLabel.text heightWithFont:KNBFont(12) constrainedToWidth:KNB_SCREEN_WIDTH - 24];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.enterButton.mas_top).mas_offset(-24);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(contentHeight);
    }];
    CGFloat styleHeight = [weakSelf.styleLabel.text heightWithFont:KNBFont(12) constrainedToWidth:KNB_SCREEN_WIDTH - 24];
    [self.styleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentLabel.mas_top).mas_offset(-10);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(styleHeight);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.styleLabel.mas_top).mas_offset(-20);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(35);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(35);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];

}

#pragma mark - Event Response
/*
 *  所有button、gestureRecognizer的响应事件都放在这个区域里面，不要到处乱放。
 */
- (void)backButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareButtonAction {
    NSString *imgUrl = self.photosArray[self.scrollerView.currentIndex];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString:imgUrl]]];
    NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:self.titleLabel.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25]}];
    NSAttributedString *styleString = [[NSAttributedString alloc] initWithString:self.styleLabel.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    NSAttributedString *remarkString = [[NSAttributedString alloc] initWithString:self.contentLabel.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    
    UIImage *shareImage = [self combine:image title:titleString style:styleString remark:remarkString];
    NSString *name = @"效果图详情";
    NSString *describeStr = @"这是效果图详情";
    [self shareImageWithMessages:@[name , describeStr] image:shareImage shareButtonBlock:^(NSInteger platformType, BOOL success) {
        
    }];
}

- (void)iconButtonAction {
    KNBHomeServiceModel *model = [[KNBHomeServiceModel alloc] init];
    model.serviceId = self.model.facilitator_id;
    KNBHomeCompanyDetailViewController *detailVC = [[KNBHomeCompanyDetailViewController alloc] init];
    detailVC.isEdit = NO;
    detailVC.model = model;
    detailVC.naviView.title = self.naviView.title;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)offerButtonAction:(UIButton *)button {
    KNB_WS(weakSelf);
    if ([KNBUserInfo shareInstance].isLogin) {
        if ([button.titleLabel.text isEqualToString:@"立即报价"]) {
            KNBOrderViewController *orderVC = [[KNBOrderViewController alloc] init];
            orderVC.VCType = KNBOrderVCTypeOrderFinishing;
            orderVC.isExperience = NO;
            orderVC.isStyleEnable = NO;
            orderVC.model = self.model;
            [self.navigationController pushViewController:orderVC animated:YES];
        } else {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%ld",(long)button.tag];
            UIApplication *application = [UIApplication sharedApplication];
            NSURL *URL = [NSURL URLWithString:str];
            [application openURL:URL options:@{} completionHandler:^(BOOL success) {
                //OpenSuccess = 选择 呼叫 为 1  选择 取消 为0
                NSLog(@"OpenSuccess=%d",success);
                
            }];
        }
    } else {
        [KNBAlertRemind alterWithTitle:@"" message:@"您还未登录,请先登录" buttonTitles:@[@"去登录",@"取消"] handler:^(NSInteger index, NSString *title) {
            if ([title isEqualToString:@"去登录"]) {
                KNBLoginViewController *loginVC = [[KNBLoginViewController alloc] init];
                loginVC.vcType = KNBLoginTypeLogin;
                [weakSelf presentViewController:loginVC animated:YES completion:nil];
            }
        }];
    }
}

- (void)enterButtonAction:(UIButton *)button {
    KNB_WS(weakSelf);
    if ([KNBUserInfo shareInstance].isLogin) {
        
        if ([self.model.parent_cat_name containsString:@"设计师"]) {
            KNBHomeDesignViewController *designVC = [[KNBHomeDesignViewController alloc] init];
            designVC.faceId = [self.model.facilitator_id integerValue];
            [self.navigationController pushViewController:designVC animated:YES];
        } else if ([self.model.parent_cat_name containsString:@"工人"] || [self.model.parent_cat_name containsString:@"工长"]) {
            KNBHomeWorkerViewController *workerVC = [[KNBHomeWorkerViewController alloc] init];
            workerVC.faceId = [self.model.facilitator_id integerValue];
            [self.navigationController pushViewController:workerVC animated:YES];
        } else {
            KNBHomeOfferViewController *offerVC = [[KNBHomeOfferViewController alloc] init];
            offerVC.faceId = [self.model.facilitator_id integerValue];
            [self.navigationController pushViewController:offerVC animated:YES];
        }
        
    } else {
        [KNBAlertRemind alterWithTitle:@"" message:@"您还未登录,请先登录" buttonTitles:@[@"去登录",@"取消"] handler:^(NSInteger index, NSString *title) {
            if ([title isEqualToString:@"去登录"]) {
                KNBLoginViewController *loginVC = [[KNBLoginViewController alloc] init];
                loginVC.vcType = KNBLoginTypeLogin;
                [weakSelf presentViewController:loginVC animated:YES completion:nil];
            }
        }];
    }
}

#pragma mark 合并图片
- (UIImage *)combine:(UIImage *)image title:(NSAttributedString *)title style:(NSAttributedString *)style remark:(NSAttributedString *)remark {
    //计算画布大小
    CGFloat width = image.size.width;
    CGFloat titleHeight = [title.string heightWithFont:KNBFont(25) constrainedToWidth:width - 26];
    CGFloat styleHeight = [style.string heightWithFont:KNBFont(20) constrainedToWidth:width - 26];
    CGFloat remarkHeight = [remark.string heightWithFont:KNBFont(20) constrainedToWidth:width - 26];
    CGFloat height = image.size.height + titleHeight + styleHeight + remarkHeight + 55;

    CGSize resultSize = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(resultSize);
    
    //图片
    CGRect imageRect = CGRectMake(0, 0, resultSize.width, image.size.height);
    [image drawInRect:imageRect];
    
    //标题
    CGRect titleRect = CGRectMake(13, image.size.height + 15, resultSize.width - 26, titleHeight);
    [title drawInRect:titleRect];
    
    //风格
    CGRect styleRect = CGRectMake(13, image.size.height + 60, resultSize.width - 26, styleHeight);
    [style drawInRect:styleRect];
    
    //简介
    CGRect remarkRect = CGRectMake(13, image.size.height + 85, resultSize.width - 26, remarkHeight);
    [remark drawInRect:remarkRect];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

#pragma mark - Getters And Setters
/* getter和setter全部都放在最后*/
- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:KNBImages(@"knb_design_back") forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setImage:KNBImages(@"knb_design_share") forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

- (RFPhotoScrollerView *)scrollerView {
    if (!_scrollerView) {
        _scrollerView = [[RFPhotoScrollerView alloc]initWithImagesArray:self.photosArray currentIndex:0 frame:CGRectMake(0, 0, KNB_SCREEN_WIDTH, KNB_SCREEN_HEIGHT - KNB_TAB_HEIGHT)];
    }
    return _scrollerView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = KNBFont(15);
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)styleLabel {
    if (!_styleLabel) {
        _styleLabel = [[UILabel alloc] init];
        _styleLabel.textColor = [UIColor whiteColor];
        _styleLabel.font = KNBFont(12);
        _styleLabel.numberOfLines = 0;
    }
    return _styleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = KNBFont(12);
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIView *)bottomBgView {
    if (!_bottomBgView) {
        _bottomBgView = [[UIView alloc] init];
        _bottomBgView.frame = CGRectMake(0, KNB_SCREEN_HEIGHT - KNB_TAB_HEIGHT, KNB_SCREEN_WIDTH, KNB_TAB_HEIGHT);
        _bottomBgView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomBgView;
}

- (UIButton *)iconButton {
    if (!_iconButton) {
        _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconButton.layer.masksToBounds = YES;
        _iconButton.layer.cornerRadius = 19;
        [_iconButton addTarget:self action:@selector(iconButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _iconButton;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = [UIFont systemFontOfSize:14];
        _leftLabel.textColor = [UIColor kn333333Color];
    }
    return _leftLabel;
}

- (UIButton *)enterButton {
    if (!_enterButton) {
        _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterButton setTitle:@"立即报价" forState:UIControlStateNormal];
        [_enterButton addTarget:self action:@selector(enterButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _enterButton.layer.masksToBounds = YES;
        _enterButton.layer.cornerRadius = 17;
        [_enterButton setBackgroundColor:[UIColor knf5701bColor]];
    }
    return _enterButton;
}

- (void)setModel:(KNBDesignSketchModel *)model {
    _model = model;
//    if ([model.parent_cat_name containsString:@"家居"] || [model.parent_cat_name containsString:@"建材"]) {
//        [_enterButton setTitle:@"立即联系" forState:UIControlStateNormal];
//        _enterButton.tag = [model.telephone integerValue];
//    }
}

@end
