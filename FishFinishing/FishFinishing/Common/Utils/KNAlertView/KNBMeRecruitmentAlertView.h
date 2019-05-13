//
//  KNBMeRecruitmentAlertView.h
//  FishFinishing
//
//  Created by apple on 2019/5/5.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^RecruitmentActionBlock)(void);
typedef void (^ExperienceActionBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface KNBMeRecruitmentAlertView : UIView

+ (void)showAlertViewRecruitmentBlock:(RecruitmentActionBlock)recruitmentBlock experienceBlock:(ExperienceActionBlock)experienceBlock;

@end

NS_ASSUME_NONNULL_END
