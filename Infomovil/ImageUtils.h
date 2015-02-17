//
//  ImageUtils.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 14/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageUtils : NSObject

+ (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize;

@end
