//
//  KNBHomeCompanyListHeaderView.m
//  FishFinishing
//
//  Created by 常立山 on 2019/4/8.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeCompanyListHeaderView.h"

@interface KNBHomeCompanyListHeaderView ()

@end
@implementation KNBHomeCompanyListHeaderView
- (IBAction)styleButtonAction:(id)sender {
    !self.leftButtonBlock ?: self.leftButtonBlock();
}

- (IBAction)areaButtonAction:(id)sender {
    !self.middleButtonBlock ?: self.middleButtonBlock();
}
@end
