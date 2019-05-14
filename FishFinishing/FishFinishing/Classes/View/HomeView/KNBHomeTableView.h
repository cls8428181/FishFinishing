//
//  KNBHomeTableView.h
//  FishFinishing
//
//  Created by apple on 2019/4/18.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * _Nullable const kScrollStopNotificationName = @"scrollStop"; // 滚动停止通知

typedef NS_ENUM(NSInteger , KNBHomeTableViewType) {
    KNBHomeTableViewTypeMain,  // 父列表
    KNBHomeTableViewTypeSub    // 子列表
};

NS_ASSUME_NONNULL_BEGIN

@protocol KNBHomeTableViewDelegate;

@interface KNBHomeTableView : UITableView

/**
 tableview 类型
 */
@property (nonatomic, assign) KNBHomeTableViewType type;

@property (nonatomic,weak) id <KNBHomeTableViewDelegate> delegate_StayPosition;

@end

@protocol KNBHomeTableViewDelegate <NSObject>

@required

-(CGFloat)homeTableViewHeightForStayPosition:(KNBHomeTableView *)tableView; // 悬停的位置

@end

NS_ASSUME_NONNULL_END
