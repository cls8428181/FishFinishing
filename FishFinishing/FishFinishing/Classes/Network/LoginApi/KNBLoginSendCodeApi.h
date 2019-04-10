//
//  KNBLoginSendCodeApi.h
//  FishFinishing
//
//  Created by apple on 2019/4/10.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseRequest.h"
typedef NS_ENUM(NSInteger, KNBLoginSendCodeType) {
    KNBLoginSendCodeTypeRegister = 0,      //注册
    KNBLoginSendCodeTypeForgot               //找回密码
};

NS_ASSUME_NONNULL_BEGIN

@interface KNBLoginSendCodeApi : KNBBaseRequest

- (instancetype)initWithMobile:(NSString *)mobile type:(KNBLoginSendCodeType)type;
@end

NS_ASSUME_NONNULL_END
