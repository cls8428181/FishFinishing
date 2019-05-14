//
//  UIImage+QRCode.m
//  KenuoTraining
//
//  Created by 妖狐小子 on 2017/4/28.
//  Copyright © 2017年 Robert. All rights reserved.
//

#import "UIImage+QRCode.h"


@implementation UIImage (QRCode)

+ (UIImage *)imageWithUrlLinkString:(NSString *)link size:(CGSize)size {
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    // 为二维码准备背后的二进制数据
    NSData *data = [link dataUsingEncoding:NSUTF8StringEncoding];
    // 使用kvc的方式将data赋给filter
    [filter setValue:data forKey:@"inputMessage"];
    // 生成图片
    CIImage *outputImage = [filter outputImage];
    // 不带icon的图片
    UIImage *qrImage = [self createNonInterpolatedUIImageFormCIImage:outputImage size:size];
    // 带icon的图片
    UIImage *image = [self addSmallImageForQRImage:qrImage];
    return image;
}
+ (UIImage *)smartWithURLString:(NSString *)url size:(CGSize)size {
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    // 为二维码准备背后的二进制数据
    NSData *data = [url dataUsingEncoding:NSUTF8StringEncoding];
    // 使用kvc的方式将data赋给filter
    [filter setValue:data forKey:@"inputMessage"];
    // 生成图片
    CIImage *outputImage = [filter outputImage];
    // 不带icon的图片
    UIImage *qrImage = [self createNonInterpolatedUIImageFormCIImage:outputImage size:size];
    return qrImage;
}
/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param size  图片宽度
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)ciImage size:(CGSize)size {
    CGRect extent = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(size.width / CGRectGetWidth(extent), size.height / CGRectGetHeight(extent));

    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);

    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);

    UIImage *qrImage = [UIImage imageWithCGImage:scaledImage]; // 不带icon的图片
    return qrImage;
}

/** 在二维码中心加一个小图 */
+ (UIImage *)addSmallImageForQRImage:(UIImage *)qrImage {
    UIGraphicsBeginImageContextWithOptions(qrImage.size, NO, [[UIScreen mainScreen] scale]);
    [qrImage drawInRect:CGRectMake(0, 0, qrImage.size.width, qrImage.size.height)];
    UIImage *image = [UIImage imageNamed:@"app_icon"];
    CGFloat imageW = 50;
    CGFloat imageX = (qrImage.size.width - imageW) * 0.5;
    CGFloat imgaeY = (qrImage.size.height - imageW) * 0.5;
    [image drawInRect:CGRectMake(imageX, imgaeY, imageW, imageW)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

+ (UIImage *)imageWithUrlLinkString:(NSString *)link size:(CGSize)size insertImage:(UIImage *)insertImage
                        roundRadius: (CGFloat)roundRadius photoSize:(CGSize)photoSize{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    // 为二维码准备背后的二进制数据
    NSData *data = [link dataUsingEncoding:NSUTF8StringEncoding];
    // 使用kvc的方式将data赋给filter
    [filter setValue:data forKey:@"inputMessage"];
    // 生成图片
    CIImage *outputImage = [filter outputImage];
    // 不带icon的图片
    UIImage *qrImage = [self createNonInterpolatedUIImageFormCIImage:outputImage size:size];
    // 带icon的图片
    UIImage *image = [self imageInsertedImage:qrImage insertImage:insertImage radius:roundRadius photoSize:photoSize];
    return image;
}
/*!
 *
 * @abstract
 * 在二维码图上进行图片插入，如插入图为空，直接返回二维码图
 */
+ (UIImage *)imageInsertedImage: (UIImage *)originImage insertImage: (UIImage *)insertImage radius: (CGFloat)radius photoSize:(CGSize)photoSize
{
    if (!insertImage) {
        return originImage;
    }
    insertImage = [UIImage imageOfRoundRectWithImage: insertImage size: insertImage.size radius: insertImage.size.width * radius/photoSize.width];
    UIImage * whiteBG = [UIImage imageNamed: @"whiteBG"];
    whiteBG = [UIImage imageOfRoundRectWithImage: whiteBG size: whiteBG.size radius: whiteBG.size.width * radius/photoSize.width];

    //白色边缘宽度
    const CGFloat whiteSize = 2.f;
    CGSize brinkSize = CGSizeMake(originImage.size.width / 4, originImage.size.height / 4);
    CGFloat brinkX = (originImage.size.width - brinkSize.width) * 0.5;
    CGFloat brinkY = (originImage.size.height - brinkSize.height) * 0.5;

    CGSize imageSize = CGSizeMake(brinkSize.width - 2 * whiteSize, brinkSize.height - 2 * whiteSize);
    CGFloat imageX = brinkX + whiteSize;
    CGFloat imageY = brinkY + whiteSize;

    UIGraphicsBeginImageContext(originImage.size);
    [originImage drawInRect: (CGRect){ 0, 0, (originImage.size) }];
    [whiteBG drawInRect: (CGRect){ brinkX, brinkY, (brinkSize) }];
    [insertImage drawInRect: (CGRect){ imageX, imageY, (imageSize) }];
    UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return resultImage;
}

/*!
 * @abstract
 * 给传入的图片设置圆角后返回圆角图片
 */
+ (UIImage *)imageOfRoundRectWithImage: (UIImage *)image size: (CGSize)size radius: (CGFloat)radius
{
    if (!image || (NSNull *)image == [NSNull null]) { return nil; }

    const CGFloat width = size.width;
    const CGFloat height = size.height;

    UIImage * img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, width, height);

    //绘制圆角
    CGContextBeginPath(context);
    addRoundRectToPath(context, rect, radius, img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage: imageMasked];

    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);

    return img;
}

/**
 *  给上下文添加圆角蒙版
 */
void addRoundRectToPath(CGContextRef context, CGRect rect, float radius, CGImageRef image)
{
    float width, height;
    if (radius == 0) {
        CGContextAddRect(context, rect);
        return;
    }

    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    width = CGRectGetWidth(rect);
    height = CGRectGetHeight(rect);

    //裁剪路径
    CGContextMoveToPoint(context, width, height / 2);
    CGContextAddArcToPoint(context, width, height, width / 2, height, radius);
    CGContextAddArcToPoint(context, 0, height, 0, height / 2, radius);
    CGContextAddArcToPoint(context, 0, 0, width / 2, 0, radius);
    CGContextAddArcToPoint(context, width, 0, width, height / 2, radius);
    CGContextClosePath(context);
    CGContextClip(context);

    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
    CGContextRestoreGState(context);
}

@end
