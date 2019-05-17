//
//  CCTextView.m
//  FishFinishing
//
//  Created by apple on 2019/5/17.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "CCTextView.h"
#import "UITextView+ZWPlaceHolder.h"

@implementation CCTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self commonSetup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]){
        [self commonSetup];
    }
    return self;
}

- (void)commonSetup
{
    _maxLength = 0;
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewDidChange:) name:@"UITextViewTextDidChangeNotification" object:self];
    self.delegate = self;
}

/**
 主要是用于中文输入的场景
 剩余的允许输入的字数较少时，限制拼音字符的输入，提升体验
 */
- (NSInteger)allowMaxMarkLength:(NSInteger)remainLength
{
    NSInteger length = 0;
    if(remainLength > 2){
        length = NSIntegerMax;
    }else if(remainLength > 0){
        length = remainLength * 6;  //一个中文对应的拼音一般不超过6个
    }
    
    return length;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(_maxLength <= 0){
        return;
    }
    NSString *text = textView.text;
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    
    //没有高亮选择的字，则对已输入的文字进行字数统计和限制,防止中文/emoj被截断
    if (!position){
        if (text.length > _maxLength){
            NSRange rangeIndex = [text rangeOfComposedCharacterSequenceAtIndex:_maxLength];
            if (rangeIndex.length == 1){
                textView.text = [text substringToIndex:_maxLength];
            }else{
                if(_maxLength == 1){
                    textView.text = @"";
                }else{
                    NSRange rangeRange = [text rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, _maxLength - 1 )];
                    textView.text = [text substringWithRange:rangeRange];
                }
            }
            
        }
    }
}

#pragma mark -- UItextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(nonnull NSString *)text
{
    if([_bridgeDelegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]){
        return [_bridgeDelegate textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    
    if(_maxLength <= 0){
        return YES;
    }
    
    UITextRange *selectedRange = [textView markedTextRange];//高亮选择的字
    UITextPosition *startPos = [textView positionFromPosition:selectedRange.start offset:0];
    UITextPosition *endPos = [textView positionFromPosition:selectedRange.end offset:0];
    NSInteger markLength = [textView offsetFromPosition:startPos toPosition:endPos];
    
    NSInteger confirmlength =  textView.text.length - markLength - range.length;//已经确认输入的字符长度
    if(confirmlength >= _maxLength ){
        return NO;
    }
    
    NSInteger allowMaxMarkLength = [self allowMaxMarkLength:_maxLength - confirmlength];
    if(markLength > allowMaxMarkLength ){// && string.length > 0){
        return NO;
    }
    return YES;
}

// return NO to disallow editing.
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([_bridgeDelegate respondsToSelector:@selector(textViewShouldBeginEditing:)]){
        return [_bridgeDelegate textViewShouldBeginEditing:textView];
    }else{
        return YES;
    }
}

// became first responder
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([_bridgeDelegate respondsToSelector:@selector(textViewDidBeginEditing:)]){
        [_bridgeDelegate textViewDidBeginEditing:textView];
    }
}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if([_bridgeDelegate respondsToSelector:@selector(textViewShouldEndEditing:)]){
        return [_bridgeDelegate textViewShouldEndEditing:textView];
    }else{
        return YES;
    }
    
}

// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if([_bridgeDelegate respondsToSelector:@selector(textViewDidEndEditing:)]){
        [_bridgeDelegate textViewDidEndEditing:textView];
    }
}

@end
