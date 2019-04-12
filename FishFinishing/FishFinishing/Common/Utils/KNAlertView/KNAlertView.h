//
//  KNAlertView.h
//  Concubine
//
//  Created by ... on 16/6/21.
//  Copyright © 2016年 dengyun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^KNAlertViewBlock)(NSInteger selectIndex);


@interface KNAlertView : NSObject

//default @[@"不了",@"确定"]
@property (nonatomic, strong) NSArray *buttonsTitle;

@property (nonatomic, copy) KNAlertViewBlock alterBlock;
@property (nonatomic, strong) NSAttributedString *attributedString;
- (instancetype)initAlterTitle:(NSString *)title;

- (void)showAlterView;

@end
