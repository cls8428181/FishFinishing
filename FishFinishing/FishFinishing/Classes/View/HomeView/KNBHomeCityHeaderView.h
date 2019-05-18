//
//  KNBHomeCityHeaderView.h
//  Concubine
//
//  Created by 吴申超 on 2017/5/13.
//  Copyright © 2017年 dengyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNBCityModel.h"

typedef void(^KNHomeCityHeaderAllCityBlock)(void);

@interface KNBHomeCityHeaderView : UIView

+ (CGFloat)cityHeaderViewHeight;

@property (nonatomic, copy) void (^selectComplete)(KNBCityModel *cityModel);

@end
