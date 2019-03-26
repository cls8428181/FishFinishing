// UIImage+Resize.h
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

// Extends the UIImage class to support resizing/cropping
@interface UIImage (Resize)
- (UIImage *)croppedImage:(CGRect)bounds;
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;
- (CGAffineTransform)transformForOrientation:(CGSize)newSize;

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;


/**
 *  压缩图片到指定大小
 */
- (UIImage *)imageByScalingToSpecifiedSize:(CGSize)targetSize;

/**
 *  压缩图片质量到指定大小（单位k 建议 500k － 1000k）
 */
- (NSData *)dealImageMaxFileSize:(CGFloat)maxFileSize;

/**
 裁剪图片
 
 @param image 原图片
 @param size 图片比例
 @return 裁剪后的图片
 */
+ (UIImage *)clipImage:(UIImage *)image toRect:(CGSize)size;

//智能测肤 压缩图片
- (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;
/**进行切圆角的操作*/
- (UIImage *)imageWithCornerRadius:(CGFloat)radius;
@end
