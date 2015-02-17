//
//  UIView+LayerShot.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 15/04/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "UIView+LayerShot.h"

@implementation UIView (LayerShot)

- (UIImage *)imageFromLayer {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
