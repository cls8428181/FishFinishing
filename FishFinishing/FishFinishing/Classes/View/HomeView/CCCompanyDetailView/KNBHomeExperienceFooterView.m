//
//  KNBHomeExperienceFooterView.m
//  FishFinishing
//
//  Created by apple on 2019/5/5.
//  Copyright © 2019 常立山. All rights reserved.
//

#import "KNBHomeExperienceFooterView.h"

@interface KNBHomeExperienceFooterView ()
@property (weak, nonatomic) IBOutlet UIButton *serviceButton;

@end

@implementation KNBHomeExperienceFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)upgradeButtonAction:(id)sender {
    !self.upgradeButtonBlock ?: self.upgradeButtonBlock();
}
- (IBAction)serviceButtonAction:(id)sender {
    !self.serviceButtonBlock ?: self.serviceButtonBlock();
}

@end
