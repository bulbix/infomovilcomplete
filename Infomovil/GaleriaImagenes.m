//
//  GaleriaImagenes.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 07/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "GaleriaImagenes.h"

@implementation GaleriaImagenes

@synthesize rutaImagen, pieFoto;
@synthesize ancho, alto, idImagen;

-(id) initWithPath:(NSString *)ruta andFooter:(NSString *)pie {
    self = [super init];
    if (self) {
        rutaImagen = ruta;
        pieFoto = pie;
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    rutaImagen = [aDecoder decodeObjectForKey:@"rutaImagenGaleria"];
  //  pieFoto = [aDecoder decodeObjectForKey:@"pieFoto"];
  //  ancho = [aDecoder decodeIntegerForKey:@"anchoFoto"];
  //  alto = [aDecoder decodeIntegerForKey:@"altoFoto"];
    idImagen = [aDecoder decodeIntegerForKey:@"idImagen"];
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:rutaImagen forKey:@"rutaImagenGaleria"];
  //  [aCoder encodeObject:pieFoto forKey:@"pieFoto"];
  //  [aCoder encodeInteger:ancho forKey:@"anchoFoto"];
  //  [aCoder encodeInteger:alto forKey:@"altoFoto"];
    [aCoder encodeInteger:idImagen forKey:@"idImagen"];
}
@end
