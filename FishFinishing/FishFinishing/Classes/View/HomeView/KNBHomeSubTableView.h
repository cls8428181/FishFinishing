//
//  KNBHomeSubTableView.h
//  FishFinishing
//
//  Created by apple on 2019/4/18.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNBHomeTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeSubTableView : UIView<UITableViewDelegate,UITableViewDataSource>

/**
 标题
 */
@property (nonatomic, copy) NSString *title;

/**
 数据源
 */
@property (nonatomic, strong) NSMutableArray *dataArray;


@property (nonatomic, copy) void(^didSelectRowAtIndexPath)(NSIndexPath *indexPath);

@property (strong ,nonatomic) KNBHomeTableView *tableView;

- (instancetype)initWithFrame:(CGRect)frame dataSource:(nonnull NSArray *)dataSrouce;

- (void)reloadTableView:(NSArray *)dataSource page:(NSInteger)page;

@end

NS_ASSUME_NONNULL_END
