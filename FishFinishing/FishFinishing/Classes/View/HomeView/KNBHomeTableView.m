//
//  KNBHomeTableView.m
//  FishFinishing
//
//  Created by apple on 2019/4/18.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBHomeTableView.h"

@interface KNBHomeTableView ()
@property (assign, nonatomic) BOOL canScroll;
@end

@implementation KNBHomeTableView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollStop:) name:kScrollStopNotificationName object:nil];
        self.canScroll = YES;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollStop:) name:kScrollStopNotificationName object:nil];
        self.canScroll = YES;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollStop:) name:kScrollStopNotificationName object:nil];
        self.canScroll = YES;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}


-(void)setType:(KNBHomeTableViewType)type{
    _type = type;
    self.canScroll = type==KNBHomeTableViewTypeSub?NO:YES;   // 子table默认不可滚动
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if (self.type==KNBHomeTableViewTypeMain) {   // 主table类型的需要兼容手势
        return YES;
    }
    return NO;
}


- (void)setContentOffset:(CGPoint)contentOffset{
    [super setContentOffset:contentOffset];
    CGFloat y = contentOffset.y;
    if(self.type == KNBHomeTableViewTypeMain){   // main类型
        CGFloat stayPosition = self.tableHeaderView.frame.size.height;  // 默认停留的位置
        if ([self.delegate_StayPosition respondsToSelector:@selector(homeTableViewHeightForStayPosition:)]) {
            stayPosition = [self.delegate_StayPosition homeTableViewHeightForStayPosition:self];  // 获取到停留的位置
        }
        if(self.canScroll == YES){
            if(y > stayPosition){
                contentOffset.y = stayPosition;
                [super setContentOffset:contentOffset];
                self.canScroll = NO;
                // 发送通知，主类不可滚动
                [[NSNotificationCenter defaultCenter] postNotificationName:kScrollStopNotificationName object:self userInfo:nil];
            }else{ // main正常滚动
                [super setContentOffset:contentOffset];
            }
        }else{ // main禁止滚动
            contentOffset.y = stayPosition;
            [super setContentOffset:contentOffset];
        }
    }else if(self.type == KNBHomeTableViewTypeSub){ // sub类型
        if(self.canScroll == YES){
            if(y < 0){
                contentOffset.y = 0;
                [super setContentOffset:contentOffset];
                self.canScroll = NO;
                // 发送通知，子类不可滚动
                [[NSNotificationCenter defaultCenter] postNotificationName:kScrollStopNotificationName object:self userInfo:nil];
            }else{ // sub正常滚动
                [super setContentOffset:contentOffset];
            }
        }else{ // sub禁止滚动
            contentOffset.y = 0;
            [super setContentOffset:contentOffset];
        }
    }else{
        [super setContentOffset:contentOffset];
    }
}


- (void)scrollStop:(NSNotification *)notification{
    KNBHomeTableView *table = notification.object;
    if(self != table){  // 发送通知的table和当前self不是同一个时，则需要滚动
        self.canScroll = YES;
    }
    // 把其他所有的sub都移动到顶部,除去主的，其他table皆不能滚动
    if (table.type == KNBHomeTableViewTypeSub && self.type == KNBHomeTableViewTypeSub) {
        [self setContentOffset:CGPointZero];
        self.canScroll = NO;
    }
}

@end
