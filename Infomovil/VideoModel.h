//
//  VideoModel.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 13/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject <NSCoding>

@property (nonatomic, strong) NSString *autor;
@property (nonatomic, strong) NSString *titulo;
@property (nonatomic, strong) NSArray *link;
@property (nonatomic, strong) NSString *thumbnail;
@property (nonatomic, strong) UIImage *imagenPrevia;

@property (nonatomic, strong) NSString *linkSolo;
@property (nonatomic, strong) NSString *idVideo;
@property (nonatomic, strong) NSString *pathImagen;

@property (nonatomic, strong) NSString *categoria;
@property (nonatomic, strong) NSString *descripcionVideo;

@end
