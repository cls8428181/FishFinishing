//
//  KNBHomeCompanyListHeaderView.h
//  FishFinishing
//
//  Created by 常立山 on 2019/4/8.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeCompanyListHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *middleButton;
@property (nonatomic, copy) void (^leftButtonBlock)(void);
@property (nonatomic, copy) void (^middleButtonBlock)(void);
@end

NS_ASSUME_NONNULL_END
