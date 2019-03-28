//
//  KNBHomeRecommendTableViewCell.m
//  FishFinishing
//
//  Created by 常立山 on 2019/3/26.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeRecommendTableViewCell.h"
#import <HMSegmentedControl.h>
#import "KNBHomeRecommendSubTableViewCell.h"

@interface KNBHomeRecommendTableViewCell () <UITableViewDelegate, UITableViewDataSource>
//头部滑动视图
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
//滑动区域
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation KNBHomeRecommendTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"KNBHomeRecommendTableViewCell";
    KNBHomeRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[KNBHomeRecommendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.segmentedControl];
        [self.contentView addSubview:self.tableView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    KNB_WS(weakSelf);
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(45);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(weakSelf);
        make.top.equalTo(weakSelf.segmentedControl.mas_bottom).mas_offset(1);
        make.width.mas_equalTo(KNB_SCREEN_WIDTH);
    }];
}

+ (CGFloat)cellHeight {
    return 130 * 3 + 45;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - tableviewe delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KNBHomeRecommendSubTableViewCell *cell = [KNBHomeRecommendSubTableViewCell cellWithTableView:tableView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [KNBHomeRecommendSubTableViewCell cellHeight];
}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return CGFLOAT_MIN;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return CGFLOAT_MIN;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return nil;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    return nil;
//}

#pragma mark - lazy load
- (HMSegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[ @"装修公司", @"装修工长", @"设计师   ", @"家居建材" ]];
        _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:15.0]};
        _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithHex:0x009fe8], NSFontAttributeName : [UIFont systemFontOfSize:15.0]};
        _segmentedControl.selectionIndicatorColor = [UIColor colorWithHex:0x009fe8];
        _segmentedControl.selectionIndicatorHeight = 2.0;
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 40);
        KNB_WS(weakSelf);
        [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
            [weakSelf.tableView reloadData];
        }];
    }
    return _segmentedControl;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KNB_SCREEN_WIDTH, 300) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _tableView;
}

@end
