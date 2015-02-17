//
//  Contacto.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 27/01/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "Contacto.h"

@implementation Contacto
-(id) initWithNumber:(NSString *)noContacto description:(NSString *)descripcion andStatus:(BOOL)activo {
    self = [super init];
    if (self) {
        self.noContacto = noContacto;
        self.descripcion = descripcion;
        self.activo = activo;
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return Nil;
    }
    
    self.noContacto = [aDecoder decodeObjectForKey:@"numeroContacto"];
    self.descripcion = [aDecoder decodeObjectForKey:@"descripcionContacto"];
    self.activo = [aDecoder decodeBoolForKey:@"activoContacto"];
    self.habilitado = [aDecoder decodeBoolForKey:@"habilitadoContacto"];
    self.indice = [aDecoder decodeIntegerForKey:@"indiceContacto"];
    self.lada = [aDecoder decodeObjectForKey:@"ladaContacto"];
    self.pais = [aDecoder decodeObjectForKey:@"paisContacto"];
    self.idPais = [aDecoder decodeObjectForKey:@"idPaisContacto"];
    self.idContacto = [aDecoder decodeIntegerForKey:@"idContacto"];
    self.servicio = [aDecoder decodeObjectForKey:@"servicioContacto"];
    
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.noContacto forKey:@"numeroContacto"];
    [aCoder encodeObject:self.descripcion forKey:@"descripcionContacto"];
    [aCoder encodeBool:self.activo forKey:@"activoContacto"];
    [aCoder encodeBool:self.habilitado forKey:@"habilitadoContacto"];
    
    [aCoder encodeInteger:self.indice forKey:@"indiceContacto"];
    [aCoder encodeObject:self.lada forKey:@"ladaContacto"];
    [aCoder encodeObject:self.pais forKey:@"paisContacto"];
    [aCoder encodeObject:self.idPais forKey:@"idPaisContacto"];
    
    [aCoder encodeInteger:self.idContacto forKey:@"idContacto"];
    [aCoder encodeObject:self.servicio forKey:@"servicioContacto"];
}

-(id)copyWithZone:(NSZone *)zone{
	
	id copy = [[[self class] alloc] init];
	
	if (copy) {
        // Copy NSObject subclasses
        [copy setNoContacto:[self.noContacto copyWithZone:zone]];
		[copy setDescripcion:[self.descripcion copyWithZone:zone]];
		[copy setLada:[self.lada copyWithZone:zone]];
		[copy setPais:[self.pais copyWithZone:zone]];
		[copy setIdPais:[self.idPais copyWithZone:zone]];
		[copy setServicio:[self.servicio copyWithZone:zone]];
        
		
        // Set primitives
		[copy setActivo:self.activo];
		[copy setHabilitado:self.habilitado];
		[copy setIndice:self.indice];
		[copy setIdContacto:self.idContacto];
    }
	
    return copy;
}

@end
