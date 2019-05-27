//
//  KNBHomeDesignViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/2.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeDesignViewController.h"
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
//utils
#import "KNBButton.h"
#import "KNBOrderModel.h"
#import "KNBHomeBespokeApi.h"
#import "KNBOrderAlertView.h"
#import "UIButton+Style.h"
#import "UIImage+Resize.h"

@interface KNBHomeDesignViewController ()
@property (nonatomic, strong) UIScrollView *bgView;
//服务商头像
@property (nonatomic, strong) UIImageView *iconImageView;
//服务商 label
@property (nonatomic, strong) UILabel *titleLabel;
//标签按钮
@property (nonatomic, strong) UIButton *markButton;
//标签文字
@property (nonatomic, strong) UILabel *leftMarkLabel;
@property (nonatomic, strong) UILabel *middleMarkLabel;
@property (nonatomic, strong) UILabel *rightMarkLabel;
//底部线条
@property (nonatomic, strong) UIView *lineView;
//服务流程
@property (nonatomic, strong) UILabel *middleLabel;
//电话回访
@property (nonatomic, strong) KNBButton *phoneButton;
//上门量房
@property (nonatomic, strong) KNBButton *ruleButton;
//出设计图
@property (nonatomic, strong) KNBButton *designButton;
//方案调优
@property (nonatomic, strong) KNBButton *infoButton;
//左边的箭头
@property (nonatomic, strong) UIImageView *leftArrowImageView;
//中间的箭头
@property (nonatomic, strong) UIImageView *middleArrowImageView;
//右边的箭头
@property (nonatomic, strong) UIImageView *rightArrowImageView;
//header view
@property (nonatomic, strong) UIView *headerView;
//footer view
@property (nonatomic, strong) KNBDSFreeOrderFooterView *footerView;
@property (nonatomic, strong) KNBOrderModel *orderModel;
@end

@implementation KNBHomeDesignViewController

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
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(15);
            make.width.mas_equalTo(64);
            make.height.mas_equalTo(64);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.iconImageView.mas_right).mas_offset(13);
            make.top.equalTo(weakSelf.iconImageView.mas_top).mas_offset(11);
            make.width.mas_lessThanOrEqualTo(KNB_SCREEN_WIDTH - 190);
        }];
        [self.markButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleLabel.mas_right).mas_offset(13);
            make.centerY.equalTo(weakSelf.titleLabel);
        }];
        [self.leftMarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.titleLabel.mas_bottom).mas_offset(15);
            make.left.equalTo(weakSelf.iconImageView.mas_right).mas_offset(13);
        }];
        [self.middleMarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.titleLabel.mas_bottom).mas_offset(15);
            make.left.equalTo(weakSelf.leftMarkLabel.mas_right).mas_offset(20);
        }];
        [self.rightMarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.titleLabel.mas_bottom).mas_offset(15);
            make.left.equalTo(weakSelf.middleMarkLabel.mas_right).mas_offset(20);
            make.right.mas_equalTo(-13);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.iconImageView.mas_bottom).mas_offset(15);
            make.width.mas_equalTo(KNB_SCREEN_WIDTH);
            make.height.mas_equalTo(8);
        }];
    }
    [self.middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (weakSelf.faceId) {
            make.top.equalTo(weakSelf.lineView.mas_bottom).mas_offset(15);
        } else {
            make.top.mas_equalTo(15);
        }
        make.centerX.equalTo(weakSelf.view);
    }];
    CGFloat leftPadding = (KNB_SCREEN_WIDTH - 320)/8;
    CGFloat middlePadding = leftPadding * 2;
    [self.phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftPadding);
        make.top.equalTo(weakSelf.middleLabel.mas_bottom).mas_offset(15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
    [self.leftArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.phoneButton.mas_right).mas_offset(0);
        make.centerY.equalTo(weakSelf.phoneButton.mas_centerY).mas_offset(-12);
    }];
    [self.ruleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.phoneButton.mas_right).mas_offset(middlePadding);
        make.top.equalTo(weakSelf.middleLabel.mas_bottom).mas_offset(15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
    [self.middleArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.ruleButton.mas_right).mas_offset(0);
        make.centerY.equalTo(weakSelf.phoneButton.mas_centerY).mas_offset(-12);
    }];
    [self.designButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.ruleButton.mas_right).mas_offset(middlePadding);
        make.top.equalTo(weakSelf.middleLabel.mas_bottom).mas_offset(15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
    [self.rightArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.designButton.mas_right).mas_offset(0);
        make.centerY.equalTo(weakSelf.phoneButton.mas_centerY).mas_offset(-12);
    }];
    [self.infoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.designButton.mas_right).mas_offset(middlePadding);
        make.top.equalTo(weakSelf.middleLabel.mas_bottom).mas_offset(15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(8);
        make.top.equalTo(weakSelf.infoButton.mas_bottom).mas_offset(18);
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
    if (self.faceId) {
        self.knbTableView.frame = CGRectMake(12, 270, KNB_SCREEN_WIDTH - 24, 315);
    } else {
        self.knbTableView.frame = CGRectMake(12, 170, KNB_SCREEN_WIDTH - 24, 315);
    }
//    self.footerView.frame = CGRectMake(12, CGRectGetMaxY(self.knbTableView.frame), KNB_SCREEN_WIDTH - 24, 38);
}

- (void)addUI {
    [self.view addSubview:self.bgView];
    if (self.faceId) {
        [self.bgView addSubview:self.iconImageView];
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.markButton];
        [self.bgView addSubview:self.leftMarkLabel];
        [self.bgView addSubview:self.middleMarkLabel];
        [self.bgView addSubview:self.rightMarkLabel];
        [self.bgView addSubview:self.lineView];
    }
    [self.bgView addSubview:self.middleLabel];
    [self.bgView addSubview:self.phoneButton];
    [self.bgView addSubview:self.leftArrowImageView];
    [self.bgView addSubview:self.ruleButton];
    [self.bgView addSubview:self.middleArrowImageView];
    [self.bgView addSubview:self.designButton];
    [self.bgView addSubview:self.rightArrowImageView];
    [self.bgView addSubview:self.infoButton];
    [self.bgView addSubview:self.headerView];
    [self.bgView addSubview:self.knbTableView];
//    [self.bgView addSubview:self.footerView];
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
        KNBDSFreeOrderAddressTableViewCell *typeCell = (KNBDSFreeOrderAddressTableViewCell *)cell;
        [typeCell setProvinceName:[KNGetUserLoaction shareInstance].currentStateName cityName:[KNGetUserLoaction shareInstance].currentCityName areaName:[KNGetUserLoaction shareInstance].currentSubLocalityName];
    } else if (indexPath.row == 2) {
        cell = [KNBDSFreeOrderAreaTableViewCell cellWithTableView:tableView];
    } else if (indexPath.row == 3) {
        cell = [KNBDSFreeOrderNameTableViewCell cellWithTableView:tableView];
    } else  if (indexPath.row == 4){
        cell = [KNBDSFreeOrderPhoneTableViewCell cellWithTableView:tableView];
        KNBDSFreeOrderPhoneTableViewCell * typeCell = (KNBDSFreeOrderPhoneTableViewCell *)cell;
        typeCell.detailTextField.placeholder = @"输入您的电话号码，设计方案将发送到您的手机";
        typeCell.detailTextField.text = [KNBUserInfo shareInstance].mobile;
    } else {
        cell = [KNBDSFreeOrderRedEnterTableViewCell cellWithTableView:tableView];
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
}

#pragma mark - Event Response
/*
 *  所有button、gestureRecognizer的响应事件都放在这个区域里面，不要到处乱放。
 */
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareAction {
    NSString *urlStr = @"http://dayuapp.idayu.cn/Home/design.html";
    NSString *name = @"大鱼装修app";
    NSString *describeStr = @"免费看装修设计、选材料、算报价、找装修的App";
    [self shareMessages:@[ name, describeStr, urlStr ] isActionType:NO shareButtonBlock:nil];
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

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, 8);
        _headerView.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
    }
    return _headerView;
}

//- (KNBDSFreeOrderFooterView *)footerView {
//    if (!_footerView) {
//        _footerView = [[KNBDSFreeOrderFooterView alloc] init];
//        _footerView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, 38);
//    }
//    return _footerView;
//}

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
        _titleLabel.textColor = [UIColor colorWithHex:0x333333];
        _titleLabel.text = @"名称";
    }
    return _titleLabel;
}

- (UIButton *)markButton {
    if (!_markButton) {
        _markButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_markButton setTitle:@"服务商" forState:UIControlStateNormal];
        [_markButton setTitleColor:[UIColor colorWithHex:0x0093d6] forState:UIControlStateNormal];
        _markButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_markButton setBackgroundImage:KNBImages(@"knb_offer_fuwushang") forState:UIControlStateNormal];
    }
    return _markButton;
}

- (UILabel *)leftMarkLabel {
    if (!_leftMarkLabel) {
        _leftMarkLabel = [[UILabel alloc] init];
        _leftMarkLabel.font = [UIFont systemFontOfSize:15];
        _leftMarkLabel.textColor = KNBColor(0x009fe8);
        _leftMarkLabel.text = @"免费";
    }
    return _leftMarkLabel;
}

- (UILabel *)middleMarkLabel {
    if (!_middleMarkLabel) {
        _middleMarkLabel = [[UILabel alloc] init];
        _middleMarkLabel.font = [UIFont systemFontOfSize:15];
        _middleMarkLabel.textColor = KNBColor(0xFD9424);
        _middleMarkLabel.text = @"户型设计";
    }
    return _middleMarkLabel;
}

- (UILabel *)rightMarkLabel {
    if (!_rightMarkLabel) {
        _rightMarkLabel = [[UILabel alloc] init];
        _rightMarkLabel.font = [UIFont systemFontOfSize:15];
        _rightMarkLabel.textColor = KNBColor(0xFF6600);
        _rightMarkLabel.text = @"专业设计师1对1服务";
    }
    return _rightMarkLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor knBgColor];
    }
    return _lineView;
}

- (UILabel *)middleLabel {
    if (!_middleLabel) {
        _middleLabel = [[UILabel alloc] init];
        _middleLabel.text = @"服务流程";
        _middleLabel.font = [UIFont systemFontOfSize:15];
        _middleLabel.textColor = [UIColor colorWithHex:0x333333];
    }
    return _middleLabel;
}

- (KNBButton *)phoneButton {
    if (!_phoneButton) {
        _phoneButton = [KNBButton buttonWithType:UIButtonTypeCustom];
        [_phoneButton setTitle:@"1.电话回访" forState:UIControlStateNormal];
        [_phoneButton setImage:KNBImages(@"knb_home_phone") forState:UIControlStateNormal];
        [_phoneButton setTitleColor:[UIColor colorWithHex:0x808080] forState:UIControlStateNormal];
        _phoneButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_phoneButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:10];
    }
    return _phoneButton;
}

- (UIImageView *)leftArrowImageView {
    if (!_leftArrowImageView) {
        _leftArrowImageView = [[UIImageView alloc] init];
        _leftArrowImageView.image = KNBImages(@"knb_home_arrow");
    }
    return _leftArrowImageView;
}

- (KNBButton *)ruleButton {
    if (!_ruleButton) {
        _ruleButton = [KNBButton buttonWithType:UIButtonTypeCustom];
        [_ruleButton setTitle:@"2.上门量房" forState:UIControlStateNormal];
        [_ruleButton setImage:KNBImages(@"knb_home_ruler") forState:UIControlStateNormal];
        [_ruleButton setTitleColor:[UIColor colorWithHex:0x808080] forState:UIControlStateNormal];
        _ruleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_ruleButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:10];
    }
    return _ruleButton;
}

- (UIImageView *)middleArrowImageView {
    if (!_middleArrowImageView) {
        _middleArrowImageView = [[UIImageView alloc] init];
        _middleArrowImageView.image = KNBImages(@"knb_home_arrow");
    }
    return _middleArrowImageView;
}

- (KNBButton *)designButton {
    if (!_designButton) {
        _designButton = [KNBButton buttonWithType:UIButtonTypeCustom];
        [_designButton setTitle:@"3.出设计图" forState:UIControlStateNormal];
        [_designButton setImage:KNBImages(@"knb_home_design") forState:UIControlStateNormal];
        [_designButton setTitleColor:[UIColor colorWithHex:0x808080] forState:UIControlStateNormal];
        _designButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_designButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:10];
    }
    return _designButton;
}

- (UIImageView *)rightArrowImageView {
    if (!_rightArrowImageView) {
        _rightArrowImageView = [[UIImageView alloc] init];
        _rightArrowImageView.image = KNBImages(@"knb_home_arrow");
    }
    return _rightArrowImageView;
}

- (KNBButton *)infoButton {
    if (!_infoButton) {
        _infoButton = [KNBButton buttonWithType:UIButtonTypeCustom];
        [_infoButton setTitle:@"4.方案调优" forState:UIControlStateNormal];
        [_infoButton setImage:KNBImages(@"knb_home_information") forState:UIControlStateNormal];
        [_infoButton setTitleColor:[UIColor colorWithHex:0x808080] forState:UIControlStateNormal];
        _infoButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_infoButton layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleTop imageTitleSpace:10];
    }
    return _infoButton;
}

- (KNBOrderModel *)orderModel {
    if (!_orderModel) {
        _orderModel = [[KNBOrderModel alloc] init];
    }
    return _orderModel;
}

@end
