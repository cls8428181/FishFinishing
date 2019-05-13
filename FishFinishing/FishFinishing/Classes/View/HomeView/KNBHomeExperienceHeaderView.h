//
//  KNBHomeExperienceHeaderView.h
//  FishFinishing
//
//  Created by apple on 2019/5/5.
//  Copyright © 2019 常立山. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KNBHomeBannerModel.h"
#import "KNBHomeServiceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeExperienceHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *markLabel;
@property (nonatomic, strong) KNBHomeBannerModel *bannerModel;
@property (nonatomic, strong) KNBHomeServiceModel *serviceModel;
@end

NS_ASSUME_NONNULL_END
