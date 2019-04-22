//
//  KNBHomeCompanyAreaViewController.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/22.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeCompanyAreaViewController.h"
#import "FMTagsView.h"
#import "KNBRecruitmentCatChildApi.h"
#import "KNBHomeSingleAreaApi.h"
#import "KNBCityModel.h"
#import "NSString+Size.h"
#import "KNBOrderStyleApi.h"

@interface KNBHomeCompanyAreaViewController ()<FMTagsViewDelegate>
//标签视图
@property (nonatomic, strong) FMTagsView *tagView;
@property (nonatomic, strong) UIView *headerView;
@end

@implementation KNBHomeCompanyAreaViewController

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
    self.tagView.tagsArray = @[@"全部",@"50-80",@"80-100",@"100-120",@"120以上"];
    self.tagView.height = [self getTagsViewHeight];
}

- (NSInteger)getTagsViewHeight {
    CGFloat tagsWidth = 10;
    NSInteger lines = 1;
    for (NSString *name in self.tagView.tagsArray) {
        CGFloat tagWidth = [name widthWithFont:[UIFont systemFontOfSize:14] constrainedToHeight:16] + 26;
        if (tagWidth < 75) {
            tagWidth = 75;
        }
        if (tagsWidth + tagWidth > KNB_SCREEN_WIDTH) {
            tagsWidth = 10;
            lines++;
        }
        tagsWidth = tagsWidth + tagWidth;
    }
    return lines * 40 + 10;
}

- (void)tagsView:(FMTagsView *)tagsView didSelectTagAtIndex:(NSUInteger)index {
    NSString *selectString = tagsView.tagsArray[index];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:selectString,@"text", nil];
    NSNotification *notification = [NSNotification notificationWithName:NSStringFromClass([KNBHomeCompanyAreaViewController class]) object:nil userInfo:dict];
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

@end
