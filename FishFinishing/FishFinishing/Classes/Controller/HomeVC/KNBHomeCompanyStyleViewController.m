//
//  KNBHomeCompanyStyleViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/5/7.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeCompanyStyleViewController.h"
#import "FMTagsView.h"
#import "KNBRecruitmentCatChildApi.h"
#import "KNBHomeSingleAreaApi.h"
#import "KNBAddressModel.h"
#import "NSString+Size.h"
#import "KNBOrderStyleApi.h"

@interface KNBHomeCompanyStyleViewController ()<FMTagsViewDelegate>
//标签视图
@property (nonatomic, strong) FMTagsView *tagView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSArray *modelArray;
@end

@implementation KNBHomeCompanyStyleViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addUI];
    
    [self fetchData];
}

- (void)addUI {
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tagView];
}

- (void)fetchData {
    KNBRecruitmentCatChildApi *api = [[KNBRecruitmentCatChildApi alloc] initWithParentCatId:[self.model.typeId integerValue]];
    KNB_WS(weakSelf);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest *_Nonnull request) {
        if (api.requestSuccess) {
            [weakSelf.dataArray removeAllObjects];
            NSDictionary *dic = request.responseObject[@"list"];
            NSArray *modelArray = [KNBRecruitmentTypeModel changeResponseJSONObject:dic];
            [weakSelf.dataArray addObject:@"全部"];
            for (KNBRecruitmentTypeModel *model in modelArray) {
                [weakSelf.dataArray addObject:model.catName];
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
    NSString *selectString = nil;
    if (index == 0) {
        selectString = @"全部";
    } else {
        selectString = self.dataArray[index];
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:selectString,@"text", @"0",@"index", nil];
    NSNotification *notification = [NSNotification notificationWithName:NSStringFromClass([KNBHomeCompanyStyleViewController class]) object:nil userInfo:dict];
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
