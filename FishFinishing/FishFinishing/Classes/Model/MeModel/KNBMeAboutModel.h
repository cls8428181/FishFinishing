//
//  KNBMeAboutModel.h
//  FishFinishing
//
//  Created by apple on 2019/4/26.
//  Copyright © 2019年 常立山. All rights reserved.
//

#import "KNBBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBMeAboutModel : KNBBaseModel
@property (nonatomic, copy) NSString *web_name;
@property (nonatomic, copy) NSString *company_name;
@property (nonatomic, copy) NSString *no_img;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *is_closed;
//支付协议
@property (nonatomic, copy) NSString *payment_agreement;
//是否打开支付
@property (nonatomic, copy) NSString *is_open_payment;
//系统电话
@property (nonatomic, copy) NSString *system_tellphone;
//备案号
@property (nonatomic, copy) NSString *keep_on_record;
@property (nonatomic, copy) NSString *copyright;
@property (nonatomic, copy) NSString *wechat_customer_service;
@property (nonatomic, copy) NSString *hotline;
@property (nonatomic, copy) NSString *reception_time;

@end

NS_ASSUME_NONNULL_END
