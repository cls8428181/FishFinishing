//
//  KNBSearchBar.m
//  KenuoTraining
//
//  Created by 常立山 on 2018/12/26.
//  Copyright © 2018 Robert. All rights reserved.
//

#import "KNBSearchBar.h"
#import "UIColor+Hex.h"
#import "UIImage+Alpha.h"
#import "UIView+Utils.h"


@implementation KNBSearchBar
- (instancetype)initWithbBackgroudColor:(UIColor *)color borderColor:(nonnull UIColor *)borderColor {
    if (self = [super init]) {
        self.placeholder = @" 搜索    ";
        [self sizeToFit];
        //设置光标颜色
//        self.tintColor = [UIColor knRedColor];
        self.barTintColor = color;
        UITextField *searchField = [self valueForKey:@"_searchField"];
        searchField.backgroundColor = color;
        searchField.font = [UIFont systemFontOfSize:12];
        UIView *backgroundView = [self subViewOfClassName:@"UISearchBarBackground"];
        backgroundView.layer.borderWidth = 1;
        backgroundView.layer.borderColor = borderColor.CGColor;
        self.layer.cornerRadius = 15;
        self.layer.masksToBounds = YES;
    }
    return self;
}

@end
