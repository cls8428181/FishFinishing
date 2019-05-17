//
//  CCTextView.h
//  FishFinishing
//
//  Created by apple on 2019/5/17.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCTextView : UITextView<UITextViewDelegate>

/// 最大字数，emoji算两个字，中英文都算一个字。
@property(nonatomic, assign) NSInteger maxLength;

/// 如果需要自定义UITextField的delegate，请用textField.bridgeDelegate = self 代替 textField.delegate = self
@property(nonatomic, weak) id<UITextViewDelegate> bridgeDelegate;

@end

NS_ASSUME_NONNULL_END
