//
//  InformacionRegistro.m
//  Infomovil
//
//  Created by Ivan Peña on 25/03/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InformacionRegistro.h"

@implementation InformacionRegistro


-(id) initWithService:(NSString *)servicioCliente{
	
	self = [super init];
    if (self) {
        self.servicioCliente = servicioCliente;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return nil;
    }
	
	
	self.tipoRegistro = [aDecoder decodeBoolForKey:@"tipoRegistro"];
	
	self.nombreOrganizacion = [aDecoder decodeObjectForKey:@"nombreOrganizacion"];
	self.servicioCliente = [aDecoder decodeObjectForKey:@"servicioCliente"];
	self.numeroMovil = [aDecoder decodeObjectForKey:@"numeroMovil"];
	self.email = [aDecoder decodeObjectForKey:@"email"];
	self.calleNumero = [aDecoder decodeObjectForKey:@"calleNumero"];
	self.poblacion = [aDecoder decodeObjectForKey:@"poblacion"];
	self.ciudad = [aDecoder decodeObjectForKey:@"ciudad"];
	self.estado = [aDecoder decodeObjectForKey:@"estado"];
	self.cp = [aDecoder decodeObjectForKey:@"cp"];
	self.pais = [aDecoder decodeObjectForKey:@"pais"];
	self.pais = [aDecoder decodeObjectForKey:@"codigoPais"];
	
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	
	[aCoder encodeBool:self.tipoRegistro forKey:@"tipoRegistro"];
	
	[aCoder encodeObject:self.nombreOrganizacion forKey:@"nombreOrganizacion"];
	[aCoder encodeObject:self.servicioCliente forKey:@"servicioCliente"];
	[aCoder encodeObject:self.numeroMovil forKey:@"numeroMovil"];
	[aCoder encodeObject:self.email forKey:@"email"];
	[aCoder encodeObject:self.calleNumero forKey:@"calleNumero"];
	[aCoder encodeObject:self.poblacion forKey:@"poblacion"];
	[aCoder encodeObject:self.ciudad forKey:@"ciudad"];
	[aCoder encodeObject:self.estado forKey:@"estado"];
	[aCoder encodeObject:self.cp forKey:@"cp"];
	[aCoder encodeObject:self.pais forKey:@"codigoPais"];
	
}

/*-(void)copiaPropiedades:(DatosUsuario *) datosOrigen {
	
	self.nombreOrganizacion = datosOrigen.nombreOrganizacion;
	self.servicioCliente = datosOrigen.servicioCliente;
	self.numeroMovil = datosOrigen.numeroMovil;
	self.email = datosOrigen.email;
	self.calleNumero = datosOrigen.calleNumero;
	self.poblacion = datosOrigen.poblacion;
	self.ciudad = datosOrigen.ciudad;
	self.estado = datosOrigen.estado;
	self.cp = datosOrigen.cp;
	self.pais = datosOrigen.pais;
}*/

@end
