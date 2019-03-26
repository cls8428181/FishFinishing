//
//  KNBScrollTextView.h
//  LMJScrollText
//
//  Created by shaMo on 2018/12/10.
//  Copyright © 2018 iOS开发者工会. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KNBScrollTextView;

NS_ASSUME_NONNULL_BEGIN

@protocol KNBScrollTextViewDelegate <NSObject>

@optional
- (void)scrollTextView:(KNBScrollTextView *)scrollTextView currentTextIndex:(NSInteger)index;
- (void)scrollTextView:(KNBScrollTextView *)scrollTextView clickIndex:(NSInteger)index content:(NSString *)content;

@end

@interface KNBScrollTextView : UIView

@property (nonatomic, weak) id <KNBScrollTextViewDelegate>delegate;
// 文字集合 支持富文本
@property (nonatomic, copy) NSArray * textDataArr;
// 停留时长
@property (nonatomic, assign) CGFloat textStayTime;
// 文字滚动时长
@property (nonatomic, assign) CGFloat scrollAnimationTime;
// 字体大小
@property (nonatomic, copy) UIFont  * textFont;
// 字体颜色
@property (nonatomic, copy) UIColor * textColor;
// 字体位置
@property (nonatomic) NSTextAlignment textAlignment;

- (void)startScroll;
- (void)stop;
- (void)stopToEmpty;

@end

NS_ASSUME_NONNULL_END
