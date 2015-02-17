//
//  InformacionRegistro.h
//  Infomovil
//
//  Created by Ivan Peña on 25/03/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InformacionRegistro : NSObject <NSCoding>

@property (nonatomic) BOOL tipoRegistro;

@property (nonatomic, strong) NSString * nombreOrganizacion;
@property (nonatomic, strong) NSString * servicioCliente;
@property (nonatomic, strong) NSString * numeroMovil;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * calleNumero;
@property (nonatomic, strong) NSString * poblacion;
@property (nonatomic, strong) NSString * ciudad;
@property (nonatomic, strong) NSString * estado;
@property (nonatomic, strong) NSString * cp;
@property (nonatomic, strong) NSString * pais;
@property (nonatomic, strong) NSString * codigoPais;

-(id) initWithService:(NSString *)servicioCliente;

@end
