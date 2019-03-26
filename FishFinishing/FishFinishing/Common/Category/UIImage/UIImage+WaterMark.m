//
//  UIImage+WaterMark.m
//  KenuoTraining
//
//  Created by Robert on 16/4/20.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "UIImage+WaterMark.h"
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "UIImage+Alpha.m"

const int wLeft = 50;
const int wTop = 50;


@implementation UIImage (WaterMark)

+ (UIImage *)imageWithText:(NSString *)text frame:(CGRect)frame {
    NSUInteger GapH = KNB_SCREEN_WIDTH / 3;
    NSUInteger GapV = KNB_SCREEN_HEIGHT / 3;

    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0);

    NSUInteger totalX = 0;
    NSUInteger totalY = 0;
    NSUInteger textX = 0;
    NSUInteger textY = 0;
    NSUInteger textWidth = 50;
    NSUInteger textHeight = 20;

    while (totalY < frame.size.height) {
        textX = wLeft + totalX;
        textY = wTop + totalY;

        totalX += textWidth + GapH;

        if (totalX >= frame.size.width) {
            totalX = textWidth + GapH;
            textX = wLeft;
            totalY += textHeight + GapV;
            textY = totalY + wTop;
        }

        CGRect frame = CGRectMake(textX, textY, textWidth, textHeight);

        CGContextRef context = UIGraphicsGetCurrentContext();

        CGContextSaveGState(context);

        CGPoint point = frame.origin;

        CGContextTranslateCTM(context, point.x, point.y);
        CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI_4);
        CGContextConcatCTM(context, transform);
        CGContextTranslateCTM(context, -point.x, -point.y);

        NSDictionary *attributeDict =
            @{
                NSFontAttributeName : [UIFont boldSystemFontOfSize:14],
                NSForegroundColorAttributeName : [UIColor whiteColor],
                NSStrokeColorAttributeName : [UIColor lightGrayColor],
                NSStrokeWidthAttributeName : @(2)
            };
        [text drawInRect:frame withAttributes:attributeDict];

        CGContextRestoreGState(context);
    }

    UIImage *waterIconImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return waterIconImage;
}

- (UIImage *)maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    CGImageRef maskRef = maskImage.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);

    CGImageRef maskedRef = CGImageCreateWithMask([image CGImage], mask);
    UIImage *resultImage = [UIImage imageWithCGImage:maskedRef];
    CGImageRelease(mask);
    CGImageRelease(maskedRef);
    //    CGImageRef sourceImage = [image CGImage];
    //    CGImageRef imageWithAlpha = sourceImage;
    //    //add alpha channel for images that don't have one (ie GIF, JPEG, etc...)
    //    //this however has a computational cost
    //    if (CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNone) {
    ////                imageWithAlpha =CopyImageAndAddAlphaChannel(sourceImage);
    //    }
    //
    //    CGImageRef masked = CGImageCreateWithMask(imageWithAlpha, mask);
    //
    //    CGImageRelease(mask);
    //
    //    if (sourceImage != imageWithAlpha) {
    //        CGImageRelease(imageWithAlpha);
    //    }
    //
    //    UIImage* retImage = [UIImage imageWithCGImage:masked];
    //    CGImageRelease(masked);

    return resultImage;
}

- (UIImage *)blurredImageWithRadius:(CGFloat)radius
                         iterations:(NSUInteger)iterations
                          tintColor:(UIColor *)tintColor {
    UIImage *originImage = self;
    //image must be nonzero size
    if (floorf(self.size.width) * floorf(self.size.height) <= 0.0f) return self;

    //boxsize must be an odd integer
    uint32_t boxSize = (uint32_t)(radius * self.scale);
    if (boxSize % 2 == 0) boxSize++;

    //create image buffers
    CGImageRef imageRef = self.CGImage;

    //convert to ARGB if it isn't
    if (CGImageGetBitsPerPixel(imageRef) != 32 ||
        CGImageGetBitsPerComponent(imageRef) != 8 ||
        !((CGImageGetBitmapInfo(imageRef) & kCGBitmapAlphaInfoMask))) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
        [self drawAtPoint:CGPointZero];
        imageRef = UIGraphicsGetImageFromCurrentImageContext().CGImage;
        UIGraphicsEndImageContext();
    }

    vImage_Buffer buffer1, buffer2;
    buffer1.width = buffer2.width = CGImageGetWidth(imageRef);
    buffer1.height = buffer2.height = CGImageGetHeight(imageRef);
    buffer1.rowBytes = buffer2.rowBytes = CGImageGetBytesPerRow(imageRef);
    size_t bytes = buffer1.rowBytes * buffer1.height;
    buffer1.data = malloc(bytes);
    buffer2.data = malloc(bytes);

    if (NULL == buffer1.data || NULL == buffer2.data) {
        free(buffer1.data);
        free(buffer2.data);
        return self;
    }

    //create temp buffer
    void *tempBuffer = malloc((size_t)vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, NULL, 0, 0, boxSize, boxSize,
                                                                 NULL, kvImageEdgeExtend + kvImageGetTempBufferSize));

    //copy image data
    CGDataProviderRef provider = CGImageGetDataProvider(imageRef);
    CFDataRef dataSource = CGDataProviderCopyData(provider);
    if (NULL == dataSource) {
        return originImage;
    }
    const UInt8 *dataSourceData = CFDataGetBytePtr(dataSource);
    CFIndex dataSourceLength = CFDataGetLength(dataSource);
    memcpy(buffer1.data, dataSourceData, MIN((CFIndex)bytes, dataSourceLength));
    CFRelease(dataSource);

    for (NSUInteger i = 0; i < iterations; i++) {
        //perform blur
        vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);

        //swap buffers
        void *temp = buffer1.data;
        buffer1.data = buffer2.data;
        buffer2.data = temp;
    }

    //free buffers
    free(buffer2.data);
    free(tempBuffer);

    //create image context from buffer
    CGContextRef ctx = CGBitmapContextCreate(buffer1.data, buffer1.width, buffer1.height,
                                             8, buffer1.rowBytes, CGImageGetColorSpace(imageRef),
                                             CGImageGetBitmapInfo(imageRef));

    //apply tint
    if (tintColor && CGColorGetAlpha(tintColor.CGColor) > 0.0f) {
        CGContextSetFillColorWithColor(ctx, [tintColor colorWithAlphaComponent:0.25].CGColor);
        CGContextSetBlendMode(ctx, kCGBlendModePlusLighter);
        CGContextFillRect(ctx, CGRectMake(0, 0, buffer1.width, buffer1.height));
    }

    //create image from context
    imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    CGContextRelease(ctx);
    free(buffer1.data);
    return image;
}


@end
