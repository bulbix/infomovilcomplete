//
//  ImageUtils.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 14/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "ImageUtils.h"

@implementation ImageUtils

+ (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    float width = newSize.width;
    float height = newSize.height;
    
    UIGraphicsBeginImageContext(newSize);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    float widthRatio = image.size.width / width;
    float heightRatio = image.size.height / height;
    float divisor = widthRatio > heightRatio ? widthRatio : heightRatio;
    
    width = image.size.width / divisor;
    height = image.size.height / divisor;
    
    rect.size.width  = width;
    rect.size.height = height;
    
    //indent in case of width or height difference
//    float offset = (width - height) / 2;
//    if (offset > 0) {
//        rect.origin.y = offset;
//    }
//    else {
//        rect.origin.x = -offset;
//    }
    
    [image drawInRect: rect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return smallImage;
}

//CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
//CGImageRef imageRef = image.CGImage;
//
//UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
//CGContextRef context = UIGraphicsGetCurrentContext();
//
//CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
//CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
//
//CGContextConcatCTM(context, flipVertical);
//CGContextDrawImage(context, newRect, imageRef);
//
//CGImageRef newImageRef = CGBitmapContextCreateImage(context);
//UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
//
//CGImageRelease(newImageRef);
//UIGraphicsEndImageContext();
//
//return newImage;

@end
