//
//  WStartPageView.h
//  Freedom
//
//  Created by 吴申超 on 15/12/21.
//  Copyright © 2015年 Freedom. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KNBStartPageView;
@protocol WStartPageViewDelegate <NSObject>

- (void)wstartPageView:(KNBStartPageView *)pageView
                cancel:(UIButton *)cancel;

@end


@interface KNBStartPageView : UIView

@property (nonatomic, weak) id<WStartPageViewDelegate> delegate;
@property (nonatomic, copy) NSDictionary *pageDic;
@property (nonatomic, assign) NSInteger index;

+ (KNBStartPageView *)creatStartPageView:(CGRect)frame;

@end
