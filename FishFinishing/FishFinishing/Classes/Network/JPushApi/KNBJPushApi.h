//
//  KNBJPushApi.h
//  FishFinishing
//
//  Created by apple on 2019/4/27.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBJPushApi : KNBBaseRequest
- (instancetype)initWithRegistrationId:(NSString *)registrationId;

@end

NS_ASSUME_NONNULL_END
