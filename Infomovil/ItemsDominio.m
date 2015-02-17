//
//  ItemsDominio.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 08/04/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "ItemsDominio.h"

@implementation ItemsDominio


-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return Nil;
    }
    self.descripcionItem = [aDecoder decodeObjectForKey:@"descripcionItemDominio"];
    self.estatus = [aDecoder decodeIntegerForKey:@"estatusItem"];
    
    return self;
}


-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.descripcionItem forKey:@"descripcionItemDominio"];
    [aCoder encodeInteger:self.estatus forKey:@"descripcionItem"];
}

-(id) initWithDescripcion:(NSString *)descripcion andStatus:(NSInteger)status {
    self = [super init];
    if (self) {
        self.descripcionIdioma = descripcion;
        self.descripcionItem = descripcion;
        self.estatus = status;
    }
    return self;
}


@end
