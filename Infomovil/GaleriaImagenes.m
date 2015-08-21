//
//  GaleriaImagenes.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 07/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "GaleriaImagenes.h"

@implementation GaleriaImagenes

@synthesize rutaImagen, pieFoto, idImagen;
//@synthesize ancho, alto, ;

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
    idImagen = [aDecoder decodeIntegerForKey:@"idImagen"];
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:rutaImagen forKey:@"rutaImagenGaleria"];
    [aCoder encodeInteger:idImagen forKey:@"idImagen"];
}
@end
