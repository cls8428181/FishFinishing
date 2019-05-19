//
//  KNBHomeCompanyHouseViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/22.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeCompanyHouseViewController.h"
#import "KNBChoiceTableViewCell.h"
#import "KNBRecruitmentTypeModel.h"
#import "KNBOrderUnitApi.h"
#import "FMTagsView.h"
#import "NSString+Size.h"

@interface KNBHomeCompanyHouseViewController ()<FMTagsViewDelegate>
//标签视图
@property (nonatomic, strong) FMTagsView *tagView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *modelArray;
@end

@implementation KNBHomeCompanyHouseViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addUI];
    
    [self fetchData];
}

#pragma mark - Utils
- (void)addUI {
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tagView];
}

- (void)fetchData {
    KNBOrderUnitApi *api = [[KNBOrderUnitApi alloc] init];
    api.hudString = @"";
    KNB_WS(weakSelf);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            [weakSelf.dataArray removeAllObjects];
            NSDictionary *dic = request.responseObject[@"list"];
            NSArray *modelArray = [KNBRecruitmentUnitModel changeResponseJSONObject:dic];
            // 给数据源赋值
            weakSelf.modelArray = modelArray;
            [weakSelf.dataArray addObject:@"全部"];
            for (KNBRecruitmentUnitModel *model in modelArray) {
                [weakSelf.dataArray addObject:model.name];
            }
            weakSelf.tagView.tagsArray = weakSelf.dataArray;
            weakSelf.tagView.height = [self getTagsViewHeight];
        }
    } failure:^(__kindof YTKBaseRequest *_Nonnull request) {
    }];
    

}

- (NSInteger)getTagsViewHeight {
    CGFloat tagsWidth = 0;
    CGFloat space = 17;
    NSInteger lines = 1;
    for (NSString *name in self.dataArray) {
        CGFloat tagWidth = [name widthWithFont:[UIFont systemFontOfSize:14] constrainedToHeight:16] + 26;
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

- (void)tagsView:(FMTagsView *)tagsView didSelectTagAtIndex:(NSUInteger)index {
    KNBRecruitmentUnitModel *model = nil;
    if (index == 0) {
        model = [[KNBRecruitmentUnitModel alloc] init];
        model.name = @"全部";
        model.houseId = @"0";
    } else {
        model = self.modelArray[index - 1];
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:model,@"model", nil];
    NSNotification *notification = [NSNotification notificationWithName:NSStringFromClass([KNBHomeCompanyHouseViewController class]) object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

#pragma mark - Getters And Setters
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
        _headerView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, 5);
    }
    return _headerView;
}

- (FMTagsView *)tagView {
    if (!_tagView) {
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
        _tagView = tagView;
    }
    return _tagView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
