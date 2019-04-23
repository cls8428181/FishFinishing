//
//  KNBHomeSubView.m
//  FishFinishing
//
//  Created by apple on 2019/4/18.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBHomeSubView.h"
#import "KNBHomeSubTableView.h"

@implementation KNBHomeSubView

- (instancetype)initWithFrame:(CGRect)frame index:(NSInteger)index dataSource:(nonnull NSArray *)dataSrouce
{
    self = [super initWithFrame:frame];
    if (self) {
        _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _contentView.contentSize = CGSizeMake(frame.size.width*5, frame.size.height);
        _contentView.pagingEnabled = YES;
        _contentView.bounces = YES;
        _contentView.delegate = self;
        _contentView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_contentView];
        
        for (int i=0; i<index; i++) {
            KNBHomeSubTableView *aSubTable = [[KNBHomeSubTableView alloc] initWithFrame:CGRectMake(i*frame.size.width, 0, frame.size.width, frame.size.height) dataSource:dataSrouce];
            aSubTable.tag = 10000 + i;
            [_contentView addSubview:aSubTable];
        }
        
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

- (void)reloadTableViewAtIndex:(NSInteger)index dataSource:(NSArray *)dataSource title:(nonnull NSString *)title {
    for (UIView *view in self.contentView.subviews) {
        if (view.tag == 10000 + index) {
            KNBHomeSubTableView *tableView = (KNBHomeSubTableView *)view;
            tableView.title = title;
            [tableView reloadTableView:dataSource];
        }
    }
}

@end
