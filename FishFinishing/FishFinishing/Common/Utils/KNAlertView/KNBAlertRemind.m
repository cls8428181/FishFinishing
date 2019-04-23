//
//  KNBAlertRemind.m
//  KenuoTraining
//
//  Created by 妖狐小子 on 2017/2/17.
//  Copyright © 2017年 Robert. All rights reserved.
//

#import "KNBAlertRemind.h"
#import "AppDelegate.h"


@implementation KNBAlertRemind

+ (instancetype)sharedInstance {
    static KNBAlertRemind *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (void)alterWithTitle:(NSString *)title
               message:(NSString *)message
          buttonTitles:(NSArray *)buttonTitles
               handler:(void (^)(NSInteger index, NSString *title))handler {
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    for (int i = 0; i < buttonTitles.count; i++) {
        NSString *buttonTitle = buttonTitles[i];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:buttonTitle
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *_Nonnull action) {
                                                               if (handler) {
                                                                   handler(i, buttonTitle);
                                                               }
                                                           }];
        [alter addAction:sureAction];
    }
    [self.currentViewController presentViewController:alter animated:YES completion:nil];
}

+ (UIViewController *)currentViewController {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }

    UIViewController *currentVC = window.rootViewController;
    while (currentVC.presentedViewController) {
        currentVC = currentVC.presentedViewController;
    }
    if ([currentVC isKindOfClass:[UINavigationController class]]) {
        currentVC = [(UINavigationController *)currentVC topViewController];
    }
    return currentVC;
}


- (void)addAlertRemindWithController:(UIViewController *)controller
                               title:(NSString *)title
                             message:(NSString *)message
                   cancelButtonTitle:(NSString *)cancleBtnTitle
                   otherButtonTitles:(NSArray *)otherButtonTitles
                clickedButtonAtIndex:(void (^)(NSInteger))handler {
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    for (int i = 0; i < otherButtonTitles.count; i++) {
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:otherButtonTitles[i]
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *_Nonnull action) {
                                                               if (handler) {
                                                                   handler(i);
                                                               }
                                                           }];
        [alter addAction:sureAction];
    }
    if (cancleBtnTitle.length != 0 && cancleBtnTitle != nil) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancleBtnTitle
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *_Nonnull action){
                                                             }];
        [alter addAction:cancelAction];
    }
    [controller presentViewController:alter animated:YES completion:nil];
}

- (void)showAlertLogErrorController:(UIViewController *)controller message:(NSString *)message {
    [self addAlertRemindWithController:controller
                                 title:@""
                               message:message
                     cancelButtonTitle:nil
                     otherButtonTitles:@[ @"好的" ]
                  clickedButtonAtIndex:^(NSInteger buttonIndex){
                  }];
}

@end
