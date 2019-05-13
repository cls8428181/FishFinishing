//
//  DesignSketchViewController.h
//  FishFinishing
//
//  Created by 常立山 on 2019/3/26.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DesignSketchViewController : KNBBaseViewController
@property (nonatomic, assign) BOOL isTabbar;

/**
 风格编号
 */
@property (nonatomic, assign) NSInteger style_id;

/**
 户型编号
 */
@property (nonatomic, assign) NSInteger apartment_id;

/**
 最小面积
 */
@property (nonatomic, assign) double min_area;

/**
 最大面积
 */
@property (nonatomic, assign) double max_area;
@end

NS_ASSUME_NONNULL_END
