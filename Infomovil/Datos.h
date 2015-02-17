//
//  Datos.h
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 06/02/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Datos : NSObject <NSCoding>

@property(nonatomic, strong) NSString *tituloMostrar;
@property BOOL estatus;
@property (nonatomic, strong) NSString *tituloAux;

-(id) initWithTitle:(NSString *)titulo andStatus:(BOOL)status;
-(id) initWithTitle:(NSString *)titulo withSpanishTitle:(NSString *)spanishTitle andStatus:(BOOL)status;

@end
