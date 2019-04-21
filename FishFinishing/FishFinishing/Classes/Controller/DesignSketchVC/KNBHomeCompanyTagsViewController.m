//
//  KNBHomeCompanyTagsViewController.m
//  FishFinishing
//
//  Created by apple on 2019/4/18.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBHomeCompanyTagsViewController.h"
#import "FMTagsView.h"

@interface KNBHomeCompanyTagsViewController ()<FMTagsViewDelegate>
//标签视图
@property (nonatomic, strong) FMTagsView *tagView;

@end

@implementation KNBHomeCompanyTagsViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addUI];
    
    [self fetchData];
}

- (void)addUI {
    [self.view addSubview:self.tagView];
    self.tagView.tagsArray = @[@"简约",@"中式",@"地中海",@"美式"];
}

- (void)fetchData {
    
}

#pragma mark - Getters And Setters
- (FMTagsView *)tagView {
    if (!_tagView) {
        FMTagsView *tagView = [[FMTagsView alloc] init];
        tagView.frame = CGRectMake(0, 0, KNB_SCREEN_WIDTH, 100);
        tagView.contentInsets = UIEdgeInsetsMake(13, 13, 13, 13);
        tagView.tagInsets = UIEdgeInsetsMake(0.5, 8.5, 0.5, 9);
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
        tagView.allowsMultipleSelection = YES;
        tagView.collectionView.scrollEnabled = NO;
        tagView.collectionView.showsVerticalScrollIndicator = NO;
        tagView.tagHeight = 30;
        tagView.mininumTagWidth = 75;
        tagView.maximumNumberOfSelection = 3;
        tagView.delegate = self;
        _tagView = tagView;
    }
    return _tagView;
}
@end
