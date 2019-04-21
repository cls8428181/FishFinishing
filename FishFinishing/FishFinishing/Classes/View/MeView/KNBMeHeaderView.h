//
//  KNBMeHeaderView.h
//  FishFinishing
//
//  Created by 常立山 on 2019/3/29.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KNBMeHeaderView : UIView
@property (nonatomic, copy) void (^settingButtonBlock)(void);
@property (nonatomic, copy) void (^chatButtonBlock)(void);
@property (nonatomic, copy) void (^loginButtonBlock)(void);

@end

NS_ASSUME_NONNULL_END
