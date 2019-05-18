//
//  KNBHomeCityHeaderView.m
//  Concubine
//
//  Created by 吴申超 on 2017/5/13.
//  Copyright © 2017年 dengyun. All rights reserved.
//

#import "KNBHomeCityHeaderView.h"
#import "FMTagsView.h"
#import "NSString+Size.h"

@interface KNBHomeCityHeaderView ()<FMTagsViewDelegate>

@property (nonatomic, strong) UILabel *historyTipLabel;
@property (nonatomic, strong) FMTagsView *historyTagsView;
@property (nonatomic, strong) UILabel *hotTipLabel;
@property (nonatomic, strong) FMTagsView *hotTagsView;
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) NSDictionary *cityDataDic;
@property (nonatomic, strong) NSArray *sectionArray;
@end


@implementation KNBHomeCityHeaderView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureViews];
    }
    return self;
}

- (void)configureViews {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.historyTipLabel];
    [self addSubview:self.historyTagsView];
    [self addSubview:self.hotTipLabel];
    [self addSubview:self.hotTagsView];
    [self addSubview:self.clearButton];
    //设置热门城市
    NSArray *hotArray = @[@"成都市",@"上海市",@"北京市",@"广州市"];
    for (int i = 0; i < self.sectionArray.count; i++) {
        NSArray *cityArr = self.cityDataDic[self.sectionArray[i]];
        for (int j = 0; j < cityArr.count; j++) {
            NSDictionary *cityDic = cityArr[j];
            for (int k = 0; k < hotArray.count; k++) {
                if ([cityDic[@"name"] containsString:hotArray[k]]) {
                    KNBCityModel *model = [KNBCityModel changeResponseJSONObject:cityDic];
                    [self.hotArray addObject:model];
                }
            }
        }
    }
    self.historyTagsView.tagsArray = [self changeStringArray:self.historyArray];
    self.hotTagsView.tagsArray = [self changeStringArray:self.hotArray];
}

#pragma mark - Layout
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    KNB_WS(weakSelf);
    [self.historyTipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(20);
    }];
    [self.historyTagsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.historyTipLabel.mas_bottom).mas_offset(10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo([KNBHomeCityHeaderView getTagsViewHeight:weakSelf.historyArray]);
    }];
    [self.hotTipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.historyTagsView.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(12);
    }];
    [self.hotTagsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.hotTipLabel.mas_bottom).mas_offset(10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo([KNBHomeCityHeaderView getTagsViewHeight:weakSelf.hotArray]);
    }];
    [self.clearButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.equalTo(weakSelf.historyTipLabel);
        make.width.mas_equalTo(66);
        make.height.mas_equalTo(44);
    }];
    [super updateConstraints];
}

- (void)tagsView:(FMTagsView *)tagsView didSelectTagAtIndex:(NSUInteger)index {
    KNBCityModel *model = nil;
    if (tagsView == self.historyTagsView) {
        model = self.historyArray[index];
    } else {
        model = self.hotArray[index];
    }
    !self.selectComplete ?: self.selectComplete(model);
}

+ (NSInteger)getTagsViewHeight:(NSMutableArray *)dataArray {
    CGFloat tagsWidth = 0;
    CGFloat space = 17;
    NSInteger lines = 1;
    for (KNBCityModel *model in dataArray) {
        CGFloat tagWidth = [model.name widthWithFont:[UIFont systemFontOfSize:14] constrainedToHeight:16] + 26;
        if (tagWidth < 75) {
            tagWidth = 75;
        }
        if (tagsWidth + tagWidth + 20> KNB_SCREEN_WIDTH) {
            tagsWidth = 0;
            lines++;
        }
        tagsWidth = tagWidth + space + tagsWidth;
    }
    return lines * 40 + 10;
}

- (NSMutableArray *)changeStringArray:(NSMutableArray *)dataArray {
    NSMutableArray *stringArray = [NSMutableArray array];
    for (KNBCityModel *model in dataArray) {
        [stringArray addObject:model.name];
    }
    return stringArray;
}

- (void)clearButtonAction {
    [KNBAlertRemind alterWithTitle:@"提示" message:@"您确定要清除所有常用城市吗?" buttonTitles:@[@"确认",@"取消"] handler:^(NSInteger index, NSString *title) {
        if ([title isEqualToString:@"确认"]) {
            BOOL result = [KNBCityModel deleteModel];
            if (result) {
                self.historyTagsView.tagsArray = [NSArray array];
            }
        }
    }];
}

#pragma mark - Getting && Setting
+ (CGFloat)cityHeaderViewHeight {
    NSMutableArray *modelArray = [KNBCityModel searchAll].mutableCopy;
    CGFloat height = [self getTagsViewHeight:modelArray];

    return 140 + height;
}

- (UILabel *)historyTipLabel {
    if (!_historyTipLabel) {
        _historyTipLabel = [[UILabel alloc] init];
        _historyTipLabel.textColor = [UIColor knMainColor];
        _historyTipLabel.text = @"常用城市";
        _historyTipLabel.font = KNBFont(14);
    }
    return _historyTipLabel;
}

- (UILabel *)hotTipLabel {
    if (!_hotTipLabel) {
        _hotTipLabel = [[UILabel alloc] init];
        _hotTipLabel.textColor = [UIColor knMainColor];
        _hotTipLabel.text = @"热门城市";
        _hotTipLabel.font = KNBFont(14);
    }
    return _hotTipLabel;
}

- (FMTagsView *)historyTagsView {
    if (!_historyTagsView) {
        FMTagsView *tagView = [[FMTagsView alloc] init];
        tagView.frame = CGRectMake(0, 5, KNB_SCREEN_WIDTH, 100);
        tagView.contentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        tagView.tagInsets = UIEdgeInsetsMake(0.5, 8, 0.5, 8);
        tagView.tagBorderWidth = 0.5;
        tagView.tagcornerRadius = 5;
        tagView.tagBorderColor = [UIColor colorWithHex:0xf2f2f2];
        tagView.tagSelectedBorderColor = [UIColor colorWithHex:0x0096e6];
        tagView.tagBackgroundColor = [UIColor colorWithHex:0xf2f2f2];
        tagView.tagSelectedBackgroundColor = [UIColor colorWithHex:0x0096e6];
        tagView.interitemSpacing = 17;
        tagView.tagFont = KNBFont(14);
        tagView.tagTextColor = [UIColor colorWithHex:0x333333];
        tagView.allowsSelection = YES;
        tagView.collectionView.scrollEnabled = NO;
        tagView.collectionView.showsVerticalScrollIndicator = NO;
        tagView.tagHeight = 30;
        tagView.mininumTagWidth = 75;
        tagView.delegate = self;
        _historyTagsView = tagView;
    }
    return _historyTagsView;
}

- (FMTagsView *)hotTagsView {
    if (!_hotTagsView) {
        FMTagsView *tagView = [[FMTagsView alloc] init];
        tagView.frame = CGRectMake(0, 5, KNB_SCREEN_WIDTH, 100);
        tagView.contentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        tagView.tagInsets = UIEdgeInsetsMake(0.5, 8, 0.5, 8);
        tagView.tagBorderWidth = 0.5;
        tagView.tagcornerRadius = 5;
        tagView.tagBorderColor = [UIColor colorWithHex:0xf2f2f2];
        tagView.tagSelectedBorderColor = [UIColor colorWithHex:0x0096e6];
        tagView.tagBackgroundColor = [UIColor colorWithHex:0xf2f2f2];
        tagView.tagSelectedBackgroundColor = [UIColor colorWithHex:0x0096e6];
        tagView.interitemSpacing = 17;
        tagView.tagFont = KNBFont(14);
        tagView.tagTextColor = [UIColor colorWithHex:0x333333];
        tagView.allowsSelection = YES;
        tagView.collectionView.scrollEnabled = NO;
        tagView.collectionView.showsVerticalScrollIndicator = NO;
        tagView.tagHeight = 30;
        tagView.mininumTagWidth = 75;
        tagView.delegate = self;
        _hotTagsView = tagView;
    }
    return _hotTagsView;
}

- (UIButton *)clearButton {
    if (!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearButton setImage:KNBImages(@"knb_icon_cancle") forState:UIControlStateNormal];
        [_clearButton addTarget:self action:@selector(clearButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}

- (NSMutableArray *)historyArray {
    if (!_historyArray) {
        NSArray *modelArray = [KNBCityModel searchAll];
        _historyArray = [NSMutableArray array];
        [_historyArray addObjectsFromArray:modelArray];
    }
    return _historyArray;
}

- (NSMutableArray *)hotArray {
    if (!_hotArray) {
        _hotArray = [NSMutableArray array];
    }
    return _hotArray;
}

- (NSDictionary *)cityDataDic {
    if (!_cityDataDic) {
        NSString *areasPath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
        NSData *areasData = [[NSData alloc] initWithContentsOfFile:areasPath];
        NSDictionary *areas = [NSJSONSerialization JSONObjectWithData:areasData options:0 error:nil];
        _cityDataDic = areas[@"data"];
    }
    return _cityDataDic;
}

- (NSArray *)sectionArray {
    if (!_sectionArray) {
        NSArray *keyArray = [self.cityDataDic allKeys];
        _sectionArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2 options:NSLiteralSearch];
        }];
    }
    return _sectionArray;
}

@end
