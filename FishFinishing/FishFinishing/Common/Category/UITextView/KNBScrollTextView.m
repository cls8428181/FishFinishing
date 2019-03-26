//
//  KNBScrollTextView.m
//  LMJScrollText
//
//  Created by shaMo on 2018/12/10.
//  Copyright © 2018 iOS开发者工会. All rights reserved.
//

#import "KNBScrollTextView.h"

@interface UILabel (KNBScrollTextViewExtension)

@property (nonatomic) id knb_text;

@end

@implementation UILabel (KNBScrollTextViewExtension)

- (id)knb_text{
    return self.text;
}

- (void)setKnb_text:(id)knb_text{
    if ([knb_text isKindOfClass:[NSAttributedString class]]) {
        self.attributedText = knb_text;
    }else if ([knb_text isKindOfClass:[NSString class]]){
        self.text = knb_text;
    }
}

@end

@implementation KNBScrollTextView
{
    UITapGestureRecognizer * _tapGesture;
    
    UILabel * _currentScrollLabel;
    UILabel * _standbyScrollLabel;
    
    NSInteger _index;
    
    BOOL _needStop;
    BOOL _isRunning;
    BOOL _isHaveSpace;
}

- (id)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20); 
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setInitialSettings];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setInitialSettings];
}

- (void)setInitialSettings{
    
    self.clipsToBounds = YES;
    
    _index = 0;
    
    _needStop  = NO;
    _isRunning = NO;
    
    _isHaveSpace = NO;
    
    _textDataArr   = @[];
    
    _textStayTime  = 3;
    _scrollAnimationTime = 1;
    
    _textFont      = [UIFont systemFontOfSize:12];
    _textColor     = [UIColor blackColor];
    _textAlignment = NSTextAlignmentLeft;
    
    _currentScrollLabel = nil;
    _standbyScrollLabel = nil;
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction)];
    [self addGestureRecognizer:_tapGesture];

}

#pragma mark - Action
- (void)clickAction{
    if ([self isCurrentViewControllerVisible:[self viewController]] && self.delegate && [self.delegate respondsToSelector:@selector(scrollTextView:clickIndex:content:)]) {
        [self.delegate scrollTextView:self clickIndex:_index content:[_textDataArr[_index] copy]];
    }
}

#pragma mark - Setter
- (void)setTextFont:(UIFont *)textFont{
    _textFont = textFont;
    _currentScrollLabel.font = textFont;
    _standbyScrollLabel.font = textFont;
}
- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    _currentScrollLabel.textColor = textColor;
    _standbyScrollLabel.textColor = textColor;
}
- (void)setTextAlignment:(NSTextAlignment)textAlignment{
    _textAlignment = textAlignment;
    _currentScrollLabel.textAlignment = textAlignment;
    _standbyScrollLabel.textAlignment = textAlignment;
}


#pragma mark - Start
- (void)startScroll{
    [self stop];
    if (_isRunning) {
        [self performSelector:@selector(startScroll) withObject:nil afterDelay:0.5f];
        return;
    }
    _isHaveSpace = YES;
    [self resetStateToEmpty];
    [self createScrollLabelNeedStandbyLabel:NO];
    [self scrollWithSpaceByDirection:@(1)];
}


#pragma mark - Stop
- (void)stop{
    _needStop = YES;
}

- (void)stopToEmpty{
    _needStop = YES;
    [self resetStateToEmpty];
}
#pragma mark - Clear / Create
- (void)resetStateToEmpty{
    if (_currentScrollLabel) {
        [_currentScrollLabel removeFromSuperview];
        _currentScrollLabel = nil;
    }
    if (_standbyScrollLabel) {
        [_standbyScrollLabel removeFromSuperview];
        _standbyScrollLabel = nil;
    }
    
    _index = 0;
    _needStop = NO;
}


- (void)createScrollLabelNeedStandbyLabel:(BOOL)isNeed{
    _currentScrollLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _currentScrollLabel.textAlignment = _textAlignment;
    _currentScrollLabel.textColor     = _textColor;
    _currentScrollLabel.font          = _textFont;
    [self addSubview:_currentScrollLabel];
    
    if (isNeed) {
        _standbyScrollLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -100, self.frame.size.width, self.frame.size.height)];
        _standbyScrollLabel.textAlignment = _textAlignment;
        _standbyScrollLabel.textColor     = _textColor;
        _standbyScrollLabel.font          = _textFont;
        [self addSubview:_standbyScrollLabel];
    }
}


#pragma mark - Scroll Action
- (void)scrollWithNoSpaceByDirection:(NSNumber *)direction{
    // 处于非当前页面，延迟尝试
    if (![self isCurrentViewControllerVisible:[self viewController]]) {
        [self performSelector:@selector(scrollWithNoSpaceByDirection:) withObject:direction afterDelay:3.f];
        // 处于当前页面
    }else{
        if (_textDataArr.count == 0) {
            _isRunning = NO;
            return;
        }else{
            _isRunning = YES;
        }
        
        _currentScrollLabel.knb_text  = _textDataArr[_index];
        _standbyScrollLabel.knb_text  = _textDataArr[[self nextIndex:_index]];
        _standbyScrollLabel.frame = CGRectMake(0, self.height*direction.integerValue, _standbyScrollLabel.width, _standbyScrollLabel.height);
        
        
        if ([self isCurrentViewControllerVisible:[self viewController]] && self.delegate && [self.delegate respondsToSelector:@selector(scrollTextView:currentTextIndex:)]) {
            [self.delegate scrollTextView:self currentTextIndex:self->_index];
        }
        
        
        [UIView animateWithDuration:_scrollAnimationTime delay:_textStayTime options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            self->_currentScrollLabel.frame = CGRectMake(0, -self.height*direction.integerValue, self->_currentScrollLabel.width, self->_currentScrollLabel.height);
            self->_standbyScrollLabel.frame = CGRectMake(0, 0, self->_standbyScrollLabel.width, self->_standbyScrollLabel.height);
            
        } completion:^(BOOL finished) {
            
            self->_index = [self nextIndex:self->_index];
            
            UILabel * temp = self->_currentScrollLabel;
            self->_currentScrollLabel = self->_standbyScrollLabel;
            self->_standbyScrollLabel = temp;
            
            if (self->_needStop) {
                self->_isRunning = NO;
            }else{
                [self performSelector:@selector(scrollWithNoSpaceByDirection:) withObject:direction];
            }
        }];
    }
}



- (void)scrollWithSpaceByDirection:(NSNumber *)direction{
    
    // 处于非当前页面，延迟尝试
    if (![self isCurrentViewControllerVisible:[self viewController]]) {
        [self performSelector:@selector(scrollWithSpaceByDirection:) withObject:direction afterDelay:3.f];
        
        // 处于当前页面
    }else{
        if (_textDataArr.count == 0) {
            _isRunning = NO;
            return;
        }else{
            _isRunning = YES;
        }
        
        _currentScrollLabel.knb_text  = _textDataArr[_index];
        _currentScrollLabel.frame = CGRectMake(0, 0, _currentScrollLabel.width, _currentScrollLabel.height);
        
        if ([self isCurrentViewControllerVisible:[self viewController]] && self.delegate && [self.delegate respondsToSelector:@selector(scrollTextView:currentTextIndex:)]){
            [self.delegate scrollTextView:self currentTextIndex:self->_index];
        }
        
        
        [UIView animateWithDuration:_scrollAnimationTime/2.f delay:_textStayTime options:UIViewAnimationOptionLayoutSubviews animations:^{
            self->_currentScrollLabel.frame = CGRectMake(0, -self.height*direction.integerValue, self->_currentScrollLabel.width, self->_currentScrollLabel.height);
            
            
        } completion:^(BOOL finished) {
            
            self->_currentScrollLabel.frame = CGRectMake(0, self.height*direction.integerValue, self->_currentScrollLabel.width, self->_currentScrollLabel.height);
            self->_index = [self nextIndex:self->_index];
            self->_currentScrollLabel.knb_text  = self->_textDataArr[self->_index];
            
            
            [UIView animateWithDuration:self->_scrollAnimationTime/2.f animations:^{
                self->_currentScrollLabel.frame = CGRectMake(0, 0, self->_currentScrollLabel.width, self->_currentScrollLabel.height);
                
            } completion:^(BOOL finished) {
                
                if (self->_needStop) {
                    self->_isRunning = NO;
                }else{
                    [self performSelector:@selector(scrollWithSpaceByDirection:) withObject:direction];
                }
            }];
        }];
    }
}

- (NSInteger)nextIndex:(NSInteger)index{
    NSInteger nextIndex = index + 1;
    if (nextIndex >= _textDataArr.count) {
        nextIndex = 0;
    }
    return nextIndex;
}

#pragma mark - State Check
-(BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController{
    return (viewController.isViewLoaded && viewController.view.window && [UIApplication sharedApplication].applicationState == UIApplicationStateActive);
}

- (UIViewController *)viewController {
    for (UIView * next = [self superview]; next; next = next.superview) {
        UIResponder * nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}



@end
