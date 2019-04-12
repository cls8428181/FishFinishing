//
//  KNBHomeCityHeaderView.h
//  Concubine
//
//  Created by 吴申超 on 2017/5/13.
//  Copyright © 2017年 dengyun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^KNHomeCityHeaderAllCityBlock)(void);

typedef NS_ENUM(NSInteger, KNHomeCityHeaderType) {
    KNHomeCityHeaderCustom,
    KNHomeCityHeaderBeauty,
};

@interface KNBHomeCityHeaderView : UIView

@property (nonatomic, copy) KNHomeCityHeaderAllCityBlock allCityBlock;

@property (nonatomic, copy) NSString *currentCityName;

- (instancetype)initWithViewType:(KNHomeCityHeaderType)headerType;

- (CGFloat)cityHeaderViewHeight;

@end
