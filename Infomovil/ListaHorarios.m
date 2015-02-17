//
//  ListaHorarios.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 11/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "ListaHorarios.h"

@implementation ListaHorarios

@synthesize dia, inicio, cierre, editado;

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return Nil;
    }
    dia = [aDecoder decodeObjectForKey:@"diaHorario"];
    inicio = [aDecoder decodeObjectForKey:@"inicioHorario"];
    cierre = [aDecoder decodeObjectForKey:@"cierreHorario"];
    editado = [aDecoder decodeBoolForKey:@"editadoHorario"];
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:dia forKey:@"diaHorario"];
    [aCoder encodeObject:inicio forKey:@"inicioHorario"];
    [aCoder encodeObject:cierre forKey:@"cierreHorario"];
    [aCoder encodeBool:editado forKey:@"editadoHorario"];
}

- (id)copyWithZone:(NSZone *)zone {
	ListaHorarios * newList = [[[self class] allocWithZone:zone] init];
	
	if(newList){
		[newList setDia:[self dia]];
		[newList setInicio:[self inicio]];
		[newList setCierre:[self cierre]];
		[newList setEditado:[self editado]];
	}
	
	return  newList;
}

@end
