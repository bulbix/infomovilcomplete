//
//  InformacionAdicional.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 12/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "InformacionAdicional.h"

@implementation InformacionAdicional

@synthesize tituloInformacion, descripcionInformacion;

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return Nil;
    }
    
    tituloInformacion = [aDecoder decodeObjectForKey:@"tituloAdicional"];
    descripcionInformacion = [aDecoder decodeObjectForKey:@"descripcionAdicional"];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:tituloInformacion forKey:@"tituloAdicional"];
    [aCoder encodeObject:descripcionInformacion forKey:@"descripcionAdicional"];
}

@end
