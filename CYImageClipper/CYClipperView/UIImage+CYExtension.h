//
//  UIImage+Resize.h
//  SCCaptureCameraDemo
//
//  Created by chenyan on 14-1-17.
//  Copyright (c) 2014年 chenyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

/**
 *  用相机拍摄出来的照片含有EXIF信息，UIImage的imageOrientation属性指的就是EXIF中的orientation信息。如果我们忽略orientation信息，而直接对照片进行像素处理或者drawInRect等操作，得到的结果是翻转或者旋转90之后的样子。这是因为我们执行像素处理或者drawInRect等操作之后，imageOrientaion信息被删除了，imageOrientaion被重设为0，造成照片内容和imageOrientaion不匹配。所以，在对照片进行处理之前，先将照片旋转到正确的方向，并且返回的imageOrientaion为0。
 */
- (UIImage *)fixOrientation;

#pragma mark - copy or scale image
/** 复制图片 */
- (UIImage *)copyImage;
- (UIImage *)copyImageToNewSize:(CGSize)size;
- (UIImage *)copyImageToNewWidth:(CGFloat)width;
- (UIImage *)copyImageToNewHeight:(CGFloat)height;

#pragma mark - cut image



#pragma mark - resize image

- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  size:(CGSize)size
                    interpolationQuality:(CGInterpolationQuality)quality;


#pragma mark - rotate image
/** 旋转指定角度 */
- (UIImage *)rotatedByDegrees:(CGFloat)degrees;

#pragma mark - 类方法
+ (UIImage*)createImageWithColor:(UIColor*)color size:(CGSize)imageSize;

+ (void)drawALineWithFrame:(CGRect)frame andColor:(UIColor*)color inLayer:(CALayer*)parentLayer;

+ (void)saveImageToPhotoAlbum:(UIImage*)image;
/** 生成高斯模糊图片 */
+ (void)imageCoreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur backImage:(void(^)(UIImage *image))backImage;
@end
