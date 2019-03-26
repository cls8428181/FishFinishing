//
//  UIImage+QRCode.h
//  KenuoTraining
//
//  Created by 妖狐小子 on 2017/4/28.
//  Copyright © 2017年 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (QRCode)

+ (UIImage *)imageWithUrlLinkString:(NSString *)link size:(CGSize)size;

//新零售二维码图片
+ (UIImage *)smartWithURLString:(NSString *)url size:(CGSize)size;

+ (UIImage *)imageWithUrlLinkString:(NSString *)link size:(CGSize)size insertImage:(UIImage *)insertImage
                        roundRadius: (CGFloat)roundRadius photoSize:(CGSize)photoSize;
@end
