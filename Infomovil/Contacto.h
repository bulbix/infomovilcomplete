//
//  Contacto.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 27/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contacto : NSObject <NSCoding,NSCopying>

@property (nonatomic, strong) NSString *noContacto;
@property (nonatomic, strong) NSString *descripcion;
@property BOOL activo;
@property BOOL habilitado;
@property (nonatomic, strong) NSString *valorVisible;
@property NSInteger indice;
@property (nonatomic, strong) NSString *lada;
@property (nonatomic, strong) NSString *pais;
@property (nonatomic, strong) NSString *idPais;
@property (nonatomic) NSInteger idContacto;
@property (nonatomic, strong) NSString *valorContacto;
@property (nonatomic, strong) NSString *servicio;
@property (nonatomic, strong) NSString *subCategoria;

-(id) initWithNumber:(NSString *)noContacto description:(NSString *)descripcion andStatus:(BOOL)activo;

@end
