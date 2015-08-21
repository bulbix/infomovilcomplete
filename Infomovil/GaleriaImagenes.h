//
//  GaleriaImagenes.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 07/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GaleriaImagenes : NSObject <NSCoding>


//@property (nonatomic) NSInteger ancho;
//@property (nonatomic) NSInteger alto;


// Estos valores los utilizo para las imagenes los demas no!//
@property (nonatomic, strong) NSString *imagenIdAux;
@property (nonatomic, strong) NSString *rutaImagen;
@property (nonatomic) NSInteger idImagen;
@property (nonatomic, strong) NSString *pieFoto;
/////////////////////////////////////////////////////////////

-(id) initWithPath:(NSString *)ruta andFooter:(NSString *)pie;

@end
