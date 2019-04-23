//
//  KNBOrderAlertView.h
//  Concubine
//
//  Created by 王明亮 on 2017/11/9.
//  Copyright © 2017年 dengyun. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^EnterActionBlock)(void);

@interface KNBOrderAlertView : UIView
@property (nonatomic, retain) UILabel *contentLab;
@property (nonatomic, strong) UILabel *titleLab;

+ (void)showAlertViewCompleteBlock:(EnterActionBlock)enterBlock;
@end
