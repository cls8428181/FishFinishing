//
//  KNBHomeHeaderView.h
//  FishFinishing
//
//  Created by apple on 2019/5/16.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KNBHomeHeaderViewDelete <NSObject>
@optional
- (void)homeCycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

@end

@interface KNBHomeHeaderView : UIView

@property (nonatomic, assign) id <KNBHomeHeaderViewDelete>delegate;

- (instancetype)initWithDataSource:(NSArray *)dataSource;

@end

NS_ASSUME_NONNULL_END
