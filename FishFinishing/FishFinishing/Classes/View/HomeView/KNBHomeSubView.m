//
//  KNBHomeSubView.m
//  FishFinishing
//
//  Created by apple on 2019/4/18.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBHomeSubView.h"

@interface KNBHomeSubView ()

@end

@implementation KNBHomeSubView

- (instancetype)initWithFrame:(CGRect)frame index:(NSInteger)index dataSource:(nonnull NSArray *)dataSrouce
{
    self = [super initWithFrame:frame];
    if (self) {
        _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _contentView.contentSize = CGSizeMake(frame.size.width, frame.size.height);
        _contentView.pagingEnabled = YES;
        _contentView.bounces = YES;
        _contentView.delegate = self;
        _contentView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_contentView];
        
        _tableView = [[KNBHomeSubTableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) dataSource:dataSrouce];
        [_contentView addSubview:_tableView];
        
    }
    return self;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger pageNum = offsetX/[UIScreen mainScreen].bounds.size.width;
    if (self.scrollEventBlock) {
        self.scrollEventBlock(pageNum);
    }
}

- (void)reloadTableViewAtIndex:(NSInteger)index dataSource:(NSArray *)dataSource title:(nonnull NSString *)title page:(NSInteger)page {
    self.tableView.title = title;
    [self.tableView reloadTableView:dataSource page:page];
}

@end
