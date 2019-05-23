//
//  KNBHomeExperienceFooterView.h
//  FishFinishing
//
//  Created by apple on 2019/5/5.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeExperienceFooterView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIButton *upgradeButton;
@property (nonatomic, copy) void (^upgradeButtonBlock)(void);
@property (nonatomic, copy) void (^serviceButtonBlock)(void);
@end

NS_ASSUME_NONNULL_END
