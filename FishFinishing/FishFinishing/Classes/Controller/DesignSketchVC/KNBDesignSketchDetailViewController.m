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

@interface KNBDesignSketchDetailViewController ()
//返回按钮
@property (nonatomic, strong) UIButton *backButton;
//分享按钮
@property (nonatomic, strong) UIButton *shareButton;
//大图
@property (nonatomic, strong) RFPhotoScrollerView *scrollerView;
//底部背景
@property (nonatomic, strong) UIView *bottomBgView;
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
            KNBDesignSketchModel *model = [KNBDesignSketchModel changeResponseJSONObject:dic];
            weakSelf.titleLabel.text = model.title;
            weakSelf.styleLabel.text = model.style_name ?: @"暂无风格信息";
            weakSelf.houseLabel.text = model.apart_name ?: @"暂无户型信息";
            weakSelf.areaLabel.text = [NSString stringWithFormat:@"%@㎡",model.acreage] ?: @"暂无面积信息";
            weakSelf.contentLabel.text = model.remark ?: @"暂无简介信息";
            weakSelf.orderButton.tag = [model.telephone integerValue];
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
    [self.view addSubview:self.bottomBgView];
    [self.bottomBgView addSubview:self.titleLabel];
    [self.bottomBgView addSubview:self.styleLabel];
    [self.bottomBgView addSubview:self.houseLabel];
    [self.bottomBgView addSubview:self.areaLabel];
    [self.bottomBgView addSubview:self.contentLabel];
}

- (void)settingLayout {
    KNB_WS(weakSelf);
    [self.bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.bottom.mas_equalTo(-KNB_TAB_HEIGHT);
        make.height.mas_equalTo(100);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(12);
    }];
    [self.styleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(12);
        make.width.mas_equalTo((KNB_SCREEN_WIDTH - 24)/3);
    }];
    [self.houseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).mas_offset(10);
        make.left.equalTo(weakSelf.styleLabel.mas_right).mas_offset(0);
        make.width.mas_equalTo((KNB_SCREEN_WIDTH - 24)/3);
    }];
    [self.areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).mas_offset(10);
        make.left.equalTo(weakSelf.houseLabel.mas_right).mas_offset(0);
        make.width.mas_equalTo((KNB_SCREEN_WIDTH - 24)/3);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.styleLabel.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
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
    NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:self.titleLabel.text attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    NSAttributedString *styleString = [[NSAttributedString alloc] initWithString:self.styleLabel.text attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    NSAttributedString *houseString = [[NSAttributedString alloc] initWithString:self.houseLabel.text attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    NSAttributedString *areaString = [[NSAttributedString alloc] initWithString:self.areaLabel.text attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    NSAttributedString *remarkString = [[NSAttributedString alloc] initWithString:self.contentLabel.text attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    
    UIImage *shareImage = [self combine:image title:titleString style:styleString house:houseString area:areaString remark:remarkString];
    NSString *name = @"效果图详情";
    NSString *describeStr = @"这是效果图详情";
    [self shareImageWithMessages:@[name , describeStr] image:shareImage shareButtonBlock:^(NSInteger platformType, BOOL success) {
        
    }];
}

- (void)orderButtonAction:(UIButton *)button {
    KNB_WS(weakSelf);
    if ([KNBUserInfo shareInstance].isLogin) {
        if ([button.titleLabel.text isEqualToString:@"立即预约"]) {
            KNBOrderViewController *orderVC = [[KNBOrderViewController alloc] init];
            orderVC.VCType = KNBOrderVCTypeOrderFinishing;
            orderVC.isExperience = NO;
            orderVC.isStyleEnable = NO;
            orderVC.model = self.model;
            [self.navigationController pushViewController:orderVC animated:YES];
        } else {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%ld",button.tag];
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

#pragma mark 合并图片
- (UIImage *)combine:(UIImage *)image title:(NSAttributedString *)title style:(NSAttributedString *)style house:(NSAttributedString *)house area:(NSAttributedString *)area remark:(NSAttributedString *)remark {
    //计算画布大小
    CGFloat width = image.size.width;
    CGFloat height = image.size.height + 150;
    CGSize resultSize = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(resultSize);
    
    //图片
    CGRect imageRect = CGRectMake(0, 0, resultSize.width, image.size.height);
    [image drawInRect:imageRect];
    
    //标题
    CGRect titleRect = CGRectMake(13, image.size.height + 15, resultSize.width, 25);
    [title drawInRect:titleRect];
    
    //风格
    CGRect styleRect = CGRectMake(13, image.size.height + 50, (KNB_SCREEN_WIDTH - 26)/3, 25);
    [style drawInRect:styleRect];
    
    //户型
    CGRect houseRect = CGRectMake((KNB_SCREEN_WIDTH - 26)/3 + 13, image.size.height + 50, (KNB_SCREEN_WIDTH - 26)/3, 25);
    [house drawInRect:houseRect];
    
    //面积
    CGRect areaRect = CGRectMake((KNB_SCREEN_WIDTH - 26)/3 * 2 + 13, image.size.height + 50, (KNB_SCREEN_WIDTH - 26)/3, 25);
    [area drawInRect:areaRect];
    
    //简介
    CGRect remarkRect = CGRectMake(13, image.size.height + 85, resultSize.width, 55);
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
        _scrollerView = [[RFPhotoScrollerView alloc]initWithImagesArray:self.photosArray currentIndex:0 frame:CGRectMake(0, 80, KNB_SCREEN_WIDTH, KNB_SCREEN_HEIGHT - KNB_TAB_HEIGHT - 180)];
    }
    return _scrollerView;
}

- (UIView *)bottomBgView {
    if (!_bottomBgView) {
        _bottomBgView = [[UIView alloc] init];
        _bottomBgView.backgroundColor = [UIColor colorWithHex:0x1a1a1a];
    }
    return _bottomBgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UILabel *)styleLabel {
    if (!_styleLabel) {
        _styleLabel = [[UILabel alloc] init];
        _styleLabel.textColor = [UIColor whiteColor];
        _styleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _styleLabel;
}

- (UILabel *)houseLabel {
    if (!_houseLabel) {
        _houseLabel = [[UILabel alloc] init];
        _houseLabel.textColor = [UIColor whiteColor];
        _houseLabel.font = [UIFont systemFontOfSize:14];
        _houseLabel.textAlignment = NSTextAlignmentCenter;

    }
    return _houseLabel;
}

- (UILabel *)areaLabel {
    if (!_areaLabel) {
        _areaLabel = [[UILabel alloc] init];
        _areaLabel.textColor = [UIColor whiteColor];
        _areaLabel.font = [UIFont systemFontOfSize:14];
        _areaLabel.textAlignment = NSTextAlignmentRight;
    }
    return _areaLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:14];
    }
    return _contentLabel;
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
        [_orderButton addTarget:self action:@selector(orderButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _orderButton;
}

- (void)setModel:(KNBDesignSketchModel *)model {
    _model = model;
    if ([model.parent_cat_name containsString:@"家居"] || [model.parent_cat_name containsString:@"建材"]) {
        [_orderButton setTitle:@"立即联系" forState:UIControlStateNormal];
        _orderButton.tag = [model.telephone integerValue];
    }
}
@end
