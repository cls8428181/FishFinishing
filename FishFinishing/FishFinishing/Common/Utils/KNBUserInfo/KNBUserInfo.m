//
//  KNBUserInfo.m
//  KNBeautyMedical
//
//  Created by 常立山 on 2017/12/12.
//  Copyright © 2017年 DengYun. All rights reserved.
//

#import "KNBUserInfo.h"
#import "KNBPushManager.h"
//#import "DateTools.h"
static NSString *const KNB_USER_LOGINSUCCESS = @"KNB_USER_LOGINSUCCESS";
// 版本更新判断是否重新登录
static NSString *const KNB_SAVE_LOGIN_VERSION = @"KNB_SAVE_LOGIN_VERSION";
static NSString *const KNB_USER_SIGNIN = @"KNB_USERSIGNIN";
static NSString *const KNB_USER_INFO = @"KNB_USER_INFO";
static NSString *const KNB_USER_ID = @"id";
static NSString *const KNB_USER_USERNAME = @"username";
static NSString *const KNB_USER_NICKNAME = @"nickname";
static NSString *const KNB_USER_PASSWORD = @"password";
static NSString *const KNB_USER_PORTRAIT = @"portrait_img";
static NSString *const KNB_USER_SEX = @"sex";
static NSString *const KNB_USER_BIRTHDAY = @"birthday";
static NSString *const KNB_USER_QQ = @"qq";
static NSString *const KNB_USER_EMAIL = @"email";
static NSString *const KNB_USER_MOBILE = @"mobile";
static NSString *const KNB_USER_REGISTERTIME = @"reg_time";
static NSString *const KNB_USER_REGISTERIP = @"reg_ip";
static NSString *const KNB_USER_LASTLOGINTIME = @"last_login_time";
static NSString *const KNB_USER_LASTLOGINIP = @"last_login_ip";
static NSString *const KNB_USER_UPDATEDAT = @"updated_at";
static NSString *const KNB_USER_STATUS = @"status";
static NSString *const KNB_USER_AUTHSTATUS = @"auth_status";
static NSString *const KNB_USER_ENABLE = @"enable";
static NSString *const KNB_USER_TOKEN = @"token";
static NSString *const KNB_USER_TOKENOUTTIME = @"token_out_time";
static NSString *const KNB_USER_OPENID = @"openid";
static NSString *const KNB_USER_REGISTERTYPE = @"reg_type";
static NSString *const KNB_USER_FACID = @"fac_id";
static NSString *const KNB_USER_FACNAME = @"fac_name";
static NSString *const KNB_USER_JPUSHID = @"registrationID";
static NSString *const KNB_USER_EXPERIENCE = @"is_experience";
static NSString *const KNB_USER_CACHETOKEN = @"KNB_USER_CACHETOKEN";

@implementation KNBUserInfo

KNB_DEFINE_SINGLETON_FOR_CLASS(KNBUserInfo);

- (BOOL)isLogin {
    return [self userInfo] ? YES : NO;
}

- (void)registUserInfo:(NSDictionary *)userInfo {
    NSDate *date = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:date
                                              forKey:KNB_LoginDate];
    [self registUserInfo:userInfo updateUserToken:YES];
}

- (void)updateUserInfo:(NSDictionary *)userInfo {
    [self registUserInfo:userInfo updateUserToken:YES];
}

- (void)registUserInfo:(NSDictionary *)userInfo
       updateUserToken:(BOOL)update {
    NSDictionary *dic = [self changeNullValue:userInfo];
    [[NSUserDefaults standardUserDefaults] setObject:dic
                                              forKey:KNB_USER_INFO];

    if (update && !isNullStr(dic[KNB_USER_TOKEN])) { // 缓存一份userToken
        [[NSUserDefaults standardUserDefaults] setObject:dic[KNB_USER_TOKEN] forKey:KNB_USER_CACHETOKEN];
    }
    [[KNBPushManager shareInstance] settingRegistrationID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary *)changeNullValue:(NSDictionary *)dic {
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    for (NSString *key in dic.allKeys) {
        if ([dic[key] isKindOfClass:[NSNull class]]) {
            [muDic setValue:@"" forKey:key];
        }
    }
    return muDic;
}

- (void)logout {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KNB_USER_LOGINSUCCESS];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KNB_USER_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)syncUserInfo:(NSDictionary *)userInfo {
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    [self registUserInfo:muDic];
}

//修改密码成功
- (void)modifyPasswordSuccess {
    [KNB_AppDelegate.navController popToRootViewControllerAnimated:false];
    [KNB_AppDelegate.tabBarController turnToControllerIndex:3];
    [[KNBUserInfo shareInstance] logout];
    [KNB_AppDelegate presentLoginViewController];
}

/**
 需要重新登录
 */
//- (BOOL)needLoginAgain {
//    NSString *loginVersion = [[NSUserDefaults standardUserDefaults] objectForKey:KNB_SAVE_LOGIN_VERSION];
//    if (!loginVersion || ![loginVersion isEqualToString:KNB_APP_VERSION]) {
//        [[NSUserDefaults standardUserDefaults] setObject:KNB_APP_VERSION forKey:KNB_SAVE_LOGIN_VERSION];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        return YES;
//    }
//    return NO;
//}

- (NSDictionary *)userInfo {
    return [[NSUserDefaults standardUserDefaults] objectForKey:KNB_USER_INFO];
}

- (NSString *)userId {
    return [self.userInfo objectForKey:KNB_USER_ID];
}

- (NSString *)userName {
    return [self.userInfo objectForKey:KNB_USER_USERNAME];
}

- (NSString *)nickName {
    return [self.userInfo objectForKey:KNB_USER_NICKNAME];
}

- (NSString *)password {
    return [self.userInfo objectForKey:KNB_USER_PASSWORD];
}

- (NSString *)portrait {
    return [self.userInfo objectForKey:KNB_USER_PORTRAIT];
}

- (NSString *)sex {
    return [self.userInfo objectForKey:KNB_USER_SEX];
}

- (NSString *)mobile {
    return [self.userInfo objectForKey:KNB_USER_MOBILE];
}

- (NSString *)birthday {
    return [self.userInfo objectForKey:KNB_USER_BIRTHDAY];
}

- (NSString *)qq {
    return [self.userInfo objectForKey:KNB_USER_QQ];
}

- (NSString *)email {
    return [self.userInfo objectForKey:KNB_USER_EMAIL];
}

- (NSString *)registerTime {
    return [self.userInfo objectForKey:KNB_USER_REGISTERTIME];
}

- (NSString *)registerIP {
    return [self.userInfo objectForKey:KNB_USER_REGISTERIP];
}

- (NSString *)lastLoginTime {
    return [self.userInfo objectForKey:KNB_USER_LASTLOGINTIME];
}

- (NSString *)lastLoginIP {
    return [self.userInfo objectForKey:KNB_USER_LASTLOGINIP];
}

- (NSString *)updatedAt {
    return [self.userInfo objectForKey:KNB_USER_UPDATEDAT];
}

- (NSString *)status {
    return [self.userInfo objectForKey:KNB_USER_STATUS];
}

- (NSString *)authStatus {
    return [self.userInfo objectForKey:KNB_USER_AUTHSTATUS];
}

- (NSString *)enable {
    return [self.userInfo objectForKey:KNB_USER_ENABLE];
}

- (NSString *)token {
    return [self.userInfo objectForKey:KNB_USER_TOKEN];
}

- (NSString *)tokenOutTime {
    return [self.userInfo objectForKey:KNB_USER_TOKENOUTTIME];
}

- (NSString *)openId {
    return [self.userInfo objectForKey:KNB_USER_OPENID];
}

- (NSString *)registerType {
    return [self.userInfo objectForKey:KNB_USER_REGISTERTYPE];
}

- (NSString *)fac_id {
    return [self.userInfo objectForKey:KNB_USER_FACID];
}

- (NSString *)fac_name {
    return [self.userInfo objectForKey:KNB_USER_FACNAME];
}

- (NSString *)registrationID {
    return [[NSUserDefaults standardUserDefaults] objectForKey:KNB_USER_JPUSHID];
}


- (BOOL)isService {
    return (isNullStr(self.fac_id) || [self.fac_id isEqualToString:@"0"]) ? NO : YES;
}

- (NSString *)isExperience {
    return [self.userInfo objectForKey:KNB_USER_EXPERIENCE];
}

@end
