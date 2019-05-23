//
//  CCOrderAlertTextView.h
//  FishFinishing
//
//  Created by apple on 2019/5/23.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CCOrderAlertTextViewType) {
    CCOrderAlertTextViewTypeNickName = 1,      //昵称
    CCOrderAlertTextViewTypePhone,             //电话
    CCOrderAlertTextViewTypeArea,              //面积
    CCOrderAlertTextViewTypeAddress            //小区名称
};

NS_ASSUME_NONNULL_BEGIN

@interface CCOrderAlertTextView : UIView
@property (nonatomic, strong) UITextField *detailTextField;
@property (nonatomic, assign) CCOrderAlertTextViewType type;
@end

NS_ASSUME_NONNULL_END
