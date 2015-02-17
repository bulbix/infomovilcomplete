//
//  Datos.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 06/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "Datos.h"

@implementation Datos

@synthesize tituloMostrar, estatus, tituloAux;

-(id) initWithTitle:(NSString *)titulo andStatus:(BOOL)status {
    self = [super init];
    if (self) {
        tituloMostrar = titulo;
        estatus = status;
    }
    return self;
}
-(id) initWithTitle:(NSString *)titulo withSpanishTitle:(NSString *)spanishTitle andStatus:(BOOL)status {
    self = [super init];
    if (self) {
        tituloMostrar = titulo;
        tituloAux = spanishTitle;
        estatus = status;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.tituloMostrar = [decoder decodeObjectForKey:@"tituloMostrar"];
    self.estatus = [decoder decodeBoolForKey:@"estatusDato"];
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.tituloMostrar forKey:@"tituloMostrar"];
    [aCoder encodeBool:self.estatus forKey:@"estatusDato"];
}

@end
