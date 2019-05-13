//
//  KNBHomeOfferViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/30.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeOfferViewController.h"
//views
#import "KNBDesignSketchFreeOrderHeaderView.h"
#import "KNBDSFreeOrderNewHouseTableViewCell.h"
#import "KNBDSFreeOrderAddressTableViewCell.h"
#import "KNBDSFreeOrderAreaTableViewCell.h"
#import "KNBDSFreeOrderNameTableViewCell.h"
#import "KNBDSFreeOrderPhoneTableViewCell.h"
#import "KNBDSFreeOrderFooterView.h"
#import "KNBDSFreeOrderEnterTableViewCell.h"
#import "NSTimer+EOCBlocksSupport.h"
#import "KNBAddressPickerView.h"
#import "KNBHomeBespokeApi.h"
#import "KNBOrderModel.h"
#import "KNBCityModel.h"
#import "KNBRecruitmentDetailApi.h"
#import "KNBHomeServiceModel.h"
#import "KNBOrderAlertView.h"
#import "UIImage+Resize.h"
#import "UIButton+Style.h"

@interface KNBHomeOfferViewController ()
//背景
@property (nonatomic, strong) UIScrollView *bgView;
//顶部广告图片
@property (nonatomic, strong) UIImageView *adImageView;
//服务商 label
@property (nonatomic, strong) UILabel *titleLabel;
//服务商按钮
@property (nonatomic, strong) UIButton *titleButton;
// 定时器
@property (nonatomic, strong) NSTimer *timer;
//header view
@property (nonatomic, strong) KNBDesignSketchFreeOrderHeaderView *headerView;
//footer view
@property (nonatomic, strong) KNBDSFreeOrderFooterView *footerView;
@property (nonatomic, strong) KNBOrderModel *orderModel;
//计数
@property (nonatomic, assign) NSInteger index;
@end

@implementation KNBHomeOfferViewController

#pragma mark - life cycle
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.bgView.contentSize = CGSizeMake(KNB_SCREEN_WIDTH,730);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configuration];
    
    [self addUI];
    
    [self settingConstraints];
    
    [self fetchData];
}

- (void)dealloc{
    [self destoryTimer];
}

#pragma mark - Setup UI Constraints
/*
 *  在这里添加UIView的约束布局相关代码
 */
- (void)settingConstraints {
    KNB_WS(weakSelf);
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KNB_NAV_HEIGHT);
        make.left.right.bottom.equalTo(weakSelf.view);
    }];
    if (self.faceId) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(22);
        }];
        [self.titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.titleLabel);
            make.left.equalTo(weakSelf.titleLabel.mas_right).mas_offset(15);
        }];
    }
    [self.adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        if (weakSelf.faceId) {
            make.top.equalTo(weakSelf.titleButton.mas_bottom).mas_offset(12);
        } else {
            make.top.equalTo(weakSelf.bgView.mas_bottom).mas_offset(12);
        }
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(90);
    }];
}

#pragma mark - Utils
- (void)configuration {
    self.naviView.title = @"免费获取装修预算";
    [self.naviView addLeftBarItemImageName:@"knb_back_black" target:self sel:@selector(backAction)];
    [self.naviView addRightBarItemImageName:@"knb_icon_share" target:self sel:@selector(shareAction)];
    self.naviView.titleNaviLabel.textColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.knbTableView.backgroundColor = [UIColor whiteColor];
    self.knbTableView.layer.shadowColor = [UIColor colorWithHex:0xcccccc].CGColor;
    self.knbTableView.layer.shadowOffset = CGSizeMake(0,0);
    self.knbTableView.layer.shadowOpacity = 0.5;
    self.knbTableView.layer.shadowRadius = 5;
    self.knbTableView.clipsToBounds = false;
    self.knbTableView.scrollEnabled = NO;
    self.index = 0;
    if (self.faceId) {
        self.knbTableView.frame = CGRectMake(12, 160, KNB_SCREEN_WIDTH - 24, 530);
    } else {
        self.knbTableView.frame = CGRectMake(12, KNB_NAV_HEIGHT + 30, KNB_SCREEN_WIDTH - 24, 530);
    }
    self.footerView.frame = CGRectMake(12, CGRectGetMaxY(self.knbTableView.frame) + 5, KNB_SCREEN_WIDTH - 24, 38);
}

- (void)addUI {
    [self.view addSubview:self.bgView];
    if (self.faceId) {
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.titleButton];
    }
    [self.bgView addSubview:self.adImageView];
    [self.bgView addSubview:self.knbTableView];
    [self.bgView addSubview:self.footerView];
    self.knbTableView.tableHeaderView = self.headerView;
    [self beginTimer];
}

- (void)fetchData {
    if (self.faceId) {
        KNBRecruitmentDetailApi *api = [[KNBRecruitmentDetailApi alloc] initWithfacId:self.faceId];
        api.hudString = @"";
        KNB_WS(weakSelf);
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
            if (api.requestSuccess) {
                NSDictionary *dic = request.responseObject[@"list"];
                KNBHomeServiceModel *model = [KNBHomeServiceModel changeResponseJSONObject:dic];
                [weakSelf.titleButton setTitle:model.name forState:UIControlStateNormal];
                [weakSelf.titleButton sd_setImageWithURL:[NSURL URLWithString:model.logo] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    UIImage *refined = [UIImage imageWithCGImage:image.CGImage scale:3 orientation:image.imageOrientation];
                    refined = [refined resizedImage:CGSizeMake(38, 38) interpolationQuality:0];
                    [weakSelf.titleButton setImage:refined forState:UIControlStateNormal];
                    [weakSelf.titleButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:5];
                }];
            } else {
                [weakSelf requestSuccess:NO requestEnd:NO];
            }
        } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
            [weakSelf requestSuccess:NO requestEnd:NO];
        }];
    }

}

#pragma mark - tableview delegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        cell = [KNBDSFreeOrderNewHouseTableViewCell cellWithTableView:tableView];
    } else if (indexPath.row == 1) {
        cell = [KNBDSFreeOrderAddressTableViewCell cellWithTableView:tableView];
    } else if (indexPath.row == 2) {
        cell = [KNBDSFreeOrderAreaTableViewCell cellWithTableView:tableView];
    } else if (indexPath.row == 3) {
        cell = [KNBDSFreeOrderNameTableViewCell cellWithTableView:tableView];
    } else if (indexPath.row == 4) {
        cell = [KNBDSFreeOrderPhoneTableViewCell cellWithTableView:tableView];
    } else {
        cell = [KNBDSFreeOrderEnterTableViewCell cellWithTableView:tableView];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        return 70;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KNB_WS(weakSelf);
    if (indexPath.row == 1) {
        [KNBAddressPickerView showAddressPickerWithDefaultSelected:nil resultBlock:^(KNBCityModel *province, KNBCityModel *city, KNBCityModel *area) {
            KNBDSFreeOrderAddressTableViewCell *cell = [weakSelf.knbTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            [cell setProvinceName:province.name cityName:city.name areaName:area.name];
            weakSelf.orderModel.province_id = [province.code integerValue];
            weakSelf.orderModel.city_id = [city.code integerValue];
            weakSelf.orderModel.area_id = [area.code integerValue];
        }];
    }
    if (indexPath.row == 5) {
        KNBDSFreeOrderNewHouseTableViewCell *houseCell = [weakSelf.knbTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        KNBDSFreeOrderAreaTableViewCell *areaCell = [weakSelf.knbTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        KNBDSFreeOrderNameTableViewCell *nameCell = [weakSelf.knbTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        KNBDSFreeOrderPhoneTableViewCell *phoneCell = [weakSelf.knbTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        self.orderModel.decorate_cat = houseCell.isNewHouse ? @"新房装修" : @"旧房翻新";
        self.orderModel.area_info = areaCell.detailTextField.text;
        self.orderModel.name = nameCell.detailTextField.text;
        self.orderModel.mobile = phoneCell.detailTextField.text;
        KNBHomeBespokeApi *api = [[KNBHomeBespokeApi alloc] initWithFacId:self.faceId ?: 0 facName:self.faceId ? self.titleButton.titleLabel.text : @"" catId:[self.orderModel.typeModel.selectSubModel.typeId integerValue] userId:@"" areaInfo:self.orderModel.area_info houseInfo:self.orderModel.house_info community:self.orderModel.community provinceId:self.orderModel.province_id cityId:self.orderModel.city_id areaId:self.orderModel.area_id decorateStyle:self.orderModel.style decorateGrade:self.orderModel.level name:self.orderModel.name mobile:self.orderModel.mobile decorateCat:self.orderModel.decorate_cat type:1];
        api.hudString = @"";
        KNB_WS(weakSelf);
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
            if (api.requestSuccess) {
                [KNBOrderAlertView showAlertViewCompleteBlock:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            } else {
                [weakSelf requestSuccess:NO requestEnd:NO];
            }
        } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
            [weakSelf requestSuccess:NO requestEnd:NO];
        }];
    }
}

#pragma mark - Event Response
/*
 *  所有button、gestureRecognizer的响应事件都放在这个区域里面，不要到处乱放。
 */
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareAction {
    NSString *urlStr = @"http://dayuapp.idayu.cn/Home/quote.html";
    NSString *name = @"大鱼装修";
    NSString *describeStr = @"大鱼装修";
    [self shareMessages:@[ name, describeStr, urlStr ] isActionType:NO shareButtonBlock:nil];
}

/**
 *  开始计时
 */
- (void)beginTimer {
    if (_timer == nil) {
        __weak typeof(self) weakSelf = self;
        self.timer = [NSTimer eoc_scheduledTimerWithTimeInterval:0.1 block:^{
            weakSelf.headerView.numLabel.text = [NSString stringWithFormat:@"%ld",(long)self.index++];
        } repeats:YES];
    }
}

- (void)destoryTimer {
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - Getters And Setters
/* getter和setter全部都放在最后*/
- (UIScrollView *)bgView {
    if (!_bgView) {
        _bgView = [[UIScrollView alloc] init];
    }
    return _bgView;
}

- (UIImageView *)adImageView {
    if (!_adImageView) {
        _adImageView = [[UIImageView alloc] init];
        _adImageView.image = KNBImages(@"knb_design_banner");
    }
    return _adImageView;
}

- (KNBDesignSketchFreeOrderHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:@"KNBDesignSketchFreeOrderHeaderView" owner:nil options:nil].lastObject;
        _headerView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, 210);
    }
    return _headerView;
}

- (KNBDSFreeOrderFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[KNBDSFreeOrderFooterView alloc] init];
        _footerView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, 65);
    }
    return _footerView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.text = @"服务商:";
    }
    return _titleLabel;
}

- (UIButton *)titleButton {
    if (!_titleButton) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleButton setTitle:@"装饰公司" forState:UIControlStateNormal];
        [_titleButton setImage:KNBImages(@"knb_default_user") forState:UIControlStateNormal];
        [_titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _titleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _titleButton.imageView.layer.masksToBounds = YES;
        _titleButton.imageView.layer.cornerRadius = 19;
    }
    return _titleButton;
}

- (KNBOrderModel *)orderModel {
    if (!_orderModel) {
        _orderModel = [[KNBOrderModel alloc] init];
    }
    return _orderModel;
}

@end
