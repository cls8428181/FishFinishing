//
//  KNBNavgationController.m
//  KenuoTraining
//
//  Created by 吴申超 on 16/2/25.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "KNBNavgationController.h"


@interface KNBNavgationController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSArray *nameControllerArray;

@end


@implementation KNBNavgationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    KNB_WS(weakSelf);
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavigationBarHidden:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UINavigationControllerDelegate
- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = NO;

    [super pushViewController:viewController animated:animated];
}

//设置界面不能侧滑返回的界面
- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate {
    // Enable the gesture again once the new controller is shown
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        NSString *clsStr = NSStringFromClass([viewController class]);
        BOOL contain = [self.nameControllerArray containsObject:clsStr];
        self.interactivePopGestureRecognizer.enabled = !contain;
    }
    if (navigationController.childViewControllers.count < 2)
        self.interactivePopGestureRecognizer.enabled = NO;
}

//设置界面不能侧滑返回的界面
- (NSArray *)nameControllerArray {
    if (!_nameControllerArray) {
        _nameControllerArray = @[ @""];
    }
    return _nameControllerArray;
}

@end
