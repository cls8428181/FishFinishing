//
//  CCOrderAlertView.h
//  FishFinishing
//
//  Created by apple on 2019/5/22.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OrderActionBlock)(NSString * _Nullable nickName, NSString * _Nullable phone, NSString * _Nullable area, NSString * _Nullable address, NSString * _Nullable house);

NS_ASSUME_NONNULL_BEGIN

@interface CCOrderAlertView : UIView

+ (void)showAlertViewWithTitle:(NSString *)title imageUrl:(NSString *)url OrderBlock:(OrderActionBlock)orderBlock;

@end

NS_ASSUME_NONNULL_END
