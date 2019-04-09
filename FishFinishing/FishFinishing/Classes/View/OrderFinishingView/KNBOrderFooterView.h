//
//  KNBOrderFooterView.h
//  FishFinishing
//
//  Created by 常立山 on 2019/4/9.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KNBOrderFooterView : UIView

@property (nonatomic, copy) void(^enterButtonBlock)(void);

/**
 根据按钮标题创建
 */
- (instancetype)initWithButtonTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
