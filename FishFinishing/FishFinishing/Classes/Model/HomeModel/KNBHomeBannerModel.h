//
//  KNBHomeBannerModel.h
//  FishFinishing
//
//  Created by apple on 2019/4/12.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBHomeBannerModel : KNBBaseModel

/**
 bannerId
 */
@property (nonatomic, copy) NSString *bannerId;

/**
 banner 图片地址
 */
@property (nonatomic, copy) NSString *img;

/**
 url
 */
@property (nonatomic, copy) NSString *url;
@end

NS_ASSUME_NONNULL_END
