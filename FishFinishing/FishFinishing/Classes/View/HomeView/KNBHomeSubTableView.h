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

@property (nonatomic, copy) void(^didSelectRowAtIndexPath)(NSIndexPath *indexPath);

@property (strong ,nonatomic) KNBHomeTableView *tableView;

- (instancetype)initWithFrame:(CGRect)frame dataSource:(nonnull NSArray *)dataSrouce;

- (void)reloadTableView:(NSArray *)dataArray;

@end

NS_ASSUME_NONNULL_END
