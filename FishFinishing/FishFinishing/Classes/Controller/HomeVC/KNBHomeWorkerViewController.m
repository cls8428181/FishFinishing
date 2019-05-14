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

@interface KNBHomeWorkerViewController ()
@property (nonatomic, strong) UIScrollView *bgView;
//顶部广告图片
@property (nonatomic, strong) UIImageView *adImageView;
//服务商 label
@property (nonatomic, strong) UILabel *titleLabel;
//服务商按钮
@property (nonatomic, strong) UIButton *titleButton;
//预约人数
@property (nonatomic, strong) UILabel *topLabel;
//免费服务上门
@property (nonatomic, strong) UILabel *bottomLabel;
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
        make.left.right.mas_equalTo(weakSelf.view);
        if (weakSelf.faceId) {
            make.top.equalTo(weakSelf.titleButton.mas_bottom).mas_offset(12);
        } else {
            make.top.equalTo(weakSelf.naviView.mas_bottom).mas_offset(12);
        }
        make.height.mas_equalTo(138);
    }];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.adImageView.mas_bottom).mas_offset(24);
        make.centerX.equalTo(weakSelf.adImageView);
    }];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topLabel.mas_bottom).mas_offset(20);
        make.centerX.equalTo(weakSelf.adImageView);
    }];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(10);
        make.top.equalTo(weakSelf.bottomLabel.mas_bottom).mas_offset(26);
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
        self.knbTableView.frame = CGRectMake(12, 350, KNB_SCREEN_WIDTH - 24, 315);
    } else {
        self.knbTableView.frame = CGRectMake(12, 310, KNB_SCREEN_WIDTH - 24, 315);
    }
    self.footerView.frame = CGRectMake(12, CGRectGetMaxY(self.knbTableView.frame), KNB_SCREEN_WIDTH - 24, 38);
}

- (void)addUI {
    [self.view addSubview:self.bgView];
    if (self.faceId) {
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.titleButton];
    }
    [self.bgView addSubview:self.adImageView];
    [self.bgView addSubview:self.topLabel];
    [self.bgView addSubview:self.bottomLabel];
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
    } else  if (indexPath.row == 4){
        cell = [KNBDSFreeOrderPhoneTableViewCell cellWithTableView:tableView];
    } else {
        cell = [KNBDSFreeOrderRedEnterTableViewCell cellWithTableView:tableView];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? 55 : 50;
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
    NSString *urlStr = @"http://dayuapp.idayu.cn/Home/foreman.html";
    NSString *name = @"大鱼装修";
    NSString *describeStr = @"大鱼装修";
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
- (UIImageView *)adImageView {
    if (!_adImageView) {
        _adImageView = [[UIImageView alloc] init];
        _adImageView.image = KNBImages(@"knb_worker_banner");
    }
    return _adImageView;
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
