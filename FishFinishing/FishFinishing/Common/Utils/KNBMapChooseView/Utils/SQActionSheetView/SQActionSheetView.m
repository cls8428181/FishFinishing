//
//  SQActionSheetView.m
//  JHTDoctor
//
//  Created by yangsq on 2017/5/23.
//  Copyright © 2017年 yangsq. All rights reserved.
//

#import "SQActionSheetView.h"
#import "KNBMapHeader.h"

#define Margin  6
#define ButtonHeight  54
#define TitleHeight   30
#define LineHeight    0.5

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
@interface SQActionSheetView ()

@property (nonatomic, strong) UIToolbar *containerToolBar;
@property (nonatomic, assign) CGFloat toolbarH;
@end

@implementation SQActionSheetView

- (id)initWithTitle:(NSString *)title buttons:(NSArray<NSString *> *)buttons buttonClick:(void (^)(SQActionSheetView *, NSInteger))block{
    
    if (self = [super init]) {
        KNB_WS(weakSelf);
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _toolbarH = buttons.count*(ButtonHeight+LineHeight)+(buttons.count>1?Margin:0)+(title.length?TitleHeight:0);
        
        _containerToolBar = [[UIToolbar alloc]initWithFrame:(CGRect){0,CGRectGetHeight(self.frame),CGRectGetWidth(self.frame),_toolbarH}];
        _containerToolBar.clipsToBounds = YES;
        
        
        CGFloat buttonMinY = 0;
        
        if (title.length) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), TitleHeight)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor grayColor];
            label.text = title;
            [_containerToolBar addSubview:label];
            buttonMinY = TitleHeight;
        }
        
        [buttons enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.8];
            [button setTitle:obj forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:17]];
            button.tag = 101+idx;
            [button addTarget:weakSelf action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
            if (idx==buttons.count-1&&buttons.count>1) {
                button.frame = (CGRect){0,buttonMinY+(ButtonHeight+LineHeight)*idx+Margin,CGRectGetWidth(weakSelf.frame),ButtonHeight};
            }else{
                button.frame = (CGRect){0,buttonMinY+(ButtonHeight+LineHeight)*idx,CGRectGetWidth(weakSelf.frame),ButtonHeight};
            }
            
            [weakSelf.containerToolBar addSubview:button];
            
            if (idx<buttons.count-2) {
                UIView *view= [UIView new];
                view.backgroundColor = LINECOLOR;
                [weakSelf.containerToolBar addSubview:view];
                view.frame = CGRectMake(0, CGRectGetMaxY(button.frame), CGRectGetWidth(weakSelf.frame), LineHeight);
            }
            
        }];
        
        self.buttonClick = block;
        
    }
    
    
    return self;
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissView];
}

- (void)buttonTouch:(UIButton *)button{
    
    if (self.buttonClick) {
        self.buttonClick(self, button.tag-101);
    }
    [self dismissView];
    
}


- (void)showView{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication].keyWindow addSubview:_containerToolBar];
    KNB_WS(weakSelf);
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.containerToolBar.transform = CGAffineTransformMakeTranslation(0, -weakSelf.toolbarH);
        weakSelf.alpha = 1;

    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)dismissView{
    KNB_WS(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.containerToolBar.transform = CGAffineTransformIdentity;
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        [weakSelf.containerToolBar removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
