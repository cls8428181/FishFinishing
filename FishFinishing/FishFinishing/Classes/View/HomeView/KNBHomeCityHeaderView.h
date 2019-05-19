//
//  KNBHomeCityHeaderView.h
//  Concubine
//
//  Created by 吴申超 on 2017/5/13.
//  Copyright © 2017年 dengyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNBCityModel.h"
#import "FMTagsView.h"

typedef void(^KNHomeCityHeaderAllCityBlock)(void);

@interface KNBHomeCityHeaderView : UIView

/**
 headerview 的高度
 */
+ (CGFloat)cityHeaderViewHeight;

/**
 选择城市后的回调
 */
@property (nonatomic, copy) void (^selectComplete)(KNBCityModel *cityModel);

/**
 清除回调
 */
@property (nonatomic, copy) void (^clearComplete)(void);

@end
