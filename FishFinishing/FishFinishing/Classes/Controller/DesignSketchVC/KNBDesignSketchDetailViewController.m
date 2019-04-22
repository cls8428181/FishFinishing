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
#import "KNBHomeOfferViewController.h"

@interface KNBDesignSketchDetailViewController ()
//返回按钮
@property (nonatomic, strong) UIButton *backButton;
//收藏按钮
//@property (nonatomic, strong) UIButton *collectButton;
//分享按钮
@property (nonatomic, strong) UIButton *shareButton;
//大图
@property (nonatomic, strong) RFPhotoScrollerView *scrollerView;
//预约免费设计服务
@property (nonatomic, strong) UIView *leftBgView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *leftLabel;
//立即预约
@property (nonatomic, strong) UIButton *orderButton;
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
//    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(35);
//        make.right.equalTo(weakSelf.shareButton.mas_left).mas_offset(-25);
//        make.width.mas_equalTo(44);
//        make.height.mas_equalTo(44);
//    }];
    [self.leftBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(weakSelf.view);
        make.height.mas_equalTo(KNB_TAB_HEIGHT);
        make.width.mas_equalTo(KNB_SCREEN_WIDTH/3 * 2);
    }];
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).mas_offset(15);
        make.centerY.equalTo(weakSelf.leftBgView);
        make.height.mas_equalTo(38);
        make.width.mas_equalTo(38);
    }];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.leftImageView);
        make.left.equalTo(weakSelf.leftImageView.mas_right).mas_offset(10);
    }];
    [self.orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(weakSelf.view);
        make.height.mas_equalTo(KNB_TAB_HEIGHT);
        make.width.mas_equalTo(KNB_SCREEN_WIDTH/3);
    }];
}

#pragma mark - Utils
- (void)configuration {
    [self.naviView removeFromSuperview];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)addUI {
    [self.view addSubview:self.backButton];
//    [self.view addSubview:self.collectButton];
    [self.view addSubview:self.shareButton];
    [self.view addSubview:self.leftBgView];
    [self.leftBgView addSubview:self.leftImageView];
    [self.leftBgView addSubview:self.leftLabel];
    [self.view addSubview:self.orderButton];
}

- (void)fetchData {
    KNBRecruitmentCaseDetailApi *api = [[KNBRecruitmentCaseDetailApi alloc] initWithCaseId:[self.model.caseId integerValue]];
    api.hudString = @"";
    KNB_WS(weakSelf);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            NSDictionary *dic = request.responseObject[@"list"];
//            KNBDesignSketchModel *model = [KNBDesignSketchModel changeResponseJSONObject:dic];
            NSMutableArray *imgsArray = [NSMutableArray array];
            NSArray *tempArray = dic[@"imgs"];
            for (NSString *string in tempArray) {
                [imgsArray addObject:string];
            }
            weakSelf.photosArray = imgsArray;
            [weakSelf.view addSubview:weakSelf.scrollerView];
        } else {
            [weakSelf requestSuccess:NO requestEnd:NO];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
        [weakSelf requestSuccess:NO requestEnd:NO];
    }];
}

#pragma mark - Event Response
/*
 *  所有button、gestureRecognizer的响应事件都放在这个区域里面，不要到处乱放。
 */
- (void)backButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)collectButtonAction {
//
//}

- (void)shareButtonAction {
    if ([KNBUserInfo shareInstance].isLogin) {
        NSString *urlStr = @"http://baidu.com";
        NSString *name = @"效果图详情";
        NSString *describeStr = @"这是效果图详情";
        [self shareMessages:@[ name, describeStr, urlStr ] isActionType:NO shareButtonBlock:nil];
    } else {
        [LCProgressHUD showMessage:@"您还未登录,请先登录"];
    }
}

- (void)orderButtonAction {
    if ([KNBUserInfo shareInstance].isLogin) {
        KNBHomeOfferViewController *offerVC = [[KNBHomeOfferViewController alloc] init];
        [self.navigationController pushViewController:offerVC animated:YES];
    } else {
        [LCProgressHUD showMessage:@"您还未登录,请先登录"];
    }
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

//- (UIButton *)collectButton {
//    if (!_collectButton) {
//        _collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_collectButton setImage:KNBImages(@"knb_design_collect_unselect") forState:UIControlStateNormal];
//        [_collectButton setImage:KNBImages(@"knb_design_collect_selected") forState:UIControlStateSelected];
//        [_collectButton addTarget:self action:@selector(collectButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _collectButton;
//}

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
        _scrollerView = [[RFPhotoScrollerView alloc]initWithImagesArray:self.photosArray currentIndex:0 frame:CGRectMake(0, KNB_NAV_HEIGHT, KNB_SCREEN_WIDTH, KNB_SCREEN_HEIGHT - KNB_NAV_HEIGHT - KNB_TAB_HEIGHT)];
    }
    return _scrollerView;
}

- (UIView *)leftBgView {
    if (!_leftBgView) {
        _leftBgView = [[UIView alloc] init];
        _leftBgView.backgroundColor = [UIColor whiteColor];
    }
    return _leftBgView;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:self.model.img] placeholderImage:KNBImages(@"knb_default_user")];
        _leftImageView.layer.masksToBounds = YES;
        _leftImageView.layer.cornerRadius = 19;
        
    }
    return _leftImageView;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.text = self.model.name;
        _leftLabel.font = [UIFont systemFontOfSize:14];
        _leftLabel.textColor = [UIColor colorWithHex:0x333333];
    }
    return _leftLabel;
}

- (UIButton *)orderButton {
    if (!_orderButton) {
        _orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_orderButton setTitle:@"立即预约" forState:UIControlStateNormal];
        [_orderButton setBackgroundColor:[UIColor redColor]];
        [_orderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _orderButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_orderButton addTarget:self action:@selector(orderButtonAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _orderButton;
}

- (void)setModel:(KNBDesignSketchModel *)model {
    _model = model;
}
@end
