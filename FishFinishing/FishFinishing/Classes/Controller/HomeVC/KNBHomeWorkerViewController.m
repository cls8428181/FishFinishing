//
//  KNBHomeWorkerViewController.m
//  FishFinishing
//
//  Created by apple on 2019/4/23.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBHomeWorkerViewController.h"
//views
#import "KNBDSFreeOrderNewHouseTableViewCell.h"
#import "KNBDSFreeOrderAddressTableViewCell.h"
#import "KNBDSFreeOrderAreaTableViewCell.h"
#import "KNBDSFreeOrderNameTableViewCell.h"
#import "KNBDSFreeOrderPhoneTableViewCell.h"
#import "KNBDSFreeOrderRedEnterTableViewCell.h"
#import "KNBDSFreeOrderFooterView.h"
#import "DesignSketchViewController.h"
#import "KNBRecruitmentDetailApi.h"
#import "KNBHomeServiceModel.h"
#import "KNBAddressPickerView.h"
#import "UIImage+Resize.h"
#import "KNBButton.h"
#import "KNBOrderModel.h"
#import "KNBHomeBespokeApi.h"
#import "KNBOrderAlertView.h"
#import "UIButton+Style.h"
#import "FMTagsView.h"

@interface KNBHomeWorkerViewController ()
@property (nonatomic, strong) UIScrollView *bgView;
//顶部背景
@property (nonatomic, strong) UIImageView *topBgView;
//顶部头像的背景
@property (nonatomic, strong) UIView *iconBgView;
//顶部头像
@property (nonatomic, strong) UIImageView *iconImageView;
//服务商名称
@property (nonatomic, strong) UILabel *titleLabel;
//标签按钮
@property (nonatomic, strong) UIButton *markButton;
//服务标签
@property (nonatomic, strong) FMTagsView *servicesView;
//服务标签
@property (nonatomic, strong) FMTagsView *tagsView;
//预约人数
@property (nonatomic, strong) UILabel *topLabel;
//免费服务上门
@property (nonatomic, strong) UILabel *bottomLabel;
//顶部预约按钮
@property (nonatomic, strong) UIButton *orderButton;
//header view
@property (nonatomic, strong) UIView *headerView;
//footer view
@property (nonatomic, strong) KNBDSFreeOrderFooterView *footerView;
@property (nonatomic, strong) KNBOrderModel *orderModel;
@end

@implementation KNBHomeWorkerViewController

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
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KNB_NAV_HEIGHT);
        make.left.right.bottom.equalTo(weakSelf.view);
    }];
    if (self.faceId) {
        [self.topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(120);
        }];
        [self.iconBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(11);
            make.top.mas_equalTo(24);
            make.width.mas_equalTo(68);
            make.height.mas_equalTo(68);
        }];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(13);
            make.top.mas_equalTo(26);
            make.width.mas_equalTo(64);
            make.height.mas_equalTo(64);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.iconImageView.mas_right).mas_offset(13);
            make.top.mas_equalTo(13);
            make.width.mas_lessThanOrEqualTo(KNB_SCREEN_WIDTH - 190);
        }];
        [self.markButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleLabel.mas_right).mas_offset(18);
            make.top.mas_equalTo(13);
        }];
        [self.servicesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.titleLabel.mas_bottom).mas_offset(17);
            make.left.equalTo(weakSelf.iconImageView.mas_right).mas_offset(5);
            make.right.mas_equalTo(-13);
        }];
        [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.servicesView.mas_bottom).mas_offset(15);
            make.left.equalTo(weakSelf.iconImageView.mas_right).mas_offset(5);
            make.right.mas_equalTo(-13);
        }];
    }
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (weakSelf.faceId) {
            make.top.equalTo(weakSelf.topBgView.mas_bottom).mas_offset(16);
        } else {
            make.top.mas_equalTo(16);
        }
        make.centerX.equalTo(weakSelf.view);
    }];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topLabel.mas_bottom).mas_offset(13);
        make.centerX.equalTo(weakSelf.view);
    }];
    [self.orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bottomLabel.mas_bottom).mas_offset(17);
        make.centerX.equalTo(weakSelf.view);
        make.width.mas_equalTo(124);
        make.height.mas_equalTo(26);
    }];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(8);
        make.top.equalTo(weakSelf.orderButton.mas_bottom).mas_offset(12);
    }];
}

#pragma mark - Utils
- (void)configuration {
    self.naviView.title = @"免费获取装修预算";
    [self.naviView addLeftBarItemImageName:@"knb_back_black" target:self sel:@selector(backAction)];
    [self.naviView addRightBarItemImageName:@"knb_design_share" target:self sel:@selector(shareAction)];
    self.naviView.titleNaviLabel.textColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.knbTableView.backgroundColor = [UIColor whiteColor];
    self.knbTableView.layer.shadowColor = [UIColor colorWithHex:0xcccccc].CGColor;
    self.knbTableView.layer.shadowOffset = CGSizeMake(0,0);
    self.knbTableView.layer.shadowOpacity = 0.5;
    self.knbTableView.layer.shadowRadius = 5;
    self.knbTableView.clipsToBounds = false;
    self.knbTableView.scrollEnabled = NO;
    if (self.faceId) {
        self.knbTableView.frame = CGRectMake(12, 275, KNB_SCREEN_WIDTH - 24, 315);
    } else {
        self.knbTableView.frame = CGRectMake(12, 155, KNB_SCREEN_WIDTH - 24, 315);
    }
    self.footerView.frame = CGRectMake(12, CGRectGetMaxY(self.knbTableView.frame), KNB_SCREEN_WIDTH - 24, 38);
}

- (void)addUI {
    [self.view addSubview:self.bgView];
    if (self.faceId) {
        [self.bgView addSubview:self.topBgView];
        [self.bgView addSubview:self.iconBgView];
        [self.bgView addSubview:self.iconImageView];
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.markButton];
        [self.bgView addSubview:self.servicesView];
        [self.bgView addSubview:self.tagsView];
    }
    [self.bgView addSubview:self.topLabel];
    [self.bgView addSubview:self.bottomLabel];
    [self.bgView addSubview:self.orderButton];
    [self.bgView addSubview:self.headerView];
    [self.bgView addSubview:self.knbTableView];
    [self.bgView addSubview:self.footerView];
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
                weakSelf.titleLabel.text = model.name;
                [weakSelf.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.logo] placeholderImage:CCPortraitPlaceHolder];
                NSMutableArray *tagsArray = [NSMutableArray array];
                for (KNBHomeServiceModel *tempModel in model.serviceList) {
                    [tagsArray addObject:tempModel.service_name];
                }
                weakSelf.servicesView.tagsArray = tagsArray;
                weakSelf.tagsView.tagsArray = [model.tag componentsSeparatedByString:@","];
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
    } else  if (indexPath.row == 4){
        cell = [KNBDSFreeOrderPhoneTableViewCell cellWithTableView:tableView];
    } else {
        cell = [KNBDSFreeOrderRedEnterTableViewCell cellWithTableView:tableView];
        KNBDSFreeOrderRedEnterTableViewCell *typeCell = (KNBDSFreeOrderRedEnterTableViewCell *)cell;
        [typeCell.enterButton setTitle:@"立即预约" forState:UIControlStateNormal];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 5 ? 55 : 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KNB_WS(weakSelf);
    if (indexPath.row == 1) {
        [KNBAddressPickerView showAddressPickerWithDefaultSelected:nil resultBlock:^(KNBAddressModel *province, KNBAddressModel *city, KNBAddressModel *area) {
            KNBDSFreeOrderAddressTableViewCell *cell = [weakSelf.knbTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            [cell setProvinceName:province.name cityName:city.name areaName:area.name];
            weakSelf.orderModel.province_id = [province.code integerValue];
            weakSelf.orderModel.city_id = [city.code integerValue];
            weakSelf.orderModel.area_id = [area.code integerValue];
        }];
    }
    if (indexPath.row == 5) {
        [self bespokeRequest];
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
    NSString *urlStr = @"http://dayuapp.idayu.cn/Home/foreman.html";
    NSString *name = @"大鱼装修";
    NSString *describeStr = @"大鱼装修";
    [self shareMessages:@[ name, describeStr, urlStr ] isActionType:NO shareButtonBlock:nil];
}

- (void)orderButtonAction {
    [self bespokeRequest];
}

- (void)bespokeRequest {
    KNBDSFreeOrderNewHouseTableViewCell *houseCell = [self.knbTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    KNBDSFreeOrderAreaTableViewCell *areaCell = [self.knbTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    KNBDSFreeOrderNameTableViewCell *nameCell = [self.knbTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    KNBDSFreeOrderPhoneTableViewCell *phoneCell = [self.knbTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    self.orderModel.decorate_cat = houseCell.isNewHouse;
    self.orderModel.area_info = areaCell.detailTextField.text;
    self.orderModel.name = nameCell.detailTextField.text;
    self.orderModel.mobile = phoneCell.detailTextField.text;
    
    if (isNullStr(self.orderModel.decorate_cat)) {
        [LCProgressHUD showMessage:@"请选择新房装修或者旧房翻新"];
        return;
    }
    if (!(self.orderModel.province_id || self.orderModel.city_id || self.orderModel.area_id)) {
        [LCProgressHUD showMessage:@"请选择省市区"];
        return;
    }
    if (isNullStr(self.orderModel.area_info)) {
        [LCProgressHUD showMessage:@"请输入房屋面积"];
        return;
    }
    if (isNullStr(self.orderModel.name)) {
        [LCProgressHUD showMessage:@"请输入您的名称"];
        return;
    }
    if (isNullStr(self.orderModel.mobile)) {
        [LCProgressHUD showMessage:@"请输入你的电话"];
        return;
    }
    
    KNBHomeBespokeApi *api = [[KNBHomeBespokeApi alloc] initWithFacId:self.faceId ?: 0 facName:self.faceId ? self.titleLabel.text : @"" catId:[self.orderModel.typeModel.selectSubModel.typeId integerValue] userId:@"" areaInfo:self.orderModel.area_info houseInfo:self.orderModel.house_info community:self.orderModel.community provinceId:self.orderModel.province_id cityId:self.orderModel.city_id areaId:self.orderModel.area_id decorateStyle:self.orderModel.style decorateGrade:self.orderModel.level name:self.orderModel.name mobile:self.orderModel.mobile decorateCat:self.orderModel.decorate_cat type:1];
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

#pragma mark - Getters And Setters
/* getter和setter全部都放在最后*/
- (UIScrollView *)bgView {
    if (!_bgView) {
        _bgView = [[UIScrollView alloc] init];
        _bgView.contentSize = CGSizeMake(KNB_SCREEN_WIDTH,730);
    }
    return _bgView;
}

- (UIImageView *)topBgView {
    if (!_topBgView) {
        _topBgView = [[UIImageView alloc] init];
        _topBgView.image = KNBImages(@"knb_offer_bg");
    }
    return _topBgView;
}

- (UIView *)iconBgView {
    if (!_iconBgView) {
        _iconBgView = [[UIView alloc] init];
        _iconBgView.backgroundColor = [UIColor whiteColor];
        _iconBgView.layer.masksToBounds = YES;
        _iconBgView.layer.cornerRadius = 34;
    }
    return _iconBgView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 32;
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"名称";
    }
    return _titleLabel;
}

- (UIButton *)markButton {
    if (!_markButton) {
        _markButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_markButton setTitle:@"服务商" forState:UIControlStateNormal];
        [_markButton setTitleColor:[UIColor colorWithHex:0xFF6400] forState:UIControlStateNormal];
        _markButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_markButton setBackgroundImage:KNBImages(@"knb_offer_fuwushang_gray") forState:UIControlStateNormal];
    }
    return _markButton;
}

- (FMTagsView *)servicesView {
    if (!_servicesView) {
        FMTagsView *tagView = [[FMTagsView alloc] init];
        tagView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, 15);
        tagView.contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        tagView.tagInsets = UIEdgeInsetsMake(0.5, 8, 0.5, 8);
        tagView.tagBorderWidth = 0.5;
        tagView.tagcornerRadius = 5;
        tagView.tagBorderColor = [UIColor clearColor];
        tagView.tagSelectedBorderColor = [UIColor clearColor];
        tagView.tagBackgroundColor = [UIColor clearColor];
        tagView.tagSelectedBackgroundColor = [UIColor clearColor];
        tagView.backgroundColor = [UIColor clearColor];
        tagView.interitemSpacing = 15;
        tagView.tagFont = KNBFont(15);
        tagView.tagTextColor = KNBColor(0xfd9424);
        tagView.allowsSelection = YES;
        tagView.collectionView.scrollEnabled = NO;
        tagView.collectionView.showsVerticalScrollIndicator = NO;
        tagView.tagHeight = 15;
//        tagView.mininumTagWidth = 75;
        tagView.userInteractionEnabled = NO;
        _servicesView = tagView;
    }
    return _servicesView;
}

- (FMTagsView *)tagsView {
    if (!_tagsView) {
        FMTagsView *tagView = [[FMTagsView alloc] init];
        tagView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, 15);
        tagView.contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        tagView.tagInsets = UIEdgeInsetsMake(0.5, 8, 0.5, 8);
        tagView.tagBorderWidth = 0.5;
        tagView.tagcornerRadius = 5;
        tagView.tagBorderColor = [UIColor clearColor];
        tagView.tagSelectedBorderColor = [UIColor clearColor];
        tagView.tagBackgroundColor = [UIColor clearColor];
        tagView.tagSelectedBackgroundColor = [UIColor clearColor];
        tagView.backgroundColor = [UIColor clearColor];
        tagView.interitemSpacing = 15;
        tagView.tagFont = KNBFont(15);
        tagView.tagTextColor = KNBColor(0x0096E6);
        tagView.allowsSelection = YES;
        tagView.collectionView.scrollEnabled = NO;
        tagView.collectionView.showsVerticalScrollIndicator = NO;
        tagView.tagHeight = 15;
//        tagView.mininumTagWidth = 75;
        tagView.userInteractionEnabled = NO;
        _tagsView = tagView;
    }
    return _tagsView;
}

- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.font = [UIFont boldSystemFontOfSize:19];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"今日已有 342 人预约成功"];
        NSRange range1 = [[str string] rangeOfString:@"今日已有"];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x333333] range:range1];
        NSRange range2 = [[str string] rangeOfString:@"342"];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xff0000] range:range2];
        NSRange range3 = [[str string] rangeOfString:@"人预约成功"];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x333333] range:range3];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:range2];
        _topLabel.attributedText = str;
    }
    return _topLabel;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.font = [UIFont boldSystemFontOfSize:16];
        _bottomLabel.text = @"免费服务上门";
        _bottomLabel.textColor = [UIColor colorWithHex:0x0096e6];
    }
    return _bottomLabel;
}

- (UIButton *)orderButton {
    if (!_orderButton) {
        _orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_orderButton setTitle:@"点击预约" forState:UIControlStateNormal];
        [_orderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _orderButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_orderButton setBackgroundColor:[UIColor knf5701bColor]];
        _orderButton.layer.masksToBounds = YES;
        _orderButton.layer.cornerRadius = 13;
        [_orderButton addTarget:self action:@selector(orderButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orderButton;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, 10);
        _headerView.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
    }
    return _headerView;
}

- (KNBDSFreeOrderFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[KNBDSFreeOrderFooterView alloc] init];
        _footerView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, 38);
    }
    return _footerView;
}

- (KNBOrderModel *)orderModel {
    if (!_orderModel) {
        _orderModel = [[KNBOrderModel alloc] init];
    }
    return _orderModel;
}


@end
