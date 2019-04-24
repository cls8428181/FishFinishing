//
//  KNBMeOrderAlertView.h
//  FishFinishing
//
//  Created by apple on 2019/4/24.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNBMeOrderModel.h"

typedef void (^EnterActionBlock)(void);
typedef void (^DeleteActionBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface KNBMeOrderAlertView : UIView

+ (void)showAlertViewWithModel:(KNBMeOrderModel *)model CompleteBlock:(EnterActionBlock)enterBlock deleteActionBlock:(DeleteActionBlock)deleteBlock;

@end

NS_ASSUME_NONNULL_END
